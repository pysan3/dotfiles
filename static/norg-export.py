from __future__ import annotations

import re
import argparse
from dataclasses import dataclass
from pathlib import Path
from subprocess import DEVNULL, check_call, Popen, PIPE
import sys
import json
import tempfile
from typing import Any


@dataclass
class ParseArgs:
    input: Path
    output: Path
    force: bool
    concat: bool
    norg_pandoc: Path
    unknown: list[str]


def parse_args(_args: list[str]):
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-i", "--input", type=str, required=True, help="Input Directory. Files will be scanned recursively."
    )
    parser.add_argument("-o", "--output", type=str, required=True, help="Output Directory or file when `--concat`.")
    parser.add_argument("-f", "--force", action="store_true", help="Overwrite file without confirmation.")
    parser.add_argument(
        "--concat",
        action="store_true",
        help="Concat all files into one output file. When true, `-o` + `.norg` is created instead.",
    )
    parser.add_argument(
        "--norg_pandoc",
        type=str,
        default="~/tmp/norg_pandoc",
        help="Path to norg-pandoc. If not found, automatically git-cloned.",
    )

    parsed, unknown = parser.parse_known_args(_args)
    args = ParseArgs(
        input=Path(parsed.input).expanduser().absolute(),
        output=Path(parsed.output).expanduser().absolute(),
        force=bool(parsed.force),
        concat=bool(parsed.concat),
        norg_pandoc=Path(parsed.norg_pandoc).expanduser().absolute(),
        unknown=unknown,
    )
    assert args.input.exists(), f"{args.input=} is not found."
    return args


def prepare_norg_pandoc(dir: Path):
    if dir.is_dir() and (dir / "init.lua").exists():
        print(f"norg-pandoc is found at {dir}")
        return True
    if input(f"norg-pandoc not found at {dir}. Install? [Y/n] ") in ["n", "N"]:
        raise RuntimeError("norg-pandoc not found. Please specify path with `--norg_pandoc`.")
    dir.parent.mkdir(parents=True, exist_ok=True)
    clone = "https://github.com/boltlessengineer/norg-pandoc.git"
    cmd = ["git", "clone", clone, str(dir)]
    popen = Popen(cmd, shell=False, stdout=PIPE, stderr=PIPE)
    for line in popen.stdout or []:
        sys.stdout.write(line.decode())
    result = popen.wait()
    for line in popen.stderr or []:
        sys.stdout.write(line.decode())
    if result != 0:
        raise RuntimeError(f"Something went wrong with '{' '.join(cmd)}'.")


def assert_pandoc():
    check_call(["pandoc", "--help"], shell=False, stdout=DEVNULL)


def search_files(args: ParseArgs):
    if args.input.exists() and args.input.is_file():
        file = args.input
        args.input = args.input.parent
        return [file]
    result: list[Path] = []
    for file in args.input.glob("**/*.norg"):
        if file.exists() and file.is_file() and file.suffix == ".norg":
            result.append(file.absolute())
    return sorted(result)


def is_between_list(before: str, line: str, after: str):
    b = before.strip().startswith("- ")
    a = after.strip().startswith("- ")
    return line == "" and b and a


def is_between_numlist(before: str, line: str, after: str):
    b = re.match(r"^[0-9]+\. .*", before.strip())
    a = re.match(r"^[0-9]+\. .*", after.strip())
    return line == "" and b and a


def process_file(content: list[str]):
    embedded = False
    metadata = False
    result: list[str] = []
    for i in range(0, len(content) - 1):
        if content[i] == "---":
            metadata = i == 0
        if metadata:
            content[i] = content[i].replace(r"\[", "[").replace(r"\]", "]")
        if content[i] == "``` embed":
            embedded = True
            continue
        if embedded and content[i] == "```":
            embedded = False
            continue
        elif content[i].startswith("``` "):
            result.append("```" + content[i][len("``` ") :])  # noqa
            continue
        lines = content[i - 1 : i + 2]  # noqa
        if i >= 1 and (is_between_list(*lines) or is_between_numlist(*lines)):
            continue
        result.append(content[i])
    return result


def list2comma(match: re.Match):
    result = []
    for x in match.groups():
        result.extend(x.split("\n"))
    return "[" + ", ".join(filter(bool, map(lambda x: x.strip(), result))) + "]"


def extract_metadata(content: dict[str, Any], convert: bool = True):
    """
    Args:
        content: Json representation given by pandoc.
        convert: When true, metadata is converted to yaml style. Else ignored.
    """
    blocks: list[Any] = content["blocks"]
    for i, block in enumerate(blocks):
        if block["t"] == "CodeBlock":
            attrs = block["c"][0][1]
            if len(attrs) > 0 and attrs[0] == "document.meta":
                if convert:
                    meta = block["c"][1]
                    converted = "---\n" + re.sub(r"\[([^\]]+)\]", list2comma, meta) + "---\n"
                else:
                    converted = ""
                blocks[i] = {"t": "Para", "c": [{"t": "Str", "c": converted}]}
    content["blocks"] = blocks
    return content


def convert_file(args: ParseArgs, input_file: Path, output_file: Path, metadata: bool = True):
    print(f"Convert {input_file} -> {output_file}.")
    if not args.force and output_file.exists():
        msg = f"{output_file = } exists. Overwrite? [Y/n] "  # noqa
        if input(msg) in ["n", "N"]:
            print(f"Abort. {input_file} not converted.")
            return False
    output_file.parent.mkdir(parents=True, exist_ok=True)
    pandoc_args = {
        "--output": str(output_file),
        "--from": "./init.lua",
        "--to": "json",
    }
    pandoc = ["pandoc", str(input_file)] + [f"{k}={v}" for k, v in pandoc_args.items()] + args.unknown
    result = Popen(pandoc, shell=False, cwd=str(args.norg_pandoc), stdout=DEVNULL)
    result.wait()
    assert output_file.exists(), f"Something went wrong. {output_file} does not exist after '{' '.join(pandoc)}'."
    with output_file.open("r") as f:
        pandoc_content = json.load(f)
        pandoc_content = extract_metadata(pandoc_content, metadata)
    pandoc_args = {
        "--output": str(output_file),
        "--from": "json",
        "--to": "gfm",
        "--wrap": "none",
    }
    pandoc = ["pandoc"] + [f"{k}={v}" for k, v in pandoc_args.items()] + args.unknown
    result = Popen(pandoc, shell=False, cwd=str(args.norg_pandoc), stdin=PIPE, stdout=DEVNULL)
    result.stdin.write(json.dumps(pandoc_content).encode())  # type: ignore
    result.stdin.close()  # type: ignore
    result.wait()
    assert output_file.exists(), f"Something went wrong. {output_file} does not exist after '{' '.join(pandoc)}'."
    with output_file.open("r") as f:
        pandoc_content = f.read().split("\n")
    cleanup_content = process_file(pandoc_content)
    with output_file.open("w") as f:
        f.write("\n".join(cleanup_content))


def convert_each(files: list[Path], args: ParseArgs):
    for file in files:
        convert_file(args, file, args.output / file.relative_to(args.input).with_suffix(".md"))


def concat_all(files: list[Path], args: ParseArgs):
    if len(files) == 0:
        return
    weights: dict[int, list[Path]] = {}
    noweight: list[Path] = []
    for file in files:
        with file.open("r") as f:
            for line in f.read().split("\n"):
                if line.startswith("weight:"):
                    weight = int(line.split(":")[1])
                    weights.setdefault(weight, [])
                    weights[weight].append(file)
                    break
            else:
                noweight.append(file)
    sorted_weights = sorted(weights.keys())
    if len(sorted_weights) == 0:
        weights[0] = noweight
        sorted_weights = [0]
    else:
        weights[sorted_weights[-1]].extend(noweight)  # append no weight files
    first_file = weights[sorted_weights[0]].pop(0)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    dest = args.output.with_suffix(".md")
    convert_file(args, first_file, dest)
    with tempfile.TemporaryDirectory() as td:
        temp_dir = Path(td)
        for w in sorted_weights:
            for file in weights[w]:
                out = temp_dir / file.relative_to(args.input).with_suffix(".md")
                convert_file(args, file, out, False)  # without metadata
                with out.open("r") as r:
                    with dest.open("a") as a:
                        a.write("\n\n" + r.read())
                        print(f"Append {out} to {dest}.")
    print(f"Concatenated all results into {dest}.")


def main():
    assert_pandoc()
    args = parse_args(sys.argv[1:])
    prepare_norg_pandoc(args.norg_pandoc)
    files = search_files(args)
    if args.concat:
        concat_all(files, args)
    else:
        convert_each(files, args)


if __name__ == "__main__":
    main()

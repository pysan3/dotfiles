import sys

stdin = sys.stdin.read()
content = stdin.split("\n")

def is_between_list(before: str, line: str, after: str):
    b = before.strip().startswith("- ")
    a = after.strip().startswith("- ")
    return line == "" and b and a

def process_file():
    embedded = False
    for i in range(0, len(content) - 1):
        if content[i] == "``` embed":
            embedded = True
            continue
        if embedded and content[i] == "```":
            embedded = False
            continue
        if i >= 1 and is_between_list(*content[i-1:i+2]):
            continue
        print(content[i])

if len(stdin) <= 2:
    sys.stdout.write(stdin)
else:
    process_file()

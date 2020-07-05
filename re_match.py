import sys

def main():
    if len(sys.argv) != 2:
        print('you forgot argv')
        return

    cut = sys.argv[1].split('.*?')
    if len(cut) != 2:
        print('invalid syntax')
        return

    print(f'{cut[0]}(?:(?!{cut[0]}|{cut[1]}).)*{cut[1]}')

if __name__ == "__main__":
    main()

function checkyes() {
    result=1
    if [[ x$(basename $SHELL) = x'bash' ]]; then
        read -p "$@ [y/N]: " yn; case "$yn" in [yY]*) result=0;; *) result=1;; esac
    elif [[ x$(basename $SHELL) = x'zsh' ]]; then
        printf "$@ [y/N]: "; if read -q; then result=0; else result=1; fi; echo
    fi
    return $result
}

function checkdependency () {
    if command -v "$1" >/dev/null 2>&1; then
        return 0
    else
        echo 'Seems you do not have `'"$1"'`$1 installed.'
        echo 'Install it and run this script again'
        return 1
    fi
}


#!/bin/sh

set -eux

if [[ "$(uname)" = Darwin ]]; then
  is_macos() {
    return 0
  }

  is_linux() {
    return 1
  }
else
  is_macos() {
    return 1
  }

  is_linux() {
    return 0
  }
fi

is_command() {
  which "$1" &>/dev/null
}

install_curl() {
  if ! is_command curl; then
    if is_macos; then
      brew install curl
    fi
  fi
}

install_git() {
  if ! is_command git; then
    if is_macos; then
      brew install git
    fi
  fi
}

install_npm() {
  if ! is_command npm; then
    if is_macos; then
      brew install node
    fi
  fi
}

install_yarn() {
  if ! is_command yarn; then
    if is_macos; then
      brew install yarn
    fi
  fi
}

if is_command vim &>/dev/null; then
    export PYFILE="$(mktemp)"
    vim -u NORC -n -e -s +'python import sys; import os; open(os.environ["PYFILE"], "w").write(sys.executable)' +qa
    PYTHON="$(cat "$PYFILE")"
    rm -f "$PYFILE"
    unset PYFILE

    if [ "x$PYTHON" = x ]; then
      echo "Your version of vim doesn't support python" >&2
      exit 1
    else
      if ! "$PYTHON" -c 'import pynvim' &>/dev/null; then
        if ! "$PYTHON" -m pip --version &>/dev/null; then
          PYVER="$("$PYTHON" -c 'import sys; v = sys.version_info[:2]; print(str(v[0]) + "." + str(v[1]))')"
          PIP_URL="https://bootstrap.pypa.io/pip/${PYVER}/get-pip.py"
          GET_PIP="$(mktemp)"
          curl -o "$GET_PIP" "$PIP_URL"
          echo "$PYTHON" "$GET_PIP"
          "$PYTHON" "$GET_PIP"
          rm -f "$PIP_URL"
        fi

        "$PYTHON" -m pip install pynvim
      fi
    fi
fi

install_git
install_npm
install_yarn

mkdir -p ~/.vim/plugged
mkdir -p ~/.config/nvim
[ -f ~/.vim/vimrc ] || ln -s ~/.vim/vimrc ~/.vimrc
[ -f ~/.config/nvim/init.vim ] || ln -s ~/.vim/vimrc ~/.config/nvim/init.vim
mkdir -p ~/.vim/plugged/
[ -d ~/.vim/plugged/vim-plug/.git ] || git clone https://github.com/junegunn/vim-plug ~/.vim/plugged/vim-plug

if is_command vim; then
  vim +PlugInstall +qa
fi

if is_command nvim; then
  nvim +PlugInstall +qa
fi

# vim:set ft=sh sw=2 sts=2 et:

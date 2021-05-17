#!/bin/sh

set -eu

if [ "$(uname)" = Darwin ]; then
  is_macos() {
    return 0
  }

  is_linux() {
    return 1
  }

  is_debian() {
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
  which "$1" >/dev/null 2>/dev/null
}

if is_linux; then
  if is_command apt-get; then
    is_debian() {
      return 0
    }
  else
    is_debian() {
      return 1
    }
  fi
fi

install_curl() {
  if ! is_command curl; then
    if is_macos; then
      brew install curl
    elif is_debian; then
      sudo apt-get install -y curl
    fi
  fi
}

install_git() {
  if ! is_command git; then
    if is_macos; then
      brew install git
    elif is_debian; then
      sudo apt-get install -y git
    fi
  fi
}

install_npm() {
  if ! is_command npm; then
    if is_macos; then
      brew install node
    elif is_debian; then
      sudo apt-get install -y nodejs
    fi
  fi
}

install_yarn() {
  if ! is_command yarn; then
    if is_macos; then
      brew install yarn
    elif is_debian; then
      install_npm
      sudo npm install --global yarn
    fi
  fi
}

install_pynvim() {
  sudo npm install --global neovim
}

install_python3() {
  if ! is_command python3; then
    if is_macos; then
      brew install python
    elif is_debian; then
      sudo apt-get install -y python3 python3-pip
    fi
  fi
}

has_python() {
  for py in '' 2 2.7 2.6 3 3.9 3.8 3.7 3.6 3.5 3.4 3.3; do
    pycmd="python${py}"
    if is_command "$pycmd"; then
      return 0
    fi
  done

  return 1
}

install_python() {
  if ! has_python; then
    install_python3
  fi
}

install_extra() {
  if is_macos; then
    for pkg in bat ripgrep the_silver_searcher fzf; do
      if ! brew ls --versions "$pkg" >/dev/null 2>/dev/null; then
        brew install "$pkg"
      fi
    done
  elif is_debian; then
    sudo apt-get install -y bat ripgrep silversearcher-ag fzf
  fi
}

for py in '' 2 2.7 2.6 3 3.9 3.8 3.7 3.6 3.5 3.4 3.3; do
  pycmd="python${py}"
  if is_command "$pycmd"; then
    "$pycmd" ~/.vim/pynvim-install.py
  fi
done

install_python
install_git
install_npm
install_yarn
install_pynvim
install_extra

mkdir -p ~/.vim/plugged
mkdir -p ~/.config/nvim
[ -f ~/.vim/vimrc ] || ln -s ~/.vim/vimrc ~/.vimrc
[ -f ~/.config/nvim/init.vim ] || ln -s ~/.vim/vimrc ~/.config/nvim/init.vim
mkdir -p ~/.vim/plugged/
[ -d ~/.vim/plugged/vim-plug/.git ] || git clone git@github.com:junegunn/vim-plug.git ~/.vim/plugged/vim-plug

if is_command vim; then
  vim +PlugInstall +qa
fi

if is_command nvim; then
  nvim +PlugInstall +qa
fi

# vim:set ft=sh sw=2 sts=2 et:

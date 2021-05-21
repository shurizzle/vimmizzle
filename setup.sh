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

npm_install() {
  if is_macos; then
    npm install -g "$@"
  else
    case "$(which npm)" in
      /usr/bin/*|/bin/*)
        sudo npm install -g "$@"
        ;;
      *)
        npm install -g "$@"
        ;;
    esac
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
      npm_install --global yarn
    fi
  fi
}

install_pynvim() {
  npm_install --global neovim
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

install_composer() {
  if ! is_command composer; then
    if is_command php; then
      if is_macos; then
        brew install composer
      else
        sudo apt-get install -y composer
      fi
    fi
  fi
}

download() {
  if is_command wget; then
    wget -O "$2" "$1"
  else
    curl -o "$2" "$1"
  fi
}

get_stdout() {
  if is_command wget; then
    wget -O- "$1"
  else
    curl "$1"
  fi
}

install_jq() {
  if ! is_command jq; then
    if is_macos; then
      brew install jq
    elif is_debian; then
      sudo apt-get install jq
    fi
  fi
}

gh_latest_release() {
  install_jq
  get_stdout "https://api.github.com/repos/${1}/releases/latest" | jq -r '.name'
}

delta_ver() {
  delta --version | cut -d' ' -f2- -
}

install_delta() {
  if is_macos; then
    if ! is_command delta; then
      brew install git-delta
    fi
  elif is_debian; then
    local repo="dandavison/delta"
    local rel="$(gh_latest_release "$repo")"
    if (! is_command delta) || [ "$(delta_ver)" != "$rel" ]; then
      local tmp="$(mktemp XXXXXXXXXXXXXXXXXXXXXXXXXXXXX.deb)"
      if download "https://github.com/${repo}/releases/download/${rel}/git-delta-musl_${rel}_amd64.deb" "$tmp"; then
        if sudo dpkg -i "$tmp"; then
          local code=$?
        else
          local code=$?
        fi

        rm -f "$tmp"
        return $code
      else
        rm -f "$tmp"
        return 1
      fi
    fi
  fi
}

install_extra() {
  if is_macos; then
    for pkg in bat ripgrep the_silver_searcher fzf watchman; do
      if ! brew ls --versions "$pkg" >/dev/null 2>/dev/null; then
        brew install "$pkg"
      fi
    done
  elif is_debian; then
    sudo apt-get install -y bat ripgrep silversearcher-ag fzf watchman
  fi
  npm_install eslint
  install_composer
  install_delta
}

install_neovim_gem() {
  if is_debian; then
    sudo apt-get install -y ruby-dev build-essential
  fi

  if is_command gem; then
    gem install --user neovim
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

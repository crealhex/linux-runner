#!/bin/bash

# Setup colors
RED=$(printf '\033[31m')
GREEN=$(printf '\033[32m')
YELLOW=$(printf '\033[33m')
BLUE=$(printf '\033[34m')
BOLD=$(printf '\033[1m')
RESET=$(printf '\033[m')

# Setup settings
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
RUNNER=${RUNNER:-~/.linux-runner}
REPO=${REPO:-crealhex/linux-runner}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-master}

cat << EOF

Welcome to Linux Runner 0.4
Running from ${YELLOW}`pwd`${RESET}

${GREEN}Starting package installations...${RESET}

EOF

sudo apt-get update
# && apt-get upgrade -y

cat << EOF

Updates Finished
${GREEN}Running terminal configurations...${RESET}

EOF

# Install some general packages
sudo apt install zsh tree -y

# Install zsh package
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install powerlevel10k zsh theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

# [REPLACE] ZSH_THEME="robbyrussell"
sed -ri 's/(ZSH_THEME=")([a-zA-Z]+)(")/\1powerlevel10k\/powerlevel10k\3/g' ~/.zshrc

# Change default shell to zsh
chsh -s $(which zsh)

# Clone and copy my personal configuration
git clone --depth=1 --branch "$BRANCH" "$REMOTE" "$RUNNER"
cp ~/.linux-runner/.p10k.zsh ~/
cp ~/.linux-runner/.zshrc ~/

# Install latest bat release
wget "https://github.com/sharkdp/bat/releases/download/v0.18.3/bat-musl_0.18.3_amd64.deb" -O bat_amd64.deb
sudo dpkg -i bat_amd64.deb && rm $_

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Add a method for fzf previews in .zshrc
cat << EOF >> ~/.zshrc

# Ddding some preview configs for fzf
_fzf_comprun() {
  local command=\$1
  shift

  case "\$command" in
    cd)           fzf "\$@" --preview 'tree -C {} | head -200' ;;
    export|unset) fzf "\$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "\$@" --preview 'dig {}' ;;
    *)            fzf "\$@" ;;
  esac
}

EOF

# Install plugin hacker-quotes
git clone https://github.com/oldratlee/hacker-quotes.git $ZSH_CUSTOM/plugins/hacker-quotes

# Install plugin k
git clone https://github.com/supercrabtree/k $ZSH_CUSTOM/plugins/k

# Install plugin zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

# Install plugin bgnotify
git clone https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/bgnotify $ZSH_CUSTOM/plugins/bgnotify

# Install plugin zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
cp ~/.linux-runner/configs/zsh-syntax-highlighting.zsh $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/

# Install enhancd
git clone https://github.com/b4b4r07/enhancd ~/.enhancd
echo "source ~/.enhancd/init.sh"  >> ~/.bash_profile

cat << EOF >> ~/.zshrc
# Disable highlighting of pasted text
zle_highlight=('paste:none')
EOF

# Read all configs from fzf binary
source ~/.fzf.zsh

# cp /mnt/c/Users/warender/Desktop/ubuntu-runner/runner.sh .
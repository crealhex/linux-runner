#!/bin/bash

# Setup Colors
RED=$(printf '\033[31m')
GREEN=$(printf '\033[32m')
YELLOW=$(printf '\033[33m')
BLUE=$(printf '\033[34m')
BOLD=$(printf '\033[1m')
RESET=$(printf '\033[m')

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
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

# [REPLACE] ZSH_THEME="robbyrussell"
sed -ri 's/(ZSH_THEME=")([a-zA-Z]+)(")/\1powerlevel10k\/powerlevel10k\3/g' ~/.zshrc

# Change default shell to zsh
chsh -s $(which zsh)

# Ubuntu-Runner settings
RUNNER=${RUNNER:-~/.linux-runner}
REPO=${REPO:-crealhex/linux-runner}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-master}

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

# adding some preview configs for fzf
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

#Install plugin zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install plugin zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
cp ~/.linux-runner/zsh-syntax-highlighting.zsh $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/

# Install plugin k
git clone https://github.com/supercrabtree/k $ZSH_CUSTOM/plugins/k

# cp /mnt/c/Users/warender/Desktop/ubuntu-runner/runner.sh .
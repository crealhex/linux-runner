#!/bin/bash
#
# This script should be run via curl:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/crealhex/cereal-runner/master/runner.sh)"
#
#

# Setup colors
RED=$(printf '\033[31m')
GREEN=$(printf '\033[32m')
YELLOW=$(printf '\033[33m')
BLUE=$(printf '\033[34m')
BOLD=$(printf '\033[1m')
RESET=$(printf '\033[m')

# Setup options
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
RUNNER=${RUNNER:-~/.cereal-runner}
REPO=${REPO:-crealhex/cereal-runner}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-master}

cat << EOF

              Welcome to Cereal Runner 1.2

Running from ${GREEN}`pwd`${RESET}
${YELLOW}Starting package installations...${RESET}

EOF

sudo apt-get update

cat << EOF

${GREEN}Updates Finished${RESET}
${YELLOW}Running terminal configurations...${RESET}

EOF

# Install some general packages
sudo apt install zsh tree -y

# Install zsh package
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install powerlevel10k zsh theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

# [REPLACE] ZSH_THEME="robbyrussell"
sed -ri 's/(ZSH_THEME=")([a-zA-Z]+)(")/\1powerlevel10k\/powerlevel10k\3/g' ~/.zshrc

cat << EOF

    🕜 ${YELLOW}Time to change your default shell${RESET}

EOF
# Change default shell to zsh
chsh -s $(which zsh)

# Clone and copy my personal configuration
git clone --depth=1 --branch "$BRANCH" "$REMOTE" "$RUNNER"
cp $RUNNER/.p10k.zsh ~/
cp $RUNNER/.zshrc ~/

# Install latest bat release
wget "https://github.com/sharkdp/bat/releases/download/v0.18.3/bat-musl_0.18.3_amd64.deb" -O bat_amd64.deb
sudo dpkg -i bat_amd64.deb && rm $_

cat << EOF

    ${YELLOW}Installing fzf and it may require your attention.${RESET}

EOF

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# Add a method for fzf previews in .zshrc
cat << EOF >> ~/.zshrc

# Adding some preview configs for fzf
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

# Install and configuring some plugins for zsh
#
# - hacker-quotes
# - supercrabtree/k
# - zsh-autosuggestions
# - zsh-syntax-highlighting
# - enhancd
#
cat << EOF

    ⬇️ ${YELLOW}Downloading some needed repos for you...${RESET}

EOF
git clone https://github.com/oldratlee/hacker-quotes.git \
    $ZSH_CUSTOM/plugins/hacker-quotes
git clone https://github.com/supercrabtree/k \
    $ZSH_CUSTOM/plugins/k
git clone https://github.com/zsh-users/zsh-autosuggestions \
    $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
    $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

cp $RUNNER/configs/custom/* "$ZSH_CUSTOM/"
cp "$RUNNER/configs/zsh-syntax-highlighting.zsh" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting/"
git clone https://github.com/b4b4r07/enhancd ~/.enhancd

cat << EOF >> ~/.zshrc

# Enable enhancd
source ~/.enhancd/init.sh

# Disable highlighting of pasted text
zle_highlight=('paste:none')
EOF

rm -rf $RUNNER

cat << EOF

${GREEN}It's all DONE!!${RESET}

              😎 Thanks for using Cereal Runner ✨
            Restart your terminal to show the changes
                      with 💖 by Crealhex

EOF

# Copy route to test
# cp /mnt/c/Users/warender/Desktop/cereal-runner/runner.sh .
#
# Nuevas cambios agregados a mi entorno de trabajo
# Add /home/denisse/.oh-my-zsh/custom
# - aliases.zsh
# - paths.zsh
# - profile.zsh
#
# Configuración de user.email y user.name para git
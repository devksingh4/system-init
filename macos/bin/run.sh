#!/bin/sh
xcode-select --install
set -e
sudo xcodebuild -license
if [[ "$(sysctl -n machdep.cpu.brand_string)" == *'Apple'* ]]; then
    if arch -x86_64 /usr/bin/true 2> /dev/null; then
        echo "Rosetta Installed!"
    else
        echo "Rosetta Missing!"
        /usr/sbin/softwareupdate --install-rosetta
    fi
else
    echo "Rosetta Ineligible!"
fi
which -s brew
if [[ $? != 0 ]] ; then
    # Install Homebrew
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
if [[ ":$PATH:" == *":/opt/homebrew/bin:"* ]]; then
  echo "Your path is correctly set"
else
    echo "export PATH=/opt/homebrew/bin:$PATH" >> ~/.zshrc && source ~/.zshrc
fi
/opt/homebrew/bin/brew install ansible
ansible-galaxy install -r requirements.yml
ansible-playbook -i "localhost," -c local main.yml -vv
bin/logioptions.sh # install logitech options+ offline version
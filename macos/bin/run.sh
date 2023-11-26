#!/bin/sh
xcode-select --install
sudo xcodebuild -license
/usr/sbin/softwareupdate --install-rosetta
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
if [[ ":$PATH:" == *":/opt/homebrew/bin:"* ]]; then
  echo "Your path is correctly set"
else
    echo "export PATH=/opt/homebrew/bin:$PATH" >> ~/.zshrc && source ~/.zshrc
fi
/opt/homebrew/bin/brew install ansible
ansible-galaxy install -r requirements.yml
ansible-playbook -i "localhost," -c local main.yml
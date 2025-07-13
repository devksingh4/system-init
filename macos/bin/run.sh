#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Color Codes for Output ---
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# --- Functions for each installation step ---

install_xcode() {
    echo "${YELLOW}Checking for Xcode Command Line Tools...${NC}"
    if ! xcode-select -p &>/dev/null; then
        echo "Xcode Command Line Tools not found. Installing now..."
        xcode-select --install
        sudo xcodebuild -license accept
    else
        echo "${GREEN}Xcode Command Line Tools are already installed.${NC}"
    fi
}

install_rosetta() {
    if [[ "$(sysctl -n machdep.cpu.brand_string)" == *'Apple'* ]]; then
        echo "${YELLOW}Checking Rosetta 2 status on Apple Silicon...${NC}"
        if ! arch -x86_64 /usr/bin/true 2>/dev/null; then
            echo "Rosetta 2 is not installed. Installing now..."
            /usr/sbin/softwareupdate --install-rosetta --agree-to-license
        else
            echo "${GREEN}Rosetta 2 is already installed.${NC}"
        fi
    else
        echo "This is an Intel Mac. Rosetta 2 is not needed."
    fi
}

install_homebrew() {
    echo "${YELLOW}Checking for Homebrew...${NC}"
    if ! command -v brew &>/dev/null; then
        echo "Homebrew not found. Installing now..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for the current session and for future sessions
        echo "Adding Homebrew to your PATH..."
        (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zshrc
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "${GREEN}Homebrew is already installed.${NC}"
    fi

    # Ensure Homebrew's path is correctly set for the script to continue
    if [[ ":$PATH:" != *":/opt/homebrew/bin:"* ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

install_ansible() {
    echo "${YELLOW}Checking for Ansible...${NC}"
    if ! command -v ansible &>/dev/null; then
        echo "Ansible not found. Installing via Homebrew..."
        brew install ansible
    else
        echo "${GREEN}Ansible is already installed.${NC}"
        echo "Ensuring Ansible is up to date..."
        brew upgrade ansible
    fi
}

# --- Main Execution ---

main() {
    install_xcode
    install_rosetta
    install_homebrew
    install_ansible

    echo "${YELLOW}Installing Ansible Galaxy requirements...${NC}"
    ansible-galaxy install -r requirements.yml

    echo "${YELLOW}Running main Ansible playbook...${NC}"
    ansible-playbook -i "localhost," -c local main.yml -vv

    # echo "${YELLOW}Running Logitech Options+ installer...${NC}"
    # if [ -f "bin/logioptions.sh" ]; then
    #     sh bin/logioptions.sh
    # else
    #     echo "Logitech installer script not found at bin/logioptions.sh"
    # fi

    echo "${GREEN}🚀 Setup complete!${NC}"
}

# Run the main function
main

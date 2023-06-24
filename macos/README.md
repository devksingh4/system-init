# macOS initialization using Ansible

## Usage
First, ensure that you are signed into the Mac App Store.
Next, clone and run the script.

```zsh
git clone https://github.com/devksingh4/system-init
cd system-init/macos/
bin/run.sh
```

Post-install manual tasks:
* Log into all 3 Google Drive accounts.
* Copy SSH key over from Google Drive.
* Activate BetterDisplay License and setup HiDPI.
* Log into Tailscale
* Setup Mac Mouse Fix
* Ensure Rectangle starts on startup
* Log into Discord, Spotify
* Log into iMessage - ensure messages are syncing
* Sign into Code - ensure sync is enabled
  * Setup Code remote target - Lab SSH

## Attribution
Modified from [this repository](https://gist.github.com/mrlesmithjr/f3c15fdd53020a71f55c2032b8be2eda) and [this repository](https://github.com/geerlingguy/mac-dev-playbook/).

#!/usr/bin/env bash

# Create an SSH key.
touch ~/.ssh/id_rsa
echo $2 | base64 --decode > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

# Clone repo
cd ~/build
git clone git@github.com:$1.git .

# Parse .shuv.yml file
node ~/parse.js

# Show commands from now on
set -x

# Execute the parsed .shuv.yml file
sh -c ~/shuv.sh

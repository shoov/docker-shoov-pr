FROM ubuntu:14.04
MAINTAINER Gizra

# Update and install packages
RUN apt-get update
RUN apt-get install -y curl zsh git vim

RUN curl -sL https://deb.nodesource.com/setup  | sudo bash -
RUN apt-get install -y nodejs

# Install oh-my-zsh
RUN curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# Enable ssh-agent
RUN eval `ssh-agent -s`

RUN mkdir /root/.ssh

# Create known_hosts
RUN touch /root/.ssh/known_hosts

# Add Github key
# RUN ssh-keyscan -H github.com > /home/.ssh/known_hosts
RUN ssh-keyscan -H github.com > /etc/ssh/ssh_known_hosts

# Add scripts
RUN mkdir /temp-build
ADD package.json /temp-build/package.json
RUN cd /temp-build && npm install --verbose
RUN cp -R /temp-build/node_modules /home

ADD main.sh /home/main.sh
ADD download_images.js /home/download_images.js

CMD /home/main.sh

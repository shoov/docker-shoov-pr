FROM ubuntu:14.04
MAINTAINER Thomas VIAL

# Update and install packages
RUN apt-get update
RUN apt-get install -y curl zsh git vim
RUN apt-get install -y -q php5-cli php5-curl

# Install composer globally
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

# Create "behat" user with password crypted "behat"
RUN useradd -d /home/behat -m -s /bin/zsh behat
RUN echo "behat:behat" | chpasswd

# Behat alias in docker container
ADD behat /home/behat/behat
RUN chmod +x /home/behat/behat

# Create a new zsh configuration from the provided template
ADD .zshrc /home/behat/.zshrc

# Fix permissions
RUN chown -R behat:behat /home/behat

# Add "behat" to "sudoers"
RUN echo "behat        ALL=(ALL:ALL) ALL" >> /etc/sudoers

# Clone oh-my-zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git /home/behat/.oh-my-zsh/

# Get a Stable Behat copy

USER behat
WORKDIR /home/behat
ENV HOME /home/behat
ENV PATH $PATH:/home/behat

# Install A fixed version of Behat
RUN mkdir /home/behat/composer
ADD composer.json /home/behat/composer/composer.json
RUN cd /home/behat/composer && composer install --prefer-dist

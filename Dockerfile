FROM ubuntu:14.04
MAINTAINER Thomas VIAL

# Update and install packages
RUN apt-get update
RUN apt-get install -y curl zsh git vim
RUN apt-get install -y -q php5-cli php5-curl
RUN apt-get install -y nodejs

# Install composer globally
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

# Create "behat" user with password crypted "behat"
RUN useradd -d /home/behat -m -s /bin/zsh behat
RUN echo "behat:behat" | chpasswd

# Create a new zsh configuration from the provided template
ADD .zshrc /home/behat/.zshrc

# Fix permissions
RUN chown -R behat:behat /home/behat

# Add "behat" to "sudoers"
RUN echo "behat        ALL=(ALL:ALL) ALL" >> /etc/sudoers

# Clone oh-my-zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git /home/behat/.oh-my-zsh/

# Enable ssh-agent
RUN eval `ssh-agent -s`

RUN mkdir /home/behat/build
RUN chmod 777 /home/behat/build

RUN mkdir /home/behat/.ssh
RUN chmod 777 /home/behat/.ssh

# Create known_hosts
RUN touch /home/behat/.ssh/known_hosts

# Add Github key
RUN ssh-keyscan -H github.com > /home/behat/.ssh/known_hosts


USER behat
WORKDIR /home/behat
ENV HOME /home/behat
ENV PATH $PATH:/home/behat

CMD /home/behat/data/main.sh

# VERSION 1.0
# AUTHOR:         Jerome Guibert <jguibert@gmail.com>
# DESCRIPTION:    Debian Stable image based on debian:jessie
# TO_BUILD:       docker build --rm -t airdock/base .
# SOURCE:         https://github.com/airdock/docker-base

# Pull base image.
FROM debian:jessie
MAINTAINER Jerome Guibert <jguibert@gmail.com>

USER root

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
# No dialog on apt-get update
ENV TERM linux
# Work around initramfs-tools running on kernel 'upgrade': <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189>
ENV INITRD No

#add root asset (aliases and fix user id)
ADD asset/* /root/

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8
ENV LC_ALL  en_US.UTF-8

# Install curl, locales, apt-utils and gosu
# create en_US.UTF-8
# update distribution package
# add few common alias to root user
# add utilities (create user, post install script)
# create airdock user list
RUN apt-get update -qq && \
  apt-get install -y apt-utils curl locales && \
  sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen && locale-gen && \
  update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 && \
  apt-get update -y && \
  gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
  curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture)" && \
  curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.7/gosu-$(dpkg --print-architecture).asc" && \
  gpg --verify /usr/local/bin/gosu.asc && \
  rm /usr/local/bin/gosu.asc && \
  chmod +x /usr/local/bin/gosu && \
  mv /root/aliases /root/.aliases && \
  echo "source ~/.aliases" >> /root/.bashrc && \
  /root/create-user redis 4201 redis 4201  && \
  /root/create-user elasticsearch 4202 elasticsearch 4202 && \
  /root/create-user mongodb 4203 mongodb 4203 && \
  /root/create-user rabbitmq 4204 rabbitmq 4204 && \
  /root/create-user java 4205 java 4205 && \
  /root/create-user py 4206 py 4206 && \
  /root/create-user node 4207 node 4207 && \
  /root/post-install

# Define default workdir
WORKDIR /root

# Define default command.
CMD [ "/bin/bash", "-l"]

FROM vim/ubuntu:latest

USER root
RUN apt install -y git php npm
USER ubuntu

COPY vimrc /home/ubuntu/.vimrc

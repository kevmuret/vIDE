FROM vim/ubuntu:latest

USER root
RUN apt install -y git php npm
RUN apt install -y ccls
USER ubuntu

COPY vimrc /home/ubuntu/.vimrc

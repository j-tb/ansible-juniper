FROM python:3.7-slim

LABEL Name="exampleorg NOC Ansible-Juniper Docker Image fuer lokale Dev-Umgebung"

ARG key
ARG user

ARG workdir=ansible-juniper
ARG keypath=/home/$user/.ssh/
ARG keyfile=$keypath/id_rsa

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y vim openssh-client iputils-ping dnsutils

RUN mkdir -p /$workdir
ADD . /$workdir
WORKDIR /$workdir

RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt
RUN ansible-galaxy install -r requirements.yml

RUN useradd --create-home --shell /bin/bash $user
RUN chown -R $user:$user /$workdir
USER $user

RUN mkdir -p $keypath && touch $keyfile
RUN echo $key | tr ';' '\n' > $keyfile && chmod 600 $keyfile

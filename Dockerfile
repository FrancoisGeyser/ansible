FROM ubuntu:focal as base
ARG TAGS
WORKDIR /usr/local/bin
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y software-properties-common curl git ansible build-essential sudo 

FROM base AS prime
ARG TAGS
# Create ubuntu user with sudo privileges
RUN useradd -ms /bin/bash akula && \
    usermod -aG sudo akula
# New added for disable sudo password
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER akula
WORKDIR /home/akula

FROM prime
COPY . .
RUN ["sh", "-c", "ansible-playbook $TAGS local.yml"]
CMD ["sh", "-c", "zsh"]

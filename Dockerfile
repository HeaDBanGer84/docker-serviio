FROM ansible/ubuntu14.04-ansible:stable
MAINTAINER mihai.parv

RUN apt-get update && apt-get install -y git

RUN mkdir -p /etc/ansible/roles/serviio
COPY . /etc/ansible/roles/serviio
WORKDIR /etc/ansible/roles/serviio

RUN ansible-galaxy install -r requirements.yml && \
    ansible-playbook site.yml -c local

VOLUME /opt/serviio/log
VOLUME /opt/serviio/library
VOLUME /mnt/storage

# serviio requires TCP port 8895 and UDP 1900 for content and 23423 for rest api
EXPOSE 23423:23423/tcp 8895:8895/tcp 1900:1900/udp

WORKDIR /opt/serviio
ENTRYPOINT [ "bin/serviio-wrapper.sh" ]
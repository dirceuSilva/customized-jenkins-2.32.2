FROM jenkins:2.32.2

COPY plugins.txt /usr/share/jenkins/plugins.txt

USER root

RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

ARG docker_version=1.13.0
ARG docker_compose_version=1.10.0
ARG docker_gid=998

RUN apt-get update -qq && apt-get install -qqy \
    apt-transport-https \
    ca-certificates \
    lxc \
    mysql-client && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-${docker_version}.tgz && \
    tar --strip-components=1 -xvzf docker-${docker_version}.tgz -C /usr/local/bin
RUN touch /var/run/docker.sock
RUN groupadd -g ${docker_gid} docker
RUN usermod -aG docker jenkins
RUN curl -o /usr/local/bin/docker-compose -s -L https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-`uname -s`-`uname -m`
RUN chmod +x /usr/local/bin/docker-compose

RUN echo America/Sao_Paulo | tee /etc/timezone &&  dpkg-reconfigure --frontend noninteractive tzdata

USER jenkins

COPY run_jenkins.sh /usr/local/bin/run_jenkins.sh
ENTRYPOINT ["/bin/bash", "--",  "/usr/local/bin/run_jenkins.sh"]

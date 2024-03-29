FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ Asia/Shanghai
#git中文乱码问题
ENV LESSCHARSET=utf-8
ENV USERNAME=smartide
ENV USER_PASS=P@ssw0rd
#
# Systemd installation
#
RUN apt-get update &&                            \
    apt-get install -y --no-install-recommends   \
            systemd                              \
            systemd-sysv                         \
            libsystemd0                          \
            ca-certificates                      \
            dbus                                 \
            iptables                             \
            iproute2                             \
            kmod                                 \
            locales                              \
            sudo                                 \
            git                                  \
            wget                                 \
            udev &&                              \
                                                 \
    # Prevents journald from reading kernel messages from /dev/kmsg
    echo "ReadKMsg=no" >> /etc/systemd/journald.conf &&               \
    # Create default user
    useradd --create-home --shell /bin/bash $USERNAME && echo "$USERNAME:$USER_PASS" | chpasswd && adduser $USERNAME sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && chmod g+rw /home \
    && mkdir -p /home/project \
    && mkdir -p /home/opvscode \
    && mkdir -p /idesh

# Sshd install
RUN apt-get update && apt-get install --no-install-recommends -y      \
            openssh-server &&                                         \
    mkdir /home/$USERNAME/.ssh &&                                         \
    chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

# Docker install
RUN apt-get update && apt-get install --no-install-recommends -y      \
       apt-transport-https                                            \
       ca-certificates                                                \
       curl                                                           \
       gnupg-agent                                                    \
       software-properties-common &&                                  \
                                                                      \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg           \
         | apt-key add - &&                                           \
	                                                                  \
    apt-key fingerprint 0EBFCD88 &&                                   \
                                                                      \
    add-apt-repository                                                \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu     \
       $(lsb_release -cs)                                             \
       stable" &&                                                     \
                                                                      \
    apt-get update && apt-get install --no-install-recommends -y      \
       docker-ce docker-ce-cli containerd.io docker-compose-plugin && \
    # Add user to the Docker group
    usermod -a -G docker $USERNAME


#Dapr install
RUN wget -q https://raw.githubusercontent.com/dapr/cli/master/install/install.sh -O - | /bin/bash

#Kind install
RUN curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64 \
    && chmod +x ./kind                                                      \
    && mv ./kind /usr/local/bin/kind                                        

#Kubectl install
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x kubectl                                                                                             \
    && mv ./kubectl /usr/local/bin/kubectl                                                                             

#Helm install
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null \
    && apt-get install apt-transport-https --yes \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list \
    && apt-get update \
    && apt-get install helm

#k9s install
RUN mkdir k9s && cd k9s \
    && curl -Lo k9s.tgz https://github.com/derailed/k9s/releases/download/v0.25.18/k9s_Linux_x86_64.tar.gz \
    && tar -xf k9s.tgz \
    && install k9s /usr/local/bin/

# Housekeeping
RUN apt-get clean -y &&                                            \
    rm -rf                                                         \
    /var/cache/debconf/*                                           \
    /var/lib/apt/lists/*                                           \
    /var/log/*                                                     \
    /tmp/*                                                         \
    /var/tmp/*                                                     \
    /usr/share/doc/*                                               \
    /usr/share/man/*                                               \
    /usr/share/local/*   


# Housekeeping
RUN apt-get clean -y &&                                            \
    rm -rf                                                         \
    /var/cache/debconf/*                                           \
    /var/lib/apt/lists/*                                           \
    /var/log/*                                                     \
    /tmp/*                                                         \
    /var/tmp/*                                                     \
    /usr/share/doc/*                                               \
    /usr/share/man/*                                               \
    /usr/share/local/*   

COPY script.sh /idesh/script.sh
RUN chmod +x /idesh/script.sh

EXPOSE 22 3000 8887

# Set systemd as entrypoint.
ENTRYPOINT ["/idesh/script.sh"]
CMD [ "/sbin/init"]

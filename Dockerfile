FROM openjdk:8-jdk

# update packages and get wget
RUN apt-get update && apt install wget -y
# downloand ib gateway
# https://download2.interactivebrokers.com/installers/ibgateway/latest-standalone/ibgateway-latest-standalone-linux-x64.sh
RUN echo wget -P /tmp -q https://download2.interactivebrokers.com/installers/ibgateway/latest-standalone/ibgateway-latest-standalone-linux-x64.sh
RUN wget -P /tmp -q https://download2.interactivebrokers.com/installers/ibgateway/latest-standalone/ibgateway-latest-standalone-linux-x64.sh
RUN ls -l /tmp/
RUN chmod a+x /tmp/ibgateway-latest-standalone-linux-x64.sh

# install jfx
RUN apt-get install -y --no-install-recommends xvfb openjfx 

ENV DEBIAN_FRONTEND noninteractive
ENV USER ibg
ENV DISPLAY :0
ENV ARGS ""
ENV PASSWORD "a"

USER root

# Create user
RUN useradd -ms /bin/bash $USER
WORKDIR /home/ibg

# install networking tools
RUN apt install ca-certificates tightvncserver fluxbox xterm xautomation unzip vim telnet -qy

# install IB Gateway
USER ibg
RUN /tmp/ibgateway-latest-standalone-linux-x64.sh -q

# Copy profile settings
USER root
COPY start.sh /home/$USER/
RUN chown $USER:$USER /home/$USER/start.sh && chmod +x /home/$USER/start.sh

# clean up packakes
# RUN apt-get purge vim unzip telnet
USER root
RUN apt clean
RUN rm -rf /var/lib/apt/lists/*
RUN rm /tmp/ibgateway-*.sh

# VNC
USER ibg
RUN mkdir -p /home/$USER/.vnc
RUN set -xe && (echo $PASSWORD | vncpasswd -f > /home/$USER/.vnc/passwd)
RUN chmod 0600 /home/$USER/.vnc/passwd

# expose ports
EXPOSE 4002
EXPOSE 5900

CMD tightvncserver $DISPLAY; ./start.sh

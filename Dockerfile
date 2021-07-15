FROM openjdk:8-jdk
RUN apt-get update && apt-get install -y --no-install-recommends xvfb openjfx && rm -rf /var/lib/apt/lists/*

ENV DEBIAN_FRONTEND noninteractive
ENV USER ibg
ENV DISPLAY :0
ENV ARGS ""
ENV PASSWORD "a"
ENV VERSION "latest"

USER root

# Create user
RUN useradd -ms /bin/bash $USER
WORKDIR /home/ibg

# Update
RUN apt update && apt upgrade -qy && apt dist-upgrade -qy && apt update --fix-missing
RUN apt install wget ca-certificates tightvncserver fluxbox xterm xautomation unzip vim telnet -qy

# IB Gateway
USER ibg
RUN wget -q https://download2.interactivebrokers.com/installers/ibgateway/$VERSION-standalone/ibgateway-$VERSION-standalone-linux-x64.sh
RUN chmod +x ibgateway-$VERSION-standalone-linux-x64.sh && ./ibgateway-$VERSION-standalone-linux-x64.sh -q && rm -f ibgateway-$VERSION-standalone-linux-x64.sh
#RUN wget https://gluonhq.com/download/javafx-11-0-2-jmods-linux -O jfxmods.zip
#RUN unzip jfxmods.zip

# Copy profile settings
USER root
COPY start.sh /home/$USER/
RUN chown $USER:$USER /home/$USER/start.sh && chmod +x /home/$USER/start.sh

# clean up packakes
# RUN apt-get purge vim unzip telnet
USER root
RUN apt clean
RUN rm -rf /var/lib/apt/lists/*

# VNC
USER ibg
RUN mkdir -p /home/$USER/.vnc
RUN set -xe && (echo $PASSWORD | vncpasswd -f > /home/$USER/.vnc/passwd)
RUN chmod 0600 /home/$USER/.vnc/passwd

# expose ports
EXPOSE 4002
EXPOSE 5900

CMD tightvncserver $DISPLAY; ./start.sh

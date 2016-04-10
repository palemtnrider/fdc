#
# Need to run chome a privileged as it using lxc as well
#
# On osx - you need xquartz and socat
# brew install socat
# download xquartz from http://www.xquartz.org/
# After installing xquartz, log out and log back in (This sets $DISPLAY to a pipe)
# Get the IP address of the vboxnet0 network in xquartz (I opened a terminal and execute ifconfig)
#
# Start socat in a shell
#   ```socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" ```
# xquartz starts automatically
#
# Pass the IP from vboxnet0 to the start of the container
#   ``` docker run -it --privileged -e DISPLAY=192.168.99.1:0 flowdock```

FROM debian:stable
# Add the PPA for google
RUN echo 'deb http://httpredir.debian.org/debian testing main' >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y install curl
RUN curl -sSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update
RUN apt-get -y install libexif12
RUN apt-get -y install google-chrome-stable
# Create the developer user
RUN useradd -ms /bin/bash developer
# CMD /usr/bin/chrome
# CMD /bin/bash

USER developer
ENV HOME /home/developer

ENTRYPOINT [ "google-chrome" ]
CMD [ "--user-data-dir=/data" ]

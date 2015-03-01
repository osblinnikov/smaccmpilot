
# Name: smaccmpilot-docker
# Description: installs smaccmpilot in ubuntu trusty environment
#
# VERSION       1.1
#

# Use the ubuntu base image
FROM ubuntu:trusty

MAINTAINER Oleg Blinnikov, osblinnikov@gmail.com
# make sure the package repository is up to date
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:terry.guo/gcc-arm-embedded
RUN apt-get -y update
RUN apt-get install -y gcc-arm-none-eabi
RUN apt-get install -y haskell-platform
RUN cabal update
RUN cabal install cabal cabal-install 

RUN apt-get install -y gcc-4.7-plugin-dev
RUN apt-get install -y git

WORKDIR /usr/src 
RUN git clone --recursive https://github.com/GaloisInc/smaccmpilot-build.git

# WORKDIR /usr/src/smaccmpilot-build
# RUN git checkout -b development origin/development && git submodule init && git submodule update

WORKDIR /usr/src/smaccmpilot-build/smaccmpilot-stm32f4
RUN cp Config.mk.example Config.mk
RUN cp Keys.mk.example Keys.mk

WORKDIR /usr/src/smaccmpilot-build/mavlink
RUN git pull -u origin master

WORKDIR /usr/src/smaccmpilot-build
RUN apt-get install -y python-pip
RUN mkdir -p ~/.pip && echo "[global]\ndownload-cache = ~/.pip/cache" > ~/.pip/pip.conf
RUN pip install virtualenv
RUN pip install virtualenvwrapper
RUN apt-get install make
RUN make sandbox-clean

ADD .bashrc /root/.bashrc
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN source /root/.bashrc && mkvirtualenv mavlink && pip install --no-use-wheel -r mavlink/requirements.txt
RUN source /root/.bashrc && workon mavlink && make

# Launch bash when launching the container
ADD startcontainer.bash /usr/local/bin/startcontainer.bash
RUN chmod 755 /usr/local/bin/startcontainer.bash

CMD ["/bin/bash"]
ENTRYPOINT ["/usr/local/bin/startcontainer.bash"]

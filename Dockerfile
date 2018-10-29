FROM ubuntu:latest
MAINTAINER Mikko Eberhardt <mikko.eberhardt@haw-hamburg.de>
LABEL Description="Docker image for Omnet++ tests"

RUN apt-get update

# General dependencies
RUN apt-get install -y tzdata

RUN apt-get install -y \
  git \
  wget \
  tar \
  vim \
  build-essential \
  clang \
  bison \
  flex \
  perl \
  tcl-dev \
  tk-dev \
  libxml2-dev \
  zlib1g-dev \
  default-jre \
  graphviz \
  libwebkitgtk-1.0-0 \
  libqt5opengl5-dev \
  xvfb

# QT4 components
#RUN apt-get -f install -y \
  #openscenegraph \
  #qt5-default \
  #qt5-qmake \
  #qtbase5-dev \
  #openscenegraph \
  #libosgearth-dev \
  #libopenscenegraph-dev \
  #openscenegraph-plugin-osgearth \
  #osgearth \
  #osgearth-data


# OMNeT++ 5

# Create working directory
RUN mkdir -p /usr/omnetpp
WORKDIR /usr/omnetpp

COPY omnetpp-5.4.1-src-linux.tgz /usr/omnetpp

RUN tar -xf omnetpp-5.4.1-src-linux.tgz

# Graphical interface disable
RUN cd omnetpp-5.4.1 && sed -i 's/WITH_TKENV=yes/WITH_TKENV=no/g' configure.user
RUN cd omnetpp-5.4.1 && sed -i 's/WITH_QTENV=yes/WITH_QTENV=no/g' configure.user
RUN cd omnetpp-5.4.1 && sed -i 's/PREFER_QTENV=yes/PREFER_QTENV=no/g' configure.user
RUN cd omnetpp-5.4.1 && sed -i 's/WITH_OSG=yes/WITH_OSG=no/g' configure.user
RUN cd omnetpp-5.4.1 && sed -i 's/WITH_OSGEARTH=yes/WITH_OSGEARTH=no/g' configure.user

# Compilation requires path to be set
ENV PATH $PATH:/usr/omnetpp/omnetpp-5.4.1/bin

# Configure and compile omnet++
RUN cd omnetpp-5.4.1 && \
    xvfb-run ./configure && \
    make

# Cleanup
RUN apt-get clean && \
  rm -rf /var/lib/apt && \
  rm /usr/omnetpp/omnetpp-5.4.1-src-linux.tgz

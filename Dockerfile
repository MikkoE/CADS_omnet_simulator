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
  xvfb

# QT4 components
RUN apt-get -f install -y \
  openscenegraph \
  qt5-default \
  qt5-qmake \
  qtbase5-dev \
  openscenegraph \
  libopenscenegraph-dev \
  openscenegraph-plugin-osgearth \
  osgearth \
  osgearth-data

#RUN apt-get install libosgearth-dev


# OMNeT++ 5

# Create working directory
RUN mkdir -p /usr/omnetpp
WORKDIR /usr/omnetpp

COPY omnetpp-5.4.1-src-linux.tgz /usr/omnetpp


RUN tar -xf omnetpp-5.2-src.tgz

# Compilation requires path to be set
ENV PATH $PATH:/usr/omnetpp/omnetpp-5.2/bin

# Configure and compile omnet++
RUN cd omnetpp-5.2 && \
    xvfb-run ./configure && \
    make

# Cleanup
RUN apt-get clean && \
  rm -rf /var/lib/apt && \
  rm /usr/omnetpp/omnetpp-5.2-src.tgz

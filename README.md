# μc - Muc
The micro container shell script

## Installation

Simply download muc.sh and set it executable as shown:

`chmod +x muc.sh`

Muc should require no external dependencies other than the GNU Utils and a POSIX compliant shell.

Once downloaded muc will function as a standard shell script, if you wish to install to the system, simply copy muc.sh to `/usr/local/bin`

## Install containers

### From the web

To install containers from a URL, simply type `./muc.sh grab [url of container]`.  This will download and prompt the installation of the specified container.

### Locally

To install containers from a file, simply type `./muc.sh install [path to container.tgz]`

## Run a container

To run a container, simply type `./muc.sh run [container name]`.  Alternatively if you wish to run as a daemon, type `./muc.sh rund [name]`.  Warning, running as a deamon will make it very hard to kill the running container.

## Create a container

A muc container is simply a root fs with a special file detailing how the container should be run.  To create a very simple container download the Alpine Linux minirootfs from this link: http://dl-cdn.alpinelinux.org/alpine/v3.12/releases/x86_64/alpine-minirootfs-3.12.1-x86_64.tar.gz

A .mucfile is a file that details how the container will run, it will be found in the root of the container (/.mucfile).  The contents of a mucfile can be seen below.

```
Name: Hello World
Command: /bin/ash
```

Where "Name" is the name of the container and "Command" is the command that will be run within the container.

Once you create a container with a .mucfile, you can run `muc.sh test` to run through and verify that the container and .mucfile are setup properly.

To package up a container, simply run
`tar cvzf ../container.tar.gz .`

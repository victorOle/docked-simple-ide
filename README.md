# About

Very simple (crude) initial effort at packaging parallax simpleide in
a docker instance.  (WIP)

# Preliminaries

Install, configure docker on host system
 - add yourself to group docker in /etc/group
 - make docker service start on boot or start it every time using `systemctl start docker`


Fetch debian/ubuntu package (caution: _old_)
```
#!/bin/sh

url="http://downloads.parallax.com/plx/software/side/101rc1"
deb="simple-ide_1-0-1-rc1_amd64.deb"

wget "$url/$deb"
```

Create docker image and tag with something memorable, but "simple-ide"
is what the Run script expects, so that is the best one to use.
```
docker build .

docker tag <some-id> simple-ide
```


# Run

Probably want to mount directories, etc, but most importantly make
certain to have the properly modified entrypoint script to run as the
same user id on the guest system (not as root).

The entrypoint should also ensure that serial ports such as
`/dev/ttyUSB*` are writable.

The Run-docker script does most of that.


# Notes

The additional qt4 libraries are added in without security checks.
This is ugly, but expedient - will be improved

The Dockerfile is a WIP, needs proper streamlining.

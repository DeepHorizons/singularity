# This Repo
This repo contains an automated build of singularity. It can be used do build singularity images inside docker images or to run singularity images. In order to do so you typically need to enable the `--privileged` flag which disables most of the container security, so beware.



# TL;DR

* "`docker run -it --privileged deephorizons/singularity`" for the latest version
* "`docker run -it --privileged deephorizons/singularity:3.3.0`" for a specific version



# What is Singularity
Singularity, as maintained by https://www.sylabs.io/ is a new container platform that does not require a root deamon to start the containers, the containers run in userspace as the user, no privileged escalation required (beyond optionally needing a GUID bit set for virtualization). This setup is useful on High Performance Clusters [HPC] where users have accounts. The HPC maintainers should no longer need to maintain a large list of applications and their different versions. New setups can be easily tested without disrupting a persons workflow either, images are also portable and can be easily copied for archiving.

This repository is used as a starting point for automatically building singularity images. It also gives a consistent environment for building them in, if Singularity moves to a new format in a new version you can still build using older version by specifying a version to use.


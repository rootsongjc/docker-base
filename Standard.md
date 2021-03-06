# Docker Project Tree Standard

All our project follow the same organisation and mechanism to build and deploy images.

## Project Tree

| Name            | Comment                                  |
| --------------- | ---------------------------------------- |
| asset           | This folder content all static resource which will be added in docker image. |
| Dockerfile      | Docker image cook recipes                |
| Makefile        | Common target to speed up repetitive tasks |
| LICENSE         | License content                          |
| README.md       | A full description of current project (purpose, feature, change log) |
| README-shotr.md | A short description of current project.  |
| .dockerignore   | A list of excluded resource (not visible by docker deamon to build) |
| .gitignore      | A list of excluded resource for git      |



## Make

All our Makefile, offer the same target. Install "make" utility, and execute: make build to build current project.

In Makefile, you could retrieve this variables:

- NAME: declare a full image name (aka airdock/base, airdoc/oracle-jdk, ...)

- VERSION: declare image version

and tasks:

- all: alias to 'build'

- clean: remove all container which depends on this image, and remove image previously builded
- build: clean and build the current version
- tag_latest: tag current version with ":latest"
- release: build and execute tag_latest, push image onto registry, and tag git repository
- debug: launch default command with builded image in interactive mode
- run: run image as daemon with common port exposition (if relevant) and print IP address
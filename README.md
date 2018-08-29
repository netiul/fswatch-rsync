This docker image can be used to rsync file changes from the container to the host.

For example, this can be used to speed up synchronization of directories under OSX that only change on the container but are very useful to have on the host during development. Use it with [docker-sync](https://github.com/EugenMayer/docker-sync).

The image is published on docker hub repository [zluiten/fswatch-rsync](https://hub.docker.com/r/zluiten/fswatch-rsync/). Source can be found on github repository [netiul/fswatch-rsync](https://github.com/netiul/fswatch-rsync).
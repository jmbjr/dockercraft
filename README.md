This docker image provides a Minecraft Server that will automatically download the latest stable
version at startup. You can also run/upgrade to any specific version or the
latest snapshot. See the *Versions* section below for more information.

To simply use the latest stable version, run

    docker run -d -p 25565:25565 itzg/minecraft-server

where the default server port, 25565, will be exposed on your host machine. If you want to serve up multiple
Minecraft servers or just use an alternate port, change the host-side port mapping such as

    docker run -p 25566:25565 ...

will serve your Minecraft server on your host's port 25566 since the `-p` syntax is
`host-port`:`container-port`.

Speaking of multiple servers, it's handy to give your containers explicit names using `--name`, such as

    docker run -d -p 25565:25565 --name minecraft-default itzg/minecraft-server

With that you can easily view the logs, stop, or re-start the container:

    docker logs -f minecraft-default
        ( Ctrl-C to exit logs action )

    docker stop minecraft-default

    docker start minecraft-default

## EULA Support

Mojang now requires accepting the [Minecraft EULA](https://account.mojang.com/documents/minecraft_eula). To accept add

        -e EULA=TRUE

such as

        docker run -e EULA=TRUE -d -p 25565:25565 itzg/minecraft-server

## Attaching data directory to host filesystem

In order to readily access the Minecraft data, use the `-v` argument
to map a directory on your host machine to the container's `/data` directory, such as:

    docker run -d -v /path/on/host:/data ...

When attached in this way you can stop the server, edit the configuration under your attached `/path/on/host` 
and start the server again with `docker start CONTAINERID` to pick up the new configuration.

**NOTE**: The files in the attached directory will be owned by the host user with UID of 1000. Be sure
to create that user (such as `adduser --uid 1000 ...` if you don't already have one.

## Versions

To use a different Minecraft version, pass the `VERSION` environment variable, which can have the value

* LATEST
* SNAPSHOT
* (or a specific version, such as "1.7.9")

For example, to use the latest snapshot:

    docker run -d -e VERSION=SNAPSHOT ...

or a specific version:

    docker run -d -e VERSION=1.7.9 ...

## Server configuration

### Op/Administrator Players

To add more "op" (aka adminstrator) users to your Minecraft server, pass the Minecraft usernames separated by commas via the `OPS` environment variable, such as

	docker run -d -e OPS=user1,user2 ...

### Server icon

A server icon can be configured using the `ICON` variable. The image will be automatically
downloaded, scaled, and converted from any other image format:

    docker run -d -e ICON=http://..../some/image.png ...

### Level Seed

If you want to create the Minecraft level with a specific seed, use `SEED`, such as

    docker run -d -e SEED=1785852800490497919 ...

### Game Mode

By default, Minecraft servers are configured to run in Survival mode. You can
change the mode using `MODE` where you can either provide the [standard
numerical values](http://minecraft.gamepedia.com/Game_mode#Game_modes) or the
shortcut values:

* creative
* survival

For example:

    docker run -d -e MODE=creative ...

### Message of the Day

The message of the day, shown below each server entry in the UI, can be changed with the `MOTD` environment variable, such as

docker run -d -e 'MOTD=My Server' ...

If you leave it off, the last used or default message will be used. _The example shows how to specify a server
message of the day that contains spaces by putting quotes around the whole thing._

### World Save Name

You can either switch between world saves or run multiple containers with different saves by using the `LEVEL` option,
where the default is "world":

docker run -d -e LEVEL=bonus ...

**NOTE:** if running multiple containers be sure to either specify a different `-v` host directory for each
`LEVEL` in use or don't use `-v` and the container's filesystem will keep things encapsulated.

## JVM Configuration

### Memory Limit

The Java memory limit can be adjusted using the `JVM_OPTS` environment variable, where the default is
the setting shown in the example (max and min at 1024 MB):

    docker run -e 'JVM_OPTS=-Xmx1024M -Xms1024M' ...

# dockercraft
simple docker container for a minecraft server

This is based heavily on https://github.com/itzg/dockerfiles (I didn't want to fork the entire repo which contains many different dockerfiles)
The data-only container is simple, but was intially based on: https://registry.hub.docker.com/u/aduermael/minecraft-data/

Starting from scratch:
clone this repo

Prep the server image (this part is kinda clunky and should be generalized one day. see the issues)

    $ cd mcserver  

edit the following variables in start-minecraft.sh (this should be an external file)

    gamename='monster'  #shortname 
    url="http://www.creeperrepo.net/FTB2/modpacks%5EMonster%5E1_1_1%5EMonsterServer.zip"  #point to whichever server.zip you want to play
    rawzip="modpacks^Monster^1_1_1^MonsterServer.zip"  #could use regex and ${url} to automatically set
    jarfile="FTBServer-1.6.4-965.jar"  #the jar file to run from within the zip.

Build the images:

    $ cd mcserver

    $ docker build -t jmbjr/mcserver-monster .

    $ cd ../mcdata

    $ docker build -t jmbjr/mcdata

view your images with:

    $ docker images

Run the containers:
need to run the data container first:  

    $ docker run -d -it --name mcdata-mon jmbjr/mcdata  
    -d      run daemonized
    -it     allow $ docker attach mcdata-mon
    --name  name the container for easy access later

run the server container and point to the data container:

    $ docker run -e EULA=TRUE -d -it -p 25565:25565 --name mcserver-mon --volumes-from mcdata-mon jmbjr/mcserver-monster
    -e              set environemnt variable to accept the mojang EULA (see mcserver/README.md for more info)
    -d              run daemonized
    -it             allow $ docker attach mcserver-mon
    -p              connect to port external:internal (or whatever port you want to run the server on. internal port set in Dockerfile)
    --name          name the container for easy access later
    --volumes-from  point to our data-only mcdata container

view running containers via:

    $ docker ps

view ALL containers, regardless of running or not via:

    $ docker ps -a

view log file from a container (useful when docker ps doesn't show your container running)

    $ docker logs <container --name> 

attach to the container (to view the minecraft server console or to view the mc data)

    $ docker attach <container --name>

use ctrl+p ctrl+q to detach

to start and stop the container:

    $ docker start <container --name>

    $ docker stop  <container --name>

to remove/delete containers:

    $ docker rm <container --name>

to remove/delete images

    $ docker rmi <image --name>




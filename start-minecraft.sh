#!/bin/bash

if [ ! -e /data/eula.txt ]; then
  if [ "$EULA" != "" ]; then
    echo "# Generated via Docker on $(date)" > eula.txt
    echo "eula=$EULA" >> eula.txt
  else
    echo ""
    echo "Please accept the Minecraft EULA at"
    echo "  https://account.mojang.com/documents/minecraft_eula"
    echo "by adding the following immediately after 'docker run':"
    echo "  -e EULA=TRUE"
    echo ""
    exit 1
  fi
fi


cd /data

if [ ! -e unleashed.zip ]; then
  echo "Downloading unleashed ..."
  wget -q http://www.creeperrepo.net/FTB2/modpacks%5EUnleashed%5E1_1_7%5EUnleashed-server.zip
  mv modpacks^Unleashed^1_1_7^Unleashed-server.zip  unleashed.zip
  unzip unleashed.zip
fi

if [ ! -e server.properties ]; then
  cp /tmp/server.properties .

  if [ -n "$MOTD" ]; then
    sed -i "/motd\s*=/ c motd=$MOTD" /data/server.properties
  fi

  if [ -n "$LEVEL" ]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" /data/server.properties
  fi

  if [ -n "$SEED" ]; then
    sed -i "/level-seed\s*=/ c level-seed=$SEED" /data/server.properties
  fi

  if [ -n "$MODE" ]; then
    case ${MODE,,?} in
      0|1|2|3)
        ;;
      s*)
        MODE=0
        ;;
      c*)
        MODE=1
        ;;
      *)
        echo "ERROR: Invalid game mode: $MODE"
        exit 1
        ;;
    esac
  
    sed -i "/gamemode\s*=/ c gamemode=$MODE" /data/server.properties
  fi
fi


if [ -n "$OPS" -a ! -e ops.txt.converted ]; then
  echo $OPS | awk -v RS=, '{print}' >> ops.txt
fi

if [ -n "$ICON" -a ! -e server-icon.png ]; then
  echo "Using server icon from $ICON..."
  # Not sure what it is yet...call it "img"
  wget -q -O /tmp/icon.img $ICON
  specs=$(identify /tmp/icon.img | awk '{print $2,$3}')
  if [ "$specs" = "PNG 64x64" ]; then
    mv /tmp/icon.img /data/server-icon.png
  else
    echo "Converting image to 64x64 PNG..."
    convert /tmp/icon.img -resize 64x64! /data/server-icon.png
  fi
fi

exec java $JVM_OPTS -jar ftbserver.jar


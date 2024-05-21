#!/bin/bash
if [ ! -f ${SERVER_DIR}/Aki.Server.exe ]; then
  echo "Aki.Server.exe not found, downloading version 3.8.0"
#  wget --content-disposition --quiet -O ${SERVER_DIR}/AkiServer.zip 'https://spt-releases.modd.in/SPT-3.8.3-29197-01783e2.7z'
  wget --content-disposition --quiet -O ${SERVER_DIR}/AkiServer.zip 'https://github.com/stayintarkov/SIT.Aki-Server-Mod/releases/download/1.6.4/SITCoop-1.6.4-WithAki3.8.0-2dd4d9-win.zip'
  7za x ${SERVER_DIR}/AkiServer.zip -o${SERVER_DIR}/ -aoa -y -bsp0 -bso0
  rm ${SERVER_DIR}/AkiServer.zip -f
fi

if [ -f ${COOP_DIR}/package.json ]; then 
  SITCoopVersion=$(grep  '"version":' ${COOP_DIR}/package.json)
elif [ ! -f ${COOP_DIR}/package.json ]; then
  echo "SITCoop not found, downloading"
  mkdir -p ${SERVER_DIR}/user/mods
  wget --content-disposition --quiet -O ${SERVER_DIR}/user/mods/SITCoop.zip 'https://github.com/stayintarkov/SIT.Aki-Server-Mod/releases/download/1.6.4/SITCoop-1.6.4-WithAki3.8.0-2dd4d9-win.zip'
  7za x ${SERVER_DIR}/user/mods/SITCoop.zip -o${SERVER_DIR}/user/mods -aoa -y -bsp0 -bso0
  mkdir ${COOP_DIR}/config
  rm ${SERVER_DIR}/user/mods/SITCoop.zip -f
fi

if [ ! -f ${COOP_DIR}/config/coopConfig.json ]; then
  echo "coopConfig.json not found, creating"
  touch ${COOP_DIR}/config/coopConfig.json
  echo -e "{\n\t\"protocol\": \"http\",\n\t\"externalIP\": \"${EXTERNAL_IP}\", \
   \n\t\"webSocketPort\": 6970,\n\t\"webSocketTimeoutSeconds\": 5, \
   \n\t\"webSocketTimeoutCheckStartSeconds\": 120\n}" >> ${COOP_DIR}/config/coopConfig.json
  elif [ -f ${COOP_DIR}/config/coopConfig.json ]; then
    sed -i "s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/${EXTERNAL_IP}/g" ${COOP_DIR}/config/coopConfig.json
fi

if [ -f ${SERVER_DIR}/Aki_Data/Server/configs/http.json ]; then
  sed -i "s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/${LOCAL_IP}/g" ${SERVER_DIR}/Aki_Data/Server/configs/http.json
fi

export WINEPREFIX=/serverdata/serverfiles/WINE64
export WINEDEBUG=-all
echo "---Checking if WINE workdirectory is present---"
if [ ! -d ${SERVER_DIR}/WINE64 ]; then
  echo "---WINE workdirectory not found, creating please wait...---"
  mkdir ${SERVER_DIR}/WINE64
else
  echo "---WINE workdirectory found---"
fi
echo "---Checking if WINE is properly installed---"
if [ ! -d ${SERVER_DIR}/WINE64/drive_c/windows ]; then
  echo "---Setting up WINE---"
  cd ${SERVER_DIR}
  winecfg > /dev/null 2>&1
  sleep 15
else
  echo "---WINE properly set up---"
fi

chmod -R ${DATA_PERM} ${DATA_DIR}

echo "---Checking for old logs---"
find ${SERVER_DIR} -name "masterLog.*" -exec rm -f {} \;
screen -wipe 2&>/dev/null

echo "---Start Server---"

cd ${SERVER_DIR}
screen -S SITCoop -L -Logfile ${SERVER_DIR}/masterLog.0 -d -m NODE_SKIP_PLATFORM_CHECK=1 wine64 ${SERVER_DIR}/Aki.Server.exe
screen -S watchdog -d -m /opt/scripts/start-watchdog.sh
sleep 2
tail -f ${SERVER_DIR}/masterLog.0

#if [ ! -f ${SERVER_DIR}/Aki.Server.exe ]; then
#  echo "---Something went wrong, can't find the executable, putting container into sleep mode!---"
#  sleep infinity
#else
#  cd ${SERVER_DIR}
#  NODE_SKIP_PLATFORM_CHECK=1 wine64 ${SERVER_DIR}/Aki.Server.exe
#fi
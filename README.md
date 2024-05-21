# SITCoop using SPT-AKI version 3.8.0
This docker will download the SPT-Aki version 3.8.0 and SITCoop server version release: 1.6.4 | Client version 1.10.8882.41069

Note this docker container does not automatically update to new version, due to how the SPT-Aki and SITCoop files are named. I may look into making it automatic in the future.

## Example Env params
| Name | Value | Example |
| --- | --- | --- |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| EXTERNAL_IP | External IP | 127.0.0.1 |
| LOCAL_IP | Local IP | 0.0.0.0 |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |

## Run example
```
docker run --name SITCoop -d -t -i \
	--env 'UID=99' \
	--env 'GID=100' \
    --env 'EXTERNAL_IP=127.0.0.1' \ 
    --volume /path/to/sitcoop:/serverdata/serverfiles \
    -p 6969-6972:6969-6972/udp -p 6969-6972:6969-6972/tcp \
    stultusaur/sitcoop:latest
``` 
To find your external IP go to https://whatismyipaddress.com/

This docker container was created with assistance from ich777/docker-steamcmd-server

If any issues arise, please create an issue with any logs/information available.

# Regards
Thank you to Christoph "ich777" Hummer, would not have gotten this container created as fast without his base images.
Thanks to Paulov and everyone else that helps supporting the SIT Coop mod.
Thank to SPT-Aki Devs for creating SPT-Aki.
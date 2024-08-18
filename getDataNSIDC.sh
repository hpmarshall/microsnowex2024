# after setting up your EarthData credentials, run below "wget" command to repeat step of data download
wget --load-cookies ~/.urs_cookies --save-cookies ~/.urs_cookies --keep-session-cookies --no-check-certificate --auth-no-challenge=on -r --reject "index.html*" -np -e robots=off https://n5eil01u.ecs.nsidc.org/SNOWEX/SNEX20_GM_CTSM.001/

# This folder was then moved to /shared-public/microsnowex2024/microCT/
mv n5eil01u.ecs.nsidc.org/SNOWEX/SNEX20_GM_CTSM.001/* shared-public/microsnowex2024/microCT

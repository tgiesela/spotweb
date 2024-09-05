# ! /bin/bash

echo This script will add a regular user to a samba container and a SAMBA user.
read -p "Enter username: " username
read -s -p "Password: " password
docker exec -it samba addsambauser.sh ${username} ${password}

# ! /bin/bash

protectionpassword=sambasecret
sambausers=/config/sambausers.txt
touch $sambausers
function encrypt() {
    rslt=$(echo ${1}|openssl aes-256-cbc -pbkdf2 -e -a -salt -pass pass:${protectionpassword})
    echo "${rslt}"
}
function decrypt() {
    rslt=$(echo ${1}|openssl aes-256-cbc -pbkdf2 -d -a -salt -pass pass:${protectionpassword})
    echo "${rslt}"
}
function userexists() {
    rslt=$(getent passwd $1)
    if [ -z "$rslt" ] ;  then
        echo 0
    else
        echo 1
    fi
}
function importusers() {
    while read line ; do
        username=$(echo $line| awk '{print $2}')
        encpassword=$(echo $line| awk '{print $4}')
        password=$(decrypt $encpassword)
        add_user $username $password
    done < $sambausers
}
function add_user() {
    username=$1
    password=$2
    if [ "$(userexists $username)" == "1" ] ; then
        (echo $password ; echo $password) | passwd ${username}
    else
        (echo $password ; echo $password) | adduser --gecos "" ${username}
    fi
    (echo $password ; echo $password) | smbpasswd -a ${username}

}

CMD=$1
case "$CMD" in
    adduser)
        username=$2
        password=$3
        add_user $username $password
        # delete user from saved users
        sed '/user: ${username}/d' $sambausers
        encpassword=$(encrypt $password)
        echo "user: ${username} password: $encpassword" > $sambausers

        ;;
    import)
        importusers
        ;;
    *)
        echo "Expected one of the following"
        echo "    adduser <name> <password>"
        echo "    import"
	exit 1
        ;;
esac

#encpassword=$(echo ${password}|openssl aes-256-cbc -pbkdf2 -a -salt -pass pass:sambasecret)
#decpassword=$(echo ${encpassword}|openssl aes-256-cbc -pbkdf2 -d -a -salt -pass pass:sambasecret)


wget https://download.passbolt.com/ce/docker/docker-compose-ce.yaml

wget https://github.com/passbolt/passbolt_docker/releases/latest/download/docker-compose-ce-SHA512SUM.txt

sha512sum -c docker-compose-ce-SHA512SUM.txt

docker-compose -f docker-compose-ce.yaml up -d

create admin
echo docker-compose -f docker-compose-ce.yaml exec passbolt su -m -c "/usr/share/php/passbolt/bin/cake \
                                passbolt register_user \
                                -u <your@email.com> \
                                -f <yourname> \
                                -l <surname> \
                                -r admin" -s /bin/sh www-data

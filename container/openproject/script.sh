git clone https://github.com/opf/openproject-deploy --depth=1 --branch=stable/12 openproject


cd openproject/compose


docker-compose pull


OPENPROJECT_HTTPS=false docker-compose up -d

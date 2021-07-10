docker pull mihonho/acunetix_13

docker run --privileged=true --name acunetix -p3443:3443 -itd mihonho/acunetix_13 /sbin/init


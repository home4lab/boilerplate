docker pull mihonho/acunetix_13

docker run -d --privileged=true --name acunetix -p3443:3443 -itd mihonho/acunetix_13 /sbin/init


echo " Username: admin@admin.com "
echo " Password: admin@123 "
echo " Path: /home/acunetix/.acunetix/ "
echo " User: acunetix Pass: acunetix "

echo " https://your_ip:3443 "

# Kurento Media Server İnstall Documentation

* docker-compose up --build
* Stun-turn kullanımı için :
* docker exec ile containera girdikten sonra security updateleri gerçekleştirip aşağıdaki command in çalıştırılması gerekiyor :

* turnserver -L <public_ip_address> -o -a -f -r <realm-name>
> örneğin: turnserver -L 192.168.127.xx -o -a -f -r suzan.com

* eğer service düşerse elle müdahale gereken durumlarda ,
> sudo service coturn start
> service kurento-media-server start

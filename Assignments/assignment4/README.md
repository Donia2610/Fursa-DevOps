# AWS EC2 Exercise
## _Deploying a WordPress Application on a new AWS VPC_

started with creating AWS VPC (10.88.0.0/16)

![alt text](https://github.com/Donia2610/Fursa/blob/main/Assignments/assignment4/1.png?raw=true)

Then creating two subnets:
1. Public subnet (10.88.1.0/24)
2. Private Subnet (10.88.2.0/24)

![alt text](https://github.com/Donia2610/Fursa/blob/main/Assignments/assignment4/2.png?raw=true)

Created Internet Gateway 

![alt text](https://github.com/Donia2610/Fursa/blob/main/Assignments/assignment4/3.png?raw=true)

Created NAT gateway

![alt text](https://github.com/Donia2610/Fursa/blob/main/Assignments/assignment4/4.png?raw=true)

Added the internet and NAT gateways to the route tables

![alt text](https://github.com/Donia2610/Fursa/blob/main/Assignments/assignment4/5.png?raw=true)
![alt text](https://github.com/Donia2610/Fursa/blob/main/Assignments/assignment4/6.png?raw=true)

Created AWS instance for wordpress on the public subnet

![alt text](https://github.com/Donia2610/Fursa/blob/main/Assignments/assignment4/7.png?raw=true)

and AWS instance for MySQL on the private subnet

![alt text](https://github.com/Donia2610/Fursa/blob/main/Assignments/assignment4/8.png?raw=true)

Connected to the servers through SSH and installed Docker
and created docker-compose.yml files on each server

```sh
version: '3.7'
volumes:
    mysql_data:

services:
    database:
        image: mysql:5.7
        volumes:
            - mysql_data:/var/lib/mysql
        ports:
            - "3306:3306"
        restart: always
        environment:
            MYSQL_ROOT_PASSWORD: mypassword
            MYSQL_DATABASE: wordpress
            MYSQL_USER: wordpressuser
            MYSQL_PASSWORD: wordpress 
```


```
version: '3.7'
services:
    wordpress:

        image: wordpress:latest

        ports:
            - "8080:80"
        restart: always
        environment:
            WORDPRESS_DB_HOST: 10.88.2.124
            WORDPRESS_DB_USER: wordpressuser
            WORDPRESS_DB_PASSWORD: wordpress
            WORDPRESSS_DB_NAME: wordpress
```
Now I can open Wordpress on browser with the servers IP address 

![alt text](https://github.com/Donia2610/Fursa/blob/main/Assignments/assignment4/9.png?raw=true)




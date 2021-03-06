# Orchestration with Docker Compose
```
version: '3.1'

services:
  ocs:
    image: cmotta2016/ocsinventory
    environment:
      OCS_DBNAME: ocsdatabase
      OCS_DBSERVER_READ: database
      OCS_DBSERVER_WRITE: database
      OCS_DBUSER: ocsuser
      OCS_DBPASS: ocspasswd
    volumes:
      - ocsserver:/usr/share/ocsinventory-reports/
    ports:
      - "443:443"
    container_name: ocsinventory-server

  db:
    image: mysql:5.7.25
    environment:
      MYSQL_ROOT_PASSWORD_FILE: /run/secrets/db_root_password
      MYSQL_USER: ocsuser
      MYSQL_PASSWORD_FILE: /run/secrets/db_password
      MYSQL_DATABASE: ocsdatabase
    volumes:
      - database:/var/lib/mysql
    container_name: database
    secrets:
      - db_root_password
      - db_password

  glpi:
    image: cmotta2016/glpi
    volumes:
      - glpiserver:/var/www/glpi
    container_name: glpi-server

  proxy:
    build:
      dockerfile: Dockerfile.dev
      context: ./nginx
    ports:
      - "80:80"
    environment:
      GLPI: glpi-server
      OCS: ocsinventory-server

secrets:
  db_root_password:
    file: .mysql_root_password
  db_password:
    file: .mysql_ocsdb_password

volumes:
  database:
  ocsserver:
  glpiserver:
```

Deploying applications:
```
# docker-compose up --build -d 
```
# Installing Plugin
Install OCSInventory plugin directly inside directory mounted on volume glpiserver.
Check latest plugin on: https://github.com/pluginsGLPI/ocsinventoryng/releases

# Accessing applications
The access for both applications is made through nginx-proxy, accessing the url according subdirectory:
```
http://<your_url>/  --> to access glpi
and
http://<your_url>/ocsreports  --> to access ocsreports
```

OCS application had access by port 443 directly. This was made because the snmp agents use https to contact the server.

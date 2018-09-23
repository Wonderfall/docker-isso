## wonderfall/isso

![](https://i.goopics.net/q1.png)


#### What is this?
Isso is a commenting server similar to Disqus. More info on the [official website](https://posativ.org/isso/).

#### Features
- Based on Alpine Linux 3.3.
- Latest Isso installed with `pip`.

#### Build-time variables
- **ISSO_VER** : version of Isso.

#### Environment variables
- **GID** : isso group id *(default : 991)*
- **UID** : isso user id *(default : 991)*

#### Volumes
- **/config** : location of configuration files.
- **/db** : location of SQLite database.

#### Ports
- **8080** [(reverse proxy!)](https://github.com/hardware/mailserver/wiki/Reverse-proxy-configuration).

#### Example of simple configuration
Here is the full documentation : https://posativ.org/isso/docs/

```
# /mnt/docker/isso/config/isso.conf
[general]
dbpath = /db/comments.db
host = https://cats.schrodinger.io/
[server]
listen = http://0.0.0.0:8080/

# docker-compose.yml
isso:
  image: wonderfall/isso
  environment:
    - GID=1000
    - UID=1000
  volumes:
    - /mnt/docker/isso/config:/config
    - /mnt/docker/isso/db:/db
```

#### Example of uWSGI configuration
```
# /mnt/docker/isso/config/isso.uwsgi
[uwsgi]
http = :8080
master = true
; set to `nproc`
processes = 4
cache2 = name=hash,items=1024,blocksize=32
; you may change this
spooler = /var/spool/isso
module = isso.run

# docker-compose.yml
isso:
  image: wonderfall/isso
  environment:
    - GID=1000
    - UID=1000
  command: uwsgi --ini /config/isso.uwsgi
  volumes:
    - /mnt/docker/isso/config:/config
    - /mnt/docker/isso/db:/db
  environment:
    - ISSO_SETTINGS=/config/isso.conf
```

#### Example of Gunicorn configuration
```
# docker-compose.yml
isso:
  image: wonderfall/isso
  environment:
    - GID=1000
    - UID=1000
  command: gunicorn -b :8080 -w 4 --preload isso.run
  volumes:
    - /mnt/docker/isso/config:/config
    - /mnt/docker/isso/db:/db
  environment:
    - ISSO_SETTINGS=/config/isso.conf
```

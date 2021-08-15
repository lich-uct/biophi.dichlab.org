## Download OASis

TODO


## Add biophi user

(biophi) root@biophi:/opt/deployment# useradd biophi
(biophi) root@biophi:/opt/deployment# addgroup biophi staff
addgroup biophi www-data

Adding user `biophi' to group `staff' ...
Adding user biophi to group staff
Done.
(biophi) root@biophi:/opt/deployment# mkdir /home/biophi
(biophi) root@biophi:/opt/deployment# chown biophi:biophi /home/biophi

## Install redis

apt-get install redis-server

This will automatically start it as a service in the background

redis-cli PING

You should get PONG

## Set up gunicorn service

ln -s /opt/biophi/gunicorn/biophi-gunicorn.service /etc/systemd/system/biophi-gunicorn.service

  624  systemctl start biophi-gunicorn
  625  systemctl enable biophi-gunicorn
  626  systemctl status biophi-gunicorn

ln -s /opt/biophi/celery/biophi-celery.service /etc/systemd/system/biophi-celery.service


## Nginx & SSL

Based on: https://www.nginx.com/blog/using-free-ssltls-certificates-from-lets-encrypt-with-nginx/

nano /etc/nginx/sites-available/biophi.dichlab.org

server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name biophi.dichlab.org;

    location / {
        include proxy_params;
        proxy_pass http://localhost:5000;
    }
}

ln -s /etc/nginx/sites-available/biophi.dichlab.org /etc/nginx/sites-enabled/biophi.dichlab.org

certbot --nginx -d biophi.dichlab.org

systemctl restart nginx

## Aliases

alias suplog='less +G /var/log/supervisor/supervisord.log'

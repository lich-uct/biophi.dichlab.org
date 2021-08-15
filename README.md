# Ubuntu Deployment Scripts for biophi.dichlab.org

This repository contains the deployment configuration for the public http://biophi.dichlab.org/ server.

Feel free to use this as a template for 🐧 Ubuntu deployment.

## Deploying a new release

To deploy a new release, simply run the `./deploy.sh` script. 

## First time setup on Ubuntu

Here's how to set up the deployment. You'll need root acces for this (us `su root` or `sudo bash` to run as root).

Summary of the following steps:
- Set up directory and biophi user
- Install conda and BioPhi
- Install and set up redis database
- Set up flask & celery worker services
- Set up Nginx server and SSL

Some steps might be skipped here. If you get stuck, Google is your friend 😊

### Create deployment directory

This directory will host all the settings and the OASis DB.

```bash
# Create deployment directory (you need root access for this and everything that follows)
mkdir /opt/biophi
cd /opt/biophi
# Clone this repo (or your own fork) into current directory
git clone git@github.com:lich-uct/biophi.dichlab.org.git .
```

### Download OASis DB

Download and unzip the [OASis database file (22GB uncompressed)](https://zenodo.org/record/5164685).

```bash
# Enter the deployment directory
cd /opt/biophi
# Download database file
wget https://zenodo.org/record/5164685/files/OASis_9mers_v1.db.gz
# Unzip
gunzip OASis_9mers_v1.db.gz
```

### Add biophi user

```bash
useradd biophi
addgroup biophi staff
addgroup biophi www-data
mkdir /home/biophi /home/biophi/run
chown biophi:biophi /home/biophi /home/biophi/run
```

### Install redis

```bash
apt-get install redis-server
```

This will automatically start it as a service in the background

```bash
# Try calling redis
redis-cli PING
# You should get PONG
```

### Install BioPhi

You can install BioPhi using [Conda](https://docs.conda.io/projects/conda/en/latest/user-guide/install/download.html) 
or one of the alternatives ([Miniconda](https://docs.conda.io/en/latest/miniconda.html), 
[Miniforge](https://github.com/conda-forge/miniforge)).

Then, add conda to your PATH and run `conda init`.

```bash
# Create the BioPhi conda environment
conda create -n biophi python=3.8
conda activate biophi

# Install BioPhi and dependencies from Bioconda channel
conda install -c bioconda biophi
```

#### Installing BioPhi from git repository

If you want to install BioPhi directly from a git repository, you can clone it in a separate directory (e.g. `/opt/github-biophi`)
and then install using:

```bash
pip install --no-deps /opt/github-biophi
```

### Set up gunicorn service

Check the local gunicorn web server config and adjust as needed: 

- [gunicorn/biophi-gunicorn.service](gunicorn/biophi-gunicorn.service) Gunicorn service config
- [gunicorn/gunicorn.sh](gunicorn/gunicorn.sh) Gunicorn script, adjust concurrency based on your CPU count here
- [activate.sh](activate.sh) Conda and ENV var activation

Register the config as a systemd service:

```
ln -s /opt/biophi/gunicorn/biophi-gunicorn.service /etc/systemd/system/biophi-gunicorn.service
```

```bash
# Start gunicorn
systemctl start biophi-gunicorn
# Register gunicorn at startup (important!)
systemctl enable biophi-gunicorn
# Check the status of gunicorn
systemctl status biophi-gunicorn
```

### Set up celery service

Check the local celery worker config and adjust as needed: 

- [celery/biophi-celery.service](celery/biophi-celery.service) Celery service config
- [celery/celery.sh](celery/celery.sh) Celery script, adjust concurrency based on your CPU count here
- [activate.sh](activate.sh) Conda and ENV var activation

Register the config as a systemd service:

```bash
ln -s /opt/biophi/celery/biophi-celery.service /etc/systemd/system/biophi-celery.service
```

```bash
# Start celery
systemctl start biophi-celery
# Register celery at startup (important!)
systemctl enable biophi-celery
# Check the status of celery
systemctl status biophi-celery
```

## Set up nginx

Ngix will listen to HTTP & HTTPS traffic and serve the gunicorn responses as a proxy server.

Based on: https://www.nginx.com/blog/using-free-ssltls-certificates-from-lets-encrypt-with-nginx/

Create a basic nginx config file:

```
nano /etc/nginx/sites-available/biophi.dichlab.org
```

Enter the following:

```
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name biophi.dichlab.org;

    location / {
        include proxy_params;
        proxy_pass http://localhost:5000;
    }
}
```

Enable the config:

```
ln -s /etc/nginx/sites-available/biophi.dichlab.org /etc/nginx/sites-enabled/biophi.dichlab.org
```

```
# Restart nginx
systemctl restart nginx
# Check status
systemctl status nginx
```

### Set up HTTPS access

Generate SSL certificate using certbot 
(see [installation guide for Ubuntu 20](https://certbot.eff.org/lets-encrypt/ubuntufocal-nginx) 
or [other platforms](https://certbot.eff.org/instructions))

```
# Generate and install certificate
certbot --nginx -d biophi.dichlab.org
```

Your nginx config file `/etc/nginx/sites-available/biophi.dichlab.org` should now be updated with the SSL config.

```
# Restart nginx
systemctl restart nginx
# Check status
systemctl status nginx
```

### Done!

You should be all good to go. 
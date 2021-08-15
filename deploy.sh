#!/bin/bash

set -ex

cd /opt/github-biophi

git pull

source /opt/biophi/activate.sh

pip install . --no-deps

service biophi-celery restart
service biophi-gunicorn restart


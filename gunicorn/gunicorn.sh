#!/bin/bash

set -e

source /opt/biophi/activate.sh

gunicorn \
	--log-level debug \
	--workers 8 \
	--timeout 120 \
	--bind localhost:5000 \
	biophi.common.web.views:app

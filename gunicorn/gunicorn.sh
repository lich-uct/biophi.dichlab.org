#!/bin/bash
# Run BioPhi flask backend using gunicorn

# Exit on first error
set -e

# Activate conda env and set ENV vars
source /opt/biophi/activate.sh

gunicorn \
	--log-level debug \
	--workers 8 \
	--timeout 120 \
	--bind localhost:5000 \
	biophi.common.web.views:app

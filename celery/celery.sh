#!/bin/bash
# Run Celery worker service

# Exit on first error
set -e

# Activate conda env and set ENV vars
source /opt/biophi/activate.sh

celery \
	-A biophi.common.web.tasks.celery \
	worker \
	--loglevel=INFO \
	--concurrency 16

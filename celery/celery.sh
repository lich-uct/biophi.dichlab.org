#!/bin/bash

set -e

source /opt/biophi/activate.sh

celery \
	-A biophi.common.web.tasks.celery \
	worker \
	--loglevel=INFO \
	--concurrency 16

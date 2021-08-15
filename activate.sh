# Set up your conda installation directory (should include bin directory)
CONDA_DIR=/opt/mambaforge

# Add conda bin directory to PATH
export "PATH=$CONDA_DIR/bin:$PATH"

# Enable conda
source $CONDA_DIR/etc/profile.d/conda.sh

# Activate the BioPhi environment
conda activate biophi

# Set up ENV vars for BioPhi
export OASIS_DB_PATH=/opt/biophi/OASis_9mers_v1.db
export MAX_CONTENT_LENGTH=262144 # 256kb max upload file size
export MAX_INPUTS=100 # maximum number of input antibodies
export STATS_DB_PATH=/home/biophi/run/stats.db

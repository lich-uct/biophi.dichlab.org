CONDA_DIR=/opt/mambaforge

export "PATH=$CONDA_DIR/bin:$PATH"

source $CONDA_DIR/etc/profile.d/conda.sh
conda activate biophi

export OASIS_DB_PATH=/opt/biophi/OASis_9mers_v1.db
export MAX_CONTENT_LENGTH=262144 # 256kb max upload file size
export MAX_INPUTS=100 # maximum number of input antibodies
export STATS_DB_PATH=/home/biophi/run/stats.db
export MAILCHIMP_NEWSLETTER=c7bcd0367a4cdbbfe2ef413ff/c5b4d513538dcdb730f72a9db

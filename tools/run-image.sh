function usage() {
    echo 'Usage: run-image.sh env'
}

environment=$1

if [ -z "$environment" ]
then 
    echo "ERROR: argument 1, 'environment', not provided"
    usage
    exit 1
fi

network=$2
if [ -z "$network" ]
then
    echo "ERROR: argument 2, 'network', not provided"
    usage
    exit 1
fi

root=$(git rev-parse --show-toplevel)
config_mount="${root}/conf"
image="kbase/kbase-ui-proxy:dev"

if [ ! -e "${root}/conf/${environment}.env" ]
then
    echo "ERROR: environment (arg 1) does not resolve to a config file in ${root}/conf/${environment}.env"
    usage
    exit 1
fi

# A better solution coming soon...
options=""
dq = '"'
if [ -n "${local_narrative}" ]
then
    options=' -e "''local_narrative=true''"'
fi


echo "CONFIG MOUNT: ${config_mount}"
echo "ENVIRONMENT : ${environment}"

echo "Running proxy image ${image}"
echo "with options ${options}"
echo ":)"

cmd="docker run \
  -p 80:80 -p 443:443 --dns=8.8.8.8 --rm \
  --env-file=${config_mount}/${environment}.env \
  ${options} \
  --network=${network} \
  --name=proxy \
  ${image}"

echo "running: ${cmd}"
  
eval $cmd

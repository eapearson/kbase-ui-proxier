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
config_mount="${root}/deploy-envs"
image="kbase/kbase-ui-proxy:dev"

if [ ! -e "${config_mount}/${environment}.env" ]
then
    echo "ERROR: environment (arg 1) does not resolve to a config file in ${config_mount}/${environment}.env"
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

if [ -n "${dynamic_service_proxies}" ]
then
    options="${options}"' -e "''dynamic_service_proxies='"${dynamic_service_proxies}"'"'
fi

echo "CONFIG MOUNT: ${config_mount}"
echo "ENVIRONMENT : ${environment}"

echo "Running proxier image ${image}"
echo "with options: ${options}"
# echo "with dynamic service proxies: ${dynamic_service_proxies}"
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

#!/usr/bin/env bash

# set the cluster name, 'kind' by default.
cluster_name="kind"

while [ $# -gt 0 ]; do
    case $1 in
        -n|--name)
            cluster_name="$2"
            shift
            shift
            ;;
        -h|--help)
            echo "Usage: cluster-unpause.sh [-n|--name CLUSTER_NAME]"
            echo
            echo "Options:"
            echo -e "-n,--name\t\tSet the cluster name, '${cluster_name}' by default."
            echo -e "-h,--help\t\tShow this message and exit."
            exit 0
            ;;
        *)
            echo "[ERROR] Unknown option $1" >&2
            exit 1
            ;;
    esac
done

nodes="$(kind get nodes --name ${cluster_name} 2> /dev/null)"
if [ -n "${nodes}" ]; then
    docker unpause ${nodes}
fi

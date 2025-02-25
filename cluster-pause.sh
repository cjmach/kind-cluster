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
        *)
            echo "[ERROR] Unknown option $1" >&2
            exit 1
            ;;
    esac
done

nodes="$(kind get nodes --name ${cluster_name} 2> /dev/null)"
if [ -n "${nodes}" ]; then
    docker pause ${nodes}
fi

#!/usr/bin/env bash

# set the cluster name, 'kind' by default.
cluster_name="kind"
# path to kubeconfig file. 
kube_config="${HOME}/.kube/config"

while [ $# -gt 0 ]; do
    case $1 in
        -n|--name)
            cluster_name="$2"
            shift
            shift
            ;;
        -k|--kubeconfig)
            kube_config="$2"
            shift
            shift
            ;;
        *)
            echo "[ERROR] Unknown option $1" >&2
            exit 1
            ;;
    esac
done

kind --kubeconfig "${kube_config}" delete cluster --name "${cluster_name}"

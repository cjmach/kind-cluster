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
        -h|--help)
            echo "Usage: cluster-delete.sh [-n|--name CLUSTER_NAME] [-k|--kubeconfig CONFIG]"
            echo
            echo "Options:"
            echo -e "-n,--name\t\tSet the cluster name, '${cluster_name}' by default."
            echo -e "-k,--kubeconfig\t\tPath to kubeconfig file. Default is '${kube_config}'."
            echo -e "-h,--help\t\tShow this message and exit."
            exit 0
            ;;
        *)
            echo "[ERROR] Unknown option $1" >&2
            exit 1
            ;;
    esac
done

kind --kubeconfig "${kube_config}" delete cluster --name "${cluster_name}"

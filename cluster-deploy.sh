#!/usr/bin/env bash

# current working directory
cwd=$(dirname -- "$(readlink -f -- "${BASH_SOURCE}")")

# path to kubeconfig file. 
kube_config="${HOME}/.kube/config"
# path to helmfile file. 
helmfile_config="${cwd}/deploy/basic.yaml"
# Values to be injected in helmfile
values_file="${cwd}/deploy/values.yaml"

while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--file)
            helmfile_config="$2"
            shift
            shift
            ;;
        -k|--kubeconfig)
            kube_config="$2"
            shift
            shift
            ;;
        -v|--values-file)
            values_file="$2"
            shift
            shift
            ;;
        -h|--help)
            echo "Usage: cluster-deploy.sh [-f|--file HELMFILE] [-v|--values VALUES_FILE] [-k|--kubeconfig CONFIG]"
            echo
            echo "Options:"
            echo -e "-f,--file\t\tPath to helmfile file, '${helmfile_config}' by default."
            echo -e "-k,--kubeconfig\t\tPath to kubeconfig file. Default is '${kube_config}'."
            echo -e "-v,--values\t\tPath to values file to be injected in helmfile file. Default is '${values_file}'."
            echo -e "-h,--help\t\tShow this message and exit."
            exit 0
            ;;
        *)
            echo "[ERROR] Unknown option $1" >&2
            exit 1
            ;;
    esac
done

helmfile apply \
    --kubeconfig "${kube_config}" \
    --state-values-file "${values_file}" \
    --file "${helmfile_config}"

#!/usr/bin/env bash

# current working directory
cwd=$(dirname -- "$(readlink -f -- "${BASH_SOURCE}")")

# force cluster creation if it exists.
force="false"
# set the cluster name, 'kind' by default.
cluster_name="kind"
# set CNI, 'kindnet' by default. 'calico' also supported.
cni="kindnet" # or calico
# path to kind cluster configuration.
cluster_config="${cwd}/cluster/1m1w-${cni}.yaml"
# path to kubeconfig file. 
kube_config="${HOME}/.kube/config"
# kindest/node image version.
node_version="v1.32.2@sha256:f226345927d7e348497136874b6d207e0b32cc52154ad8323129352923a3142f"
# calico CNI version.
calico_version="v3.29.2"

while [ $# -gt 0 ]; do
    case $1 in
        --force)
            force="true"
            shift
            ;;
        -n|--name)
            cluster_name="$2"
            shift
            shift
            ;;
        -c|--cni)
            cni="$2" # TODO: Check if value is supported.
            shift
            shift
            ;;
        -f|--file)
            cluster_config="$2"
            shift
            shift
            ;;
        -i|--image-version)
            node_version="$2"
            shift
            shift
            ;;
        -k|--kubeconfig)
            kube_config="$2"
            shift
            shift
            ;;
        -h|--help)
            echo "Usage: cluster-create.sh [--force] [-n|--name CLUSTER_NAME] [-f|--file CLUSTER_CONFIG] [-c|--cni CNI(kindnet|calico)] [-i|--image NODE_IMAGE_VERSION] [-k|--kubeconfig CONFIG]"
            echo
            echo "Options:"
            echo -e "--force\t\t\tForce cluster creation if it exists. Default is '${force}'."
            echo -e "-n,--name\t\tSet the cluster name, '${cluster_name}' by default."
            echo -e "-f,--file\t\tPath to kind cluster configuration. Default is '${cluster_config}'"
            echo -e "-c,--cni\t\tSet CNI, '${cni}' by default. 'calico' is also supported."
            echo -e "-i,--image-version\tVersion of kindest/node image. Default is '${node_version}'."
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

# check if cluster already exists.
create_cluster="false"
if kind get clusters | grep --quiet "${cluster_name}"; then
    if [ "${force}" = "true" ]; then
        # force is true. Delete the existing cluster.
        echo "[WARN] Cluster ${cluster_name} already exists." >&2
        kind --kubeconfig "${kube_config}" delete cluster --name "${cluster_name}"
        create_cluster="true"
    else
        echo "[INFO] Cluster ${cluster_name} already exists." >&2
    fi
else
    create_cluster="true"
fi

if [ "${create_cluster}" = "true" ]; then
    kind create cluster \
        --name "${cluster_name}" \
        --config "${cluster_config}" \
        --image "kindest/node:${node_version}" \
        --kubeconfig "${kube_config}"
    if [ $? -eq 0 ] && [ "${cni}" = "calico" ]; then
        # install calico
        # see: https://docs.tigera.io/calico/latest/getting-started/kubernetes/kind
        kubectl --kubeconfig "${kube_config}" create -f https://raw.githubusercontent.com/projectcalico/calico/${calico_version}/manifests/tigera-operator.yaml
        kubectl --kubeconfig "${kube_config}" create -f https://raw.githubusercontent.com/projectcalico/calico/${calico_version}/manifests/custom-resources.yaml
    fi
fi


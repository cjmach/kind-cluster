# Description

Shell scripts to automate the creation of kubernetes clusters with [kINd](https://github.com/kubernetes-sigs/kind).
kINd already does a pretty good job automating the creation of a kubernetes cluster itself. These scripts provide 
an easy way to deploy applications and services to the cluster with the help of [helmfile](https://github.com/helmfile/helmfile)
and [helm](https://github.com/helm/helm) charts.

# Requirements

- Go and Docker: sudo dnf install go docker-ce (add `~/go/bin` directory to the PATH)
- Kubectl: sudo dnf install kubectl
- Kind: go install sigs.k8s.io/kind@v0.27.0
- Helm: sudo dnf install helm
- Hell-diff: https://github.com/databus23/helm-diff
- Helmfile: https://github.com/helmfile/helmfile/releases

These scripts run on Linux, other OSes may not be supported.

# Usage

1. Clone this repository.

```console
git clone https://github.com/cjmach/kind-cluster.git
```

2. Change to `kind-cluster` directory and create a kubernetes cluster with default options.

```console
cd kind-cluster
./cluster-create.sh
```

3. Deploy applications and services.

```console
# Deploy Nginx ingress controller and Kubernetes dashboard.
./cluster-deploy.sh -f deploy/basic.yaml

# Deploy Prometheus and Grafana.
./cluster-deploy.sh -f deploy/monitoring.yaml
```

4. Add cluster domain to `/etc/hosts` (the domain is specified in `deploy/values.yaml` file). 
Append the following line:

```
127.0.0.1 kind.example.com
```

5. Access the deployed applications through the following URLs:

- Kubernetes Dashboard: https://kind.example.com/k8s-dashboard
- Prometheus: https://kind.example.com/prometheus
- Grafana: https://kind.example.com/grafana

6. Add your own helmfiles to `deploy` directory to deploy more apps to the cluster.


# docker-eks-helm-kubectl

[![ci](https://github.com/quangthe/docker-eks-helm-kubectl/actions/workflows/docker.yaml/badge.svg)](https://github.com/quangthe/docker-eks-helm-kubectl/actions/workflows/docker.yaml)
[![Docker Stars](https://img.shields.io/docker/stars/pcloud/eks-helm-kubectl.svg?style=flat)](https://hub.docker.com/r/pcloud/eks-helm-kubectl/)
[![Docker Pulls](https://img.shields.io/docker/pulls/pcloud/eks-helm-kubectl.svg?style=flat)](https://hub.docker.com/r/pcloud/eks-helm-kubectl/)

Lightweight Docker image provide `kubectl` and `helm` for working with K8S cluster and specially AWS EKS cluster.

## Supported versions

| k8s  | helm   | aws-iam-authenticator | aws-cli |
|------|--------|-----------------------|---------|
| 1.25 | 3.10.3 | 0.6.2                 | 2.11.25 |
| 1.24 | 3.9.4  | 0.5.9                 | 1.22.81 |
| 1.23 | 3.8.2  | 0.5.9                 | 1.22.81 |
| 1.22 | 3.8.2  | 0.5.9                 | 1.22.81 |
| 1.21 | 3.8.2  | 0.5.9                 | 1.22.81 |

## Run

### Local

Quickly run helm/kubectl command

```bash
docker run --rm pcloud/eks-helm-kubectl helm version
docker run --rm pcloud/eks-helm-kubectl kubectl version --client
```

By default kubectl will try to use `/root/.kube/config` file for connection to the kubernetes cluster, but does not exist by default in the image.

Mount host `~/.kube/config` to container for troubleshooting

```bash
docker run --rm -it -v ~/.kube:/root/.kube pcloud/eks-helm-kubectl
```

Get contexts inside container:: `/config # kubectl config get-contexts`

### Use with Gitlab CICD

`.gitlab-ci.yaml`

```yaml,
stages:
  - verify

verify-my-cluster:
  stage: verify
  image: pcloud/eks-helm-kubectl:1.21.12
  before_script:
    - export AWS_ACCESS_KEY_ID=your-key-id
    - export AWS_SECRET_ACCESS_KEY=your-access-key
    - aws eks update-kubeconfig --region ap-southeast-1 --name my-cluster
    - kubectl config get-contexts
  script:
    - kubectl version --client
    - helm ls -A
  when: manual
```

## Build

Build local image: `make docker-build`

```
...
=> => writing image sha256:ef69f9233f9cbb49099d80d01fcf46f129189427e78bf705b969387af47c17a5                        0.0s
=> => naming to docker.io/pcloud/eks-helm-kubectl:main
```

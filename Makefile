default: docker_build

include .env

# Note: 
#	kubectl releases: https://github.com/kubernetes/kubernetes/releases
# helm releases: https://github.com/kubernetes/helm/releases
VARS:=$(shell sed -ne 's/ *\#.*$$//; /./ s/=.*$$// p' .env )
$(foreach v,$(VARS),$(eval $(shell echo export $(v)="$($(v))")))
DOCKER_IMAGE ?= pcloud/eks-helm-kubectl

# get git tag
# DOCKER_TAG ?= `git rev-parse --abbrev-ref HEAD`
# or just simply use dev tag
DOCKER_TAG:=dev

docker_build:
	@docker buildx build \
		--build-arg KUBE_VERSION=$(KUBE_VERSION) \
		--build-arg HELM_VERSION=$(HELM_VERSION) \
		--build-arg IAM_AUTHTHENTICATOR_VERSION=$(IAM_AUTHTHENTICATOR_VERSION) \
		-t $(DOCKER_IMAGE):$(DOCKER_TAG) .

docker_push:
	docker push $(DOCKER_IMAGE):$(DOCKER_TAG)
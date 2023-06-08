ARG BUILDPLATFORM
FROM ${BUILDPLATFORM}alpine:3

ARG KUBE_VERSION
ARG HELM_VERSION
ARG IAM_AUTHTHENTICATOR_VERSION
ARG TARGETOS
ARG TARGETARCH

RUN apk add --no-cache gomplate jq aws-cli-v2

RUN wget -q https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${IAM_AUTHTHENTICATOR_VERSION}/aws-iam-authenticator_${IAM_AUTHTHENTICATOR_VERSION}_${TARGETOS}_${TARGETARCH} -O /usr/local/bin/aws-iam-authenticator \
  && wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl -O /usr/local/bin/kubectl \
  && wget -q https://get.helm.sh/helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz -O - | tar -xzO ${TARGETOS}-${TARGETARCH}/helm > /usr/local/bin/helm \
  && chmod +x /usr/local/bin/aws-iam-authenticator /usr/local/bin/helm /usr/local/bin/kubectl \
  && mkdir /config \
  && chmod g+rwx /config /root \
  && helm repo add "stable" "https://charts.helm.sh/stable" --force-update \
  && kubectl version --client \
  && helm version

WORKDIR /config

CMD sh
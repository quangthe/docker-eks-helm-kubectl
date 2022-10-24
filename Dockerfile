FROM alpine:3.16.2

ARG KUBE_VERSION
ARG HELM_VERSION
ARG TARGETOS
ARG TARGETARCH

RUN apk add --no-cache gomplate jq curl

RUN curl -Lo aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.5.9/aws-iam-authenticator_0.5.9_linux_amd64 \
  && chmod +x aws-iam-authenticator \
  && install -c -m 0755 aws-iam-authenticator /usr/local/bin

RUN wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl -O /usr/local/bin/kubectl \
  && wget -q https://get.helm.sh/helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz -O - | tar -xzO ${TARGETOS}-${TARGETARCH}/helm > /usr/local/bin/helm \
  && chmod +x /usr/local/bin/helm /usr/local/bin/kubectl \
  && mkdir /config \
  && chmod g+rwx /config /root \
  && helm repo add "stable" "https://charts.helm.sh/stable" --force-update \
  && kubectl version --client \
  && helm version

WORKDIR /config

CMD sh
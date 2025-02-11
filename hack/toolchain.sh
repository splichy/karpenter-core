#!/usr/bin/env bash
set -euo pipefail

K8S_VERSION="${K8S_VERSION:="1.28.x"}"
KUBEBUILDER_ASSETS="/usr/local/kubebuilder/bin"

main() {
    tools
    kubebuilder
}

tools() {
    go install github.com/google/go-licenses@latest
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    go install github.com/google/ko@latest
    go install github.com/mikefarah/yq/v4@latest
    go install github.com/norwoodj/helm-docs/cmd/helm-docs@latest
    go install sigs.k8s.io/controller-runtime/tools/setup-envtest@latest
    go install sigs.k8s.io/controller-tools/cmd/controller-gen@latest
    go install github.com/sigstore/cosign/cmd/cosign@latest
    go install -tags extended github.com/gohugoio/hugo@v0.110.0
    go install golang.org/x/vuln/cmd/govulncheck@latest
    go install github.com/onsi/ginkgo/v2/ginkgo@latest
    go install github.com/rhysd/actionlint/cmd/actionlint@latest
    go install github.com/mattn/goveralls@latest

    if ! echo "$PATH" | grep -q "${GOPATH:-undefined}/bin\|$HOME/go/bin"; then
        echo "Go workspace's \"bin\" directory is not in PATH. Run 'export PATH=\"\$PATH:\${GOPATH:-\$HOME/go}/bin\"'."
    fi
}

kubebuilder() {
    sudo mkdir -p /usr/local/kubebuilder/bin
    sudo chown "${USER}" /usr/local/kubebuilder/bin
    arch=$(go env GOARCH)
    ln -sf $(setup-envtest use -p path "${K8S_VERSION}" --arch="${arch}" --bin-dir="${KUBEBUILDER_ASSETS}")/* ${KUBEBUILDER_ASSETS}
    find $KUBEBUILDER_ASSETS
}

main "$@"

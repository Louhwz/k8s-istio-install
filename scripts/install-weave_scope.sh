#!/usr/bin/env bash
set -x

main() {
  case "$1" in
  "install") kubectl apply -f "https://cloud.weave.works/k8s/scope.yaml?k8s-version=$(kubectl version | base64 | tr -d '\n')&k8s-service-type=NodePort"
  ;;
  "uninstall") kubectl delete -f "https://cloud.weave.works/k8s/scope.yaml?k8s-version=$(kubectl version | base64 | tr -d '\n')"
  ;;
  esac
}

main "$*"

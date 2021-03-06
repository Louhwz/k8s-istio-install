init-master:
	cd scripts && chmod +x install.sh && ./install.sh main master
.PHONY: init-master

init-slave:
	cd scripts && chmod +x install.sh && ./install.sh main
.PHONY: init-slave

# run after kubeadm reset
reset:
	rm -rf /etc/cni/net.d
	rm -rf $HOME/.kube/config
	iptables -F && iptables -t nat -F && iptables -t mangle -F && iptables -X

install-istio:
	cd scripts && chmod +x install_istio.sh && ./install_istio.sh

install-bookinfo:
	kubectl label namespace default istio-injection=enabled --overwrite
	kubectl apply -f yaml/istio-1.10.5-linux-amd64/istio-1.10.5/samples/bookinfo/platform/kube/bookinfo.yaml

verify-bookinfo:
	kubectl exec "$(kubectl get pod -l app=ratings -o jsonpath='{.items[0].metadata.name}')" -c ratings -- curl -sS productpage:9080/productpage | grep -o "<title>.*</title>"


# once master
install-weave:
	cd scripts && chmod +x install.sh && ./install.sh install::weave
.PHONY: install-weave

# once
install-dashboard:
	cd yaml/dashboard && \
	kubectl apply -f recommended.yaml && \
	kubectl apply -f dashboard-admin.yaml && \
	chmod +x get_token.sh && \
	sh get_token.sh
.PHONY: install-dashboard


# once
install-metrics:
	cd yaml/monitor/metrics-server && \
	kubectl apply -f deployment.yaml
.PHONY: install-metrics

# once
install-rook_pull-image:
	cd yaml/rook && chmod +x pull_image.sh && sh pull_image.sh
.PHONY: install-rook_pull-image

# once
install-rook: install-rook_pull-image
	cd yaml/rook/cluster/examples/kubernetes/ceph && \
	kubectl apply -f crds.yaml -f common.yaml -f operator.yaml && \
	kubectl apply -f cluster.yaml
.PHONY: install-rook_pull-image

install-prometheus:
	cd yaml/monitor/prometheus && \
	kubectl create namespace monitoring && \
	kubectl apply -f clusterRole.yaml && \
	kubectl apply -f config-map.yaml && \
	kubectl apply -f prometheus-deployment.yaml && \
	kubectl apply -f prometheus-service.yaml

# once
install-grafana:
	cd yaml/monitor/grafana && \
	kubectl apply -f grafana-datasource-config.yaml && \
	kubectl apply -f deployment.yaml && \
	kubectl apply -f service.yaml

# master
install-helm:
	cd scripts && \
	tar -zxvf helm-v3.6.1-linux-amd64.tar.gz -C /tmp && \
	mv /tmp/linux-amd64/helm /usr/local/bin/helm

# once
install-weave_scope:
	cd scripts && \
	chmod +x install-weave_scope.sh && \
	sh install-weave_scope.sh install

uninstall-weave_scope:
	cd scripts && \
	chmod +x install-weave_scope.sh && \
	sh install-weave_scope.sh uninstall

cleanup-bookinfo:
	chmod +x yaml/mesh/samples/bookinfo/platform/kube/cleanup.sh && \
	sh yaml/mesh/samples/bookinfo/platform/kube/cleanup.sh

install-krew:
	cd scripts && \
	chmod +x install_krew.sh && \
	sh install_krew.sh

# once
install-kube_state_metrics_configs:
	cd yaml/monitor/ && \
	kubectl apply -f kube-state-metrics-configs/

install-metrics-server:
	cd yaml/monitor/metrics-server && \
	kubectl apply -f deployment.yaml


# https://devopscube.com/node-exporter-kubernetes/
install-node-exporter:

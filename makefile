init-master:
	cd scripts && chmod +x install.sh && ./install.sh main master
.PHONY: init-master

init-slave:
	cd scripts && chmod +x install.sh && ./install.sh
.PHONY: init-slave

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
	tar -zxvf helm-v3.6.1-linux-amd64.tar.gz -o /root/downloads/ && \
	mv /root/downloads/linux-amd64/helm /usr/local/bin/helm

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

init-master:
	cd scripts && chmod +x install.sh && ./install.sh master
.PHONY: init-master

init-slave:
	cd scripts && chmod +x install.sh && ./install.sh
.PHONY: init-slave

install-dashboard:
	cd yaml/dashboard && \
	kubectl apply -f recommended.yaml && \
	kubectl apply -f dashboard-admin.yaml && \
	chmod +x get_token.sh && \
	sh get_token.sh
.PHONY: install-dashboard

install-metrics:
	cd yaml/monitor/metrics-server && \
	kubectl apply -f deployment.yaml
.PHONY: install-metrics

install-rook_pull-image:
	cd yaml/rook && chmod +x pull_image.sh && sh pull_image.sh
.PHONY: install-rook_pull-image

install-rook: install-rook_pull-image
	cd yaml/rook/cluster/examples/kubernetes/ceph && \
	kubectl apply -f crds.yaml -f common.yaml -f operator.yaml && \
	kubectl apply -f cluster.yaml
.PHONY: install-rook_pull-image

# for learning
sample-node_port:
	cd sample && \
	kubectl apply -f node-port.yaml



init-master:
	cd scripts && chmod +x install.sh && ./install.sh master

init-slave:
	cd scripts && chmod +x install.sh && ./install.sh

install-dashboard:
	cd yaml/dashboard && \
	kubectl apply -f recommended.yaml && \
	kubectl apply -f dashboard-admin.yaml && \
	chmod +x get_token.sh && \
	sh get_token.sh

install-metrics:
	cd yaml/monitor/metrics-server && \
	kubectl apply -f deployment.yaml

install-rook:
	cd yaml/rook && chmod +x pull_image.sh && sh pull_image.sh && \
	cd cluster/examples/kubernetes/ceph && \
	kubectl apply -f crds.yaml -f common.yaml -f operator.yaml && \
	kubectl apply -f cluster.yaml

# for learning
sample-node_port:
	cd sample && \
	kubectl apply -f node-port.yaml



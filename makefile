init-master:
	cd scripts && chmod +x install.sh && ./install.sh master

init-slave:
	cd scripts && chmod +x install.sh && ./install.sh

install-dashboard:
	cd yaml/dashboard && kubectl apply -f dashboard.yaml


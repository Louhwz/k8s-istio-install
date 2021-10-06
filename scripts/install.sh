#!/usr/bin/env bash
# for centos
set -e

install::docker() {
  # install docker
  yum install -y yum-utils
  yum-config-manager \
      --add-repo \
      https://download.docker.com/linux/centos/docker-ce.repo
  yum install -y docker-ce docker-ce-cli containerd.io
  systemctl start docker
}

install::k8s() {
  #加入一个kubernetes.repo的源:
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
#baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
EOF

  yum -y install epel-release
  yum clean all
  yum makecache
  yum install -y kubelet-1.21.0-0
  yum install -y kubectl-1.21.0-0
  yum install -y kubeadm-1.21.2-0
}

pull_image() {
  VERSION=v1.21.1
  ETCD_VERSION=3.4.13-0
  COREDNS_VERSION=1.8.0
  PAUSE_VERSION=3.4.1
  MY_REGISTRY=registry.cn-hangzhou.aliyuncs.com/google_containers

  ## 拉取镜像
  docker pull ${MY_REGISTRY}/kube-apiserver:${VERSION}
  docker pull ${MY_REGISTRY}/kube-controller-manager:${VERSION}
  docker pull ${MY_REGISTRY}/kube-scheduler:${VERSION}
  docker pull ${MY_REGISTRY}/kube-proxy:${VERSION}
  docker pull ${MY_REGISTRY}/etcd:${ETCD_VERSION}
  docker pull ${MY_REGISTRY}/coredns:${COREDNS_VERSION}
  docker pull ${MY_REGISTRY}/pause:${PAUSE_VERSION}

  ## 添加Tag
  docker tag ${MY_REGISTRY}/kube-apiserver:${VERSION} k8s.gcr.io/kube-apiserver:${VERSION}
  docker tag ${MY_REGISTRY}/kube-scheduler:${VERSION} k8s.gcr.io/kube-scheduler:${VERSION}
  docker tag ${MY_REGISTRY}/kube-controller-manager:${VERSION} k8s.gcr.io/kube-controller-manager:${VERSION}
  docker tag ${MY_REGISTRY}/kube-proxy:${VERSION} k8s.gcr.io/kube-proxy:${VERSION}
  docker tag ${MY_REGISTRY}/etcd:${ETCD_VERSION} k8s.gcr.io/etcd:${ETCD_VERSION}
  docker tag ${MY_REGISTRY}/coredns:${COREDNS_VERSION} k8s.gcr.io/coredns/coredns:v${COREDNS_VERSION}
  docker tag ${MY_REGISTRY}/pause:${PAUSE_VERSION} k8s.gcr.io/pause:${PAUSE_VERSION}

  ## 启动服务
  systemctl enable docker.service
  systemctl enable kubelet.service
}

kubeadm_init() {
  LogName="kubeadm_init.txt"
  kubeadm init --kubernetes-version=v1.21.1 | tee $LogName
}

mv_config() {
  rm -fr ~/.kube
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
}

install::weave() {
  kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')&env.IPALLOC_RANGE=10.0.0.0/8"
}

purify::master() {
  kubectl taint nodes --all node-role.kubernetes.io/master-
}

main() {
  install::docker
  install::k8s
  pull_image

  if [ "$1" == "master" ]
  then
    kubeadm_init
    mv_config
    purify::master
  fi

}

"$@"
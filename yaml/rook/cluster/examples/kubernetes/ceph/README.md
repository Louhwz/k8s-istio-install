1. 规划好要落数据的节点

2. 节点打标签 

`kubectl label nodes {kube-master1,kube-slave2,kube-slave1} ceph-osd=enabled`
`kubectl label nodes {kube-master1,kube-slave2,kube-slave1} ceph-mon=enabled`
3. 修改cluster.yaml中的`spce.storage.nodes`配置
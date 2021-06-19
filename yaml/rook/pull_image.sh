set -e

GOOGLE_REGISTRY="k8s.gcr.io"
STORAGE_GROUP="sig-storage"

docker pull registry.aliyuncs.com/it00021hot/csi-node-driver-registrar:v2.0.1
docker pull registry.aliyuncs.com/it00021hot/csi-attacher:v3.0.2
docker pull registry.aliyuncs.com/it00021hot/csi-provisioner:v2.0.4
docker pull registry.aliyuncs.com/it00021hot/csi-snapshotter:v4.0.0
docker pull registry.aliyuncs.com/it00021hot/csi-resizer:v1.0.1


docker tag registry.aliyuncs.com/it00021hot/csi-node-driver-registrar:v2.0.1 ${GOOGLE_REGISTRY}/${STORAGE_GROUP}/csi-node-driver-registrar:v2.0.1
docker tag registry.aliyuncs.com/it00021hot/csi-attacher:v3.0.2 ${GOOGLE_REGISTRY}/${STORAGE_GROUP}/csi-attacher:v3.0.2
docker tag registry.aliyuncs.com/it00021hot/csi-provisioner:v2.0.4 ${GOOGLE_REGISTRY}/${STORAGE_GROUP}/csi-provisioner:v2.0.4
docker tag registry.aliyuncs.com/it00021hot/csi-snapshotter:v4.0.0 ${GOOGLE_REGISTRY}/${STORAGE_GROUP}/csi-snapshotter:v4.0.0
docker tag registry.aliyuncs.com/it00021hot/csi-resizer:v1.0.1 ${GOOGLE_REGISTRY}/${STORAGE_GROUP}/csi-resizer:v1.0.1
set -e

secret=$(kubectl -n kubernetes-dashboard get secret | grep dashboard-admin | awk '{print $1}')
kubectl -n kubernetes-dashboard describe secret "${secret}" |  tee token.txt

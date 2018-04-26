


echo "Starting mediawiki on kubernetes using persistant disks!"

echo "make sure youre logged into gcloud!"

echo "creating cluster"

gcloud container clusters create persistent-disk-tutorial --num-nodes=3 --enable-network-policy

gcloud compute disks create --size 200GB mysql-disk
gcloud compute disks create --size 200GB mediawiki-disk

gcloud config unset container/use_client_certificate

gcloud container clusters get-credentials persistent-disk-tutorial

kubectl create secret generic mysql --from-literal=password=123virtual

kubectl create -f mysql.yaml

kubectl create -f mysql-service.yaml

echo "sleeping 30s while mysql configures"

sleep 30

kubectl create -f mediawiki.yaml

kubectl create -f mediawiki-service.yaml

kubectl create -f nginx-service.yaml

#./expose_nginx.sh

#kubectl create -f threeTierService.yaml

#echo 'sleeping to wait for external ip to be set up...'

#sleep 30

#kubectl create configmap mediawiki-config --from-literal=MYSQLl_IP=$(kubectl get pods -o=wide | grep "mysql" | cut -c 71-80) --from-literal=EXTERNAL_IP=$(kubectl get services | grep "nginx" | cut -c 44-55)

#kubectl create -f mediawiki.yaml

echo ""
echo "here are the pods"
echo ""
kubectl get pods -o=wide

echo ""
echo "here are the deployments"
echo ""
kubectl get deployments

echo "heres what services are running: "
echo ""

kubectl get services


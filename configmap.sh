kubectl create configmap mediawiki-config --from-literal=MYSQLIP=$(kubectl describe pod mysql | grep "IP" | cut -c 17-) --from-literal=EXTERNALIP=$(kubectl describe service nginx | grep "Ingress" | cut -c 27-)




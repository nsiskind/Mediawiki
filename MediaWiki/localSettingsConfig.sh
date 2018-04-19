# NEED TO CHANGE

echo 'Setting up localSettings!'
echo ''
#echo 'Going to sleep for 30 seconds to wait for external ip!'
#
#sleep 30;

#to find external ip
EXTERNALIP="$(kubectl describe service nginx | grep "LoadBalancer Ingress" | cut -c27-)"

#to find cluster
CLUSTERIP="$(kubectl describe service mysql | grep "IP:" | cut -c20-)"

echo 'External IP: ' ${EXTERNALIP}

echo 'Cluster IP: ' ${CLUSTERIP}


sed -i "s/EXTERNALIP/${EXTERNALIP}/" LocalSettings.php

sed -i "s/CLUSTERIP/${CLUSTERIP}/" LocalSettings.php

# (external ip)
# server
# emergency contact
# password sender

# (cluster ip)
# dbServer


#then
echo 'Inserting localsettings into pod: ' $(kubectl get pods | grep "mediawiki" | cut -c1-26)

#kubectl cp LocalSettings.php $(kubectl get pods | grep "mediawiki" | cut -c1-26):/var/www/html

echo ''
echo 'here are your services, visit the external IP to see mediawiki!'
kubectl get services

#trap : TERM INT; sleep infinity & wait

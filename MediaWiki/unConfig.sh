#EXTERNALIP="$(kubectl describe service mediawiki | grep "LoadBalancer Ingress" | cut -c27-)"

#to find cluster
#CLUSTERIP="$(kubectl describe service mysql | grep "IP:" | cut -c20-)"

#echo 'External IP: ' ${EXTERNALIP}

#echo 'Cluster IP: ' ${CLUSTERIP}




sed -i "s/"$EXTERNALIP"/EXTERNALIP/" LocalSettings.php

sed -i "s/"$CLUSTERIP"/CLUSTERIP" LocalSettings.php



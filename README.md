# Mediawiki

## How to set up the application (step by step)
------------------------------------------------

### 1. Set Up
1. Create a gcloud account and a new project

2. Install kubernetes to your gcloud and set your project up 

	``` 
	gcloud components install kubectl
	gcloud config set project [my_new_project_ID]
	gcloud config set compute/zone us-central1-b

	```

3. You will also want to ensure that necessary APId are set up for your cloud project.
	To do this, open the gcloud console at https://console.cloud.google.com
	You will need to enable at least the Cloud Container API and the Kubernetes Cluster API.
	Any other APIs that you need will be specified by console errors


4. Build your mediawiki image and push it the the cloud!
	You'll need to build the image with this special name
	Here the name "mediawiki" is used because the yaml files specify this is the image name
	If you would like to change the name, you must change the yaml file names to match.

	```
	cd MediaWiki
	
	sudo docker build -t gcr.io/my_new_project_ID/mediawiki
	
	gcloud docker -- push gcr.io/my_new_project_ID/mediawiki

	```

 
### 2. Running the Application

1. To run the application just execute kubestart.sh.
	```
	./kubestart.sh
	```

	This will build necessary yaml files to create pods, expose them as services, and expose the to the internet.

2. To view the application. You may need to wait a minute or two before the external IP is set up.
	To check this:
	
	```
	kubectl get services
	```

3. As of now, you must configure your applciation manually. To do this, you can access the external ip of the nginx load balancer when
	you enter the get services command.
	Then simply follow the directions and fill out the form. The only things that matter are the DB host, 
	which is mysql (this is the DNS name which resolves to the cluster IP of the mysql pod),
	the DB password, which based on this configuration is 123virtual, and the DB user, which should stay as root.
	You may set the site name and other things to what ever you want.
	Once you download the the LocalSettings.php file, copy it into the mediawiki pod using this command:

	```
	kubectl cp LocalSettings.php $(kubectl get pods | grep "mediawiki" | cut -c1-26):/var/www/html
	```
	
	This will only work if you have one mediawiki pod running. If you would like to scale up, you must copy this file into the 
	subsequently created containers.
	

### 3. Closing Application and Deleteing the cluster

	./kubestop.sh
	


### 4. Network Policy

The cluster will be created to support network policies!
	To see them in action simply create the badmediawiki.yaml file and notice that it will not be able to communicate with the database.
	This is because the kubestart script created the networkPolicy.yaml file.

To see your network policy enter:


	kubectl get NetworkPolicy
	
###5. Extras!

-> [This](https://cloud.google.com/kubernetes-engine/docs/tutorials/persistent-diskhttps) is the tutorial that I based most stuff on

#####Exposing kubernetes pods to each other:

[Service docs](https://kubernetes.io/docs/concepts/services-networking/service/#external-ips) specify that a service defines a “logical set of pods”    

#####Connecting Pods in the Cluster:

Pods can be connected in different ways. Many times it depends on the application running inside the pods. For example, with mediawiki, it is the LocalSettings.php file that really specifies where the data is going. Fortunately, you can set this up beforehand properly, using DNS (at least for the backend). Kubernetes DNS allows you to specify SERVICES by name. So as long as everything is consistent in the configs and the services, they will find each other.

LocalSettings also needs a specified external IP. This is harder to set up beforehand. As discussed below it is possible to specify in an nginx.conf file, but this may not be a proper set up.

Mostly, DNS will be the way that pods find other pods. Each pod is given a cluster IP and a name when exposed as a service of type cluster IP.

Load balancing the mediawiki application:
    
2 ways that I have discovered:

1. You have specified that you would like mediawiki traffic to pass through a nginx pod.
    
Use nginx.conf file to build the image to point to the mediawiki service using DNS. Then, the service runs round robin on the mediawiki pods. 
It also makes the MediaWiki’s LocalSettings.php configuration easier because the “external- ip” becomes a name specified in the nginx.conf file. 
I’m not sure if this is balancing properly, as it’s really just pointing all traffic to one service, which runs round-robin naturally.
Maybe, you could be able to use two separate services (or as many as you would like) to expose the mediawiki pods and then load balance those services, specifying it in the nginx.conf.

2. kubernetes docs simply use a service of type load-balancer to expose the pods to the internet. The service knows which pods to expose by using a [run selector](https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/)
If you would like multiple load-balancers for the same application, you could just make multiple load-balancer services, which would have different external IP’s but all point to the same application/database. Check out the nginx-service.yaml file on the Github page to see how the LoadBalancer selects the mediawiki pods!


#####Network policies in Kubernetes

[This tutorial](https://kubernetes.io/blog/2017/10/enforcing-network-policies-in-kubernetes) has proved very useful and simple.

[Here](https://kubernetes.io/docs/concepts/services-networking/network-policies/#the-networkpolicy-resource) is also some more specific documentation provided by kubernetes.

Essentially after enabling network policies in the cluster using the flag --enable-network-policy,
You can create a NetworkPolicy object, similar to the one in the tutorial. This can be created by the command:
    Kubectl create -f network_policy_descriptor.yaml

Then, based on this yaml file, you may specify what pods may talk to others by replacing the “app” in the example with apps, names, or tiers. To determine who can talk to who.

The second link here shows that kubernetes  allows you to specify restrictions on both Ingress and Egress traffic from pods.
 

####Problems I ran into:
    
The biggest set back in setting up this mediawiki application, was getting the mediawiki LocalSettings.php to be auto-generated. In fact, as of now, this has not been implemented and the LocalSettings must be manually generated and copied into the correct folder of the pod, as specified in the README.

See [this](https://github.com/wikimedia/mediawiki-docker/tree/master/dev) repository for more information about automating the mediawiki set-up.

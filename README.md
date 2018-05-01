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
```
	./kubestop.sh
	```


### 4. Extras

The cluster will be created to support network policies!
	To see them in action simply create the badmediawiki.yaml file and notice that it will not be able to communicate with the database.
	This is because the kubestart script created the networkPolicy.yaml file.

To see your network policy enter:

```
	kubectl get NetworkPolicy
	```

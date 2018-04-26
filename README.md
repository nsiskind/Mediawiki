# Mediawiki

##How to set up the application (step by step)
------------------------------------------------

###1. Set Up
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

 
###2. Running the Application

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

###3. Closing Application and Deleteing the cluster

1. ```./kubestop.sh```

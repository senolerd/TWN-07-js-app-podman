
This project is based on 

    https://gitlab.com/twn-devops-bootcamp/latest/07-docker/js-app

Changed to Podman workflow. 

## demo app - deploying with Podman

This demo app shows a simple user profile app set up using 
- index.html with pure js and css styles
- nodejs backend with express module
- mongodb for data storage
- mongo-express for to confirm health of frontend-backend connectivity

All components are podman-based either for standalone containers or Pod deployment. 

#### Why Podman

Since industrial containerization standart moving to rootless approach for every deployment model, podman is chosen for container runtime/engine. Podman is supoorting right out of the box a spesific subset of Kubernetes resources like Pod, Deployment, ConfigMap, Secret, Volume (hostPath, emptyDir, configMap, persistentVolumeClaim, and image). This gives numerous of DevOps development benefits. With a small usage learning curve, deployments business logic parts can be designed for Podman in a K8S manifest file. Single nanifest file that works for both side as is sounds cool. 

#### Building application image

    podman build -t js-app:latest .

This will produce an image tagged "localhost/js-app:latest"

### Application with standalone containers

Step 1: Create podman network

    podman network create mongo-network 

Step 2: start mongodb 

    podman run -d -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=admin -e MONGO_INITDB_ROOT_PASSWORD=password --name mongodb --net mongo-network mongo    

Step 3: start mongo-express
    
    podman run -d -p 8081:8081 -e ME_CONFIG_MONGODB_ADMINUSERNAME=admin -e ME_CONFIG_MONGODB_ADMINPASSWORD=password --net mongo-network --name mongo-express -e ME_CONFIG_MONGODB_SERVER=mongodb -e ME_CONFIG_MONGODB_URL=mongodb://mongodb:27017 mongo-express   

_NOTE: creating podman-network is optional. You can start both containers in a default network. In this case, just emit `--net` flag in `docker run` command_

Step 4: open mongo-express from browser

    http://{HOST_IP}:8081


Step 5: create `user-account` _db_ and `users` _collection_ in mongo-express

Step 6: Build and run frontend application

    podman build -t js-app:latest .      
    podman run -d -p 3000:3000 --network mongo-network -e "MONGO_URL=mongodb://admin:password@mongodb:27017"

The dot "." at the end of the command denotes location of the either Containerfile or Dockerfile.


Step 7: Access you nodejs application UI from browser

    http://{HOST_IP}:3000

### With Podman Pod and K8S Compatible Manifest

#### To start the application

    podman kube play podman-kube-pod.yaml

This will create a Pod with 3 container. The manifest file is created by using Pod resource, but is completely feasible to change to Deployment to benefir ReplicaSet.

Application fronted node application is accesable at http://{HOST_IP}:3000 and mongo-express is accessabe at http://{HOST_IP}:18081

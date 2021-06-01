# Kubernetes Assignment


## To run the project:
- Clone Spring Pet Clinic repo:
```sh
git clone https://github.com/spring-projects/spring-petclinic.git
```
- Build Docker image for Spring Pet Clinic:
```sh
mvn compile -Dimage=spring/petclinic:spring-k8s-1 com.google.cloud.tools:jib-maven-plugin:1.0.0:dockerBuild
```

- Create deployment and run using Kubernetes
```sh
 kubectl apply -f petclinic-deployment.yml
```
```sh
   kubectl port-forward deployment/springpetclinic-k8s 8080:8080
```
Open browser with on https://localhost/8080




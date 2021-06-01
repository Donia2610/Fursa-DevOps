# Jenkins assignment   
Jenkins job to build maven project

#### Make sure you install Maven
```sh
apt install maven -y
```
### Creating jenkins job:  

#### - Press "Create New Item", Add name and choose freestyle project 

#### - Add a Description  
![image](https://github.com/Donia2610/Fursa-DevOps/blob/main/Assignments/jenkins/1.png?raw=true)


#### - In "Source Code Managment", add the github repository
```sh
https://github.com/jglick/simple-maven-project-with-tests
```
![image](https://github.com/Donia2610/Fursa-DevOps/blob/main/Assignments/jenkins/2.png?raw=true)

#### - Navigate to "Build", and add the folowing command to build the project :  
```sh
mvn -Dmaven.test.failure.ignore=true clean package
```

![image](https://github.com/Donia2610/Fursa-DevOps/blob/main/Assignments/jenkins/3.png?raw=true)

#### - Press on "Build Now" and go to "Console Output"

![image](https://github.com/Donia2610/Fursa-DevOps/blob/main/Assignments/jenkins/4.png?raw=true)

#### You can find your job in Dashboard

![image](https://github.com/Donia2610/Fursa-DevOps/blob/main/Assignments/jenkins/5.png?raw=true)


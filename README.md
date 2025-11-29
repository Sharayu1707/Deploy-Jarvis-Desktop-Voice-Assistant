# Deploy-Jarvis-Desktop-Voice-Assistant

## Overview

To build a voice-based AI assistant like JARVIS that can listen, speak, answer questions, play songs, search Wikipedia, and automate tasks, and then deploy it on AWS EC2 using Terraform and integrate Jenkins for automation (CI/CD pipeline).

![Architecture](images/Screenshot%20(118).png)

## Features

✔ Voice command recognition (Speech-to-Text)

✔ Jarvis speaks (Text-to-Speech using pyttsx3)

✔ Understands natural language questions

✔ Greets based on time (Good Morning/Afternoon/Evening)


## Project Structure

Deploy-Jarvis-Desktop-Voice-Assistant /
│
|── jarvis.py
│
├──requirements.txt
|
├──jenkinsfile 
|
└── README.md


## Deployment steps 

### Step 1: (terraform setup)

create-file
|
|_provider.tf
|
|_main.tf 
|
|_variable.tf
|
|_output.tf

#### To Deploy

terraform init

terraform plan

terraform apply

![Architecture](images/Screenshot%20(116).png)

### Step 2 : (jenkins setup)

SSH into instance:

ssh -i key.pem ubuntu@PUBLIC_IP

Install Jenkins:

sudo apt update

sudo apt install -y openjdk-11-jdk

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

sudo apt update

sudo apt install -y jenkins

sudo systemctl enable jenkins

sudo systemctl start jenkins

Access Jenkins:

http://PUBLIC_IP:8080

Initial Password:

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

Jenkinsfile for Deployment

pipeline {
  agent any

  environment {
    REMOTE_USER = "ubuntu"
    REMOTE_HOST = "3.137.166.20"
    REMOTE_DIR  = "/home/ubuntu/jarvis"
    CRED_ID     = "jarvins-key"
  }

  stages {

    stage('Checkout') {
      steps {
        // CHANGE THIS --->
        git branch: 'main', url: 'https://github.com/Sharayu1707/Deploy-Jarvis-Desktop-Voice-Assistant.git',
        credentialsId: 'jarvins' 
      }
    }

    stage('Package & Transfer') {
      steps {
        sshagent(credentials: ["${CRED_ID}"]) {
          sh """
            ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} 'mkdir -p ${REMOTE_DIR}'
            rsync -avz --delete --exclude='.git' ./ ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/
          """
        }
      }
    }

    stage('Remote: Setup & Restart') {
      steps {
        sshagent(credentials: ["${CRED_ID}"]) {
          sh """
            ssh -o StrictHostKeyChecking=no ${REMOTE_USER}@${REMOTE_HOST} '
              cd ${REMOTE_DIR} &&
              sudo apt update -y &&
              sudo apt install -y python3-venv python3-pip &&
              python3 -m venv venv &&
              source venv/bin/activate &&
              pip install -r requirements.txt &&
              sudo systemctl restart jarvis || echo "Service not found, check systemd file"
            '
          """
        }
      }
    }
  }
}

#### step 3 : (Add Jenkins SSH Credentials)

Jenkins → Credentials → Global → Add Credentials

Type → SSH Username with Private Key\

Username → ubuntu\

Private Key → Paste PEM\

ID → ubuntu

![Architecture](images/Screenshot%20(121).png)

#### Step 4 : (Deployment)

Create Job → Pipeline from SCM → Select Repo → Add Jenkinsfile Path

Every push = automatic deployment.

![Architecture](images/Screenshot%20(117).png)

#### Step 5 : (command)

python3 jarvins.py

## Outcomes

Deployed an AI-based Jarvis voice assistant on AWS using Terraform and Python automation.

Implemented Infrastructure as Code (IaC), automated EC2 provisioning, environment setup using user data scripts, virtual environment & remote deployment.


![Architecture](images/Screenshot%20(122).png)


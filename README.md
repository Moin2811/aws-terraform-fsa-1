🌤️ AWS Terraform Project – High‑Availability PHP Application with RDS & ALB
Fully automated AWS infrastructure using Terraform

Welcome to this project! 🎉
If you’re looking to deploy a high‑availability PHP web application on AWS using Terraform — including EC2, ALB, RDS, Autoscaling, phpMyAdmin, Security Groups, IAM Roles, and more — then you're in the right place.

This project is designed to help beginners and intermediate users see exactly how real‑world AWS infrastructure is deployed using Terraform… automatically, reliably, and repeatably.

🚀 What This Project Does
This Terraform configuration automatically builds:

🟦 Networking
VPC

Public & private subnets

Internet Gateway

NAT Gateway

Route tables

🟩 Compute Layer
EC2 Launch Template for PHP App

Autoscaling Group

Target Group + Health Checks

🟥 Database Layer
Amazon RDS MySQL (private subnet)

Secure Security Groups

DB subnet groups

🟨 Load Balancing
Application Load Balancer (ALB)

Listener (Port 80)

Traffic distribution between EC2 instances

🟪 App Functionality
PHP web application

phpMyAdmin accessible through ALB

DB connection automatically configured

All of this is automated with one Terraform apply.

🌟 Architecture Diagram (Conceptual)


                 ┌────────────────────────────┐
                 │      Application LB         │
                 └──────────────┬──────────────┘
                                │
                 ┌──────────────┴──────────────┐
                 │   Auto Scaling (EC2 PHP)     │
                 └──────────────┬──────────────┘
                                │
                 ┌──────────────┴──────────────┐
                 │       RDS MySQL DB           │
                 └──────────────────────────────┘

🛠️ How to Run This Project

1️⃣ Clone the Repository
git clone <your-repo-url>
cd aws-terraform-project-fsa1


2️⃣ Initialize Terraform
terraform init


3️⃣ Review the Plan
terraform plan


4️⃣ Deploy Everything
terraform apply -auto-approve


🎉 Done! Your AWS infrastructure is live.

🔍 How to Test the Application After Deployment
✔️ Test 1: Open the Application in Browser
Copy the ALB DNS output:

alb_dns = <value>
Paste it into your browser.

You should see:

PHP server: app-server1
Refresh the page — if stickiness is disabled, it will alternate between:

app-server1

app-server2

This confirms:
✔ ALB working
✔ Target Group healthy
✔ Autoscaling instances responding

✔️ Test 2: Test phpMyAdmin
Open:

http://<alb_dns>/phpMyAdmin
Login with:

Username: admin
Password: admin
(You can change this in the variables.)

If it loads successfully, your RDS + SG rules + PHP stack are working perfectly.

📂 Project Structure

├── main.tf                 # Main infrastructure definitions

├── vpc.tf                  # VPC + networking

├── ec2.tf                  # Launch template + ASG

├── alb.tf                  # Application Load Balancer

├── rds.tf                  # MySQL database

├── security-groups.tf      # All SGs

├── outputs.tf              # ALB, RDS outputs

├── variables.tf            # Input variables

├── user-data.sh            # Install PHP & application files

⭐ Key Features

💡 Modular Design

Everything is clean, separated, and easy to modify.

🔐 Secure by Design

EC2 in public subnet

RDS in private subnet

SG restricts DB access only from EC2

🔁 Fully Repeatable

Destroy and recreate your entire AWS application any time:

terraform destroy -auto-approve


All of this is automated with one Terraform apply.




Author
Moin Raoof Mohammed


Cloud and DevOps Enthusiast

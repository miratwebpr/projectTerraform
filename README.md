# ​​Three-Tier Architecture Deployment on AWS with Terraform

This Terraform project is to create a scalable, secure and highly available infrastructure that separates the different layers ensuring they are all communicating with each other. The three-tier architecture consisting of a Web tier, Application tier and a Database tier in private subnets with Autoscaling for the web and application tier and a load balancer. Nat gatway provisioned to allow access to the internet.

The architecture includes an Amazon Virtual Private Cloud (VPC), Elastic Load Balancer (ELB), Auto Scaling Group (ASG), and a Relational Database(RDS) MySQL.


<!-- - The Web tier will have a bastion host and NAT gateway provisioned in the public subnets. The bastion host will serve as our access point to the underlying infrastructure. The NAT Gateway will allow our private subnets to communicate with the internet  while maintaining a level of security by hiding the private instances' private IP addresses from the public internet.
- In the Application tier, we will create an internet facing load balancer to direct internet traffic to an autoscaling group with launch template in the private subnets. We used the user data to clone Django project from GitHub into S3 bucket, establish the database connection credentials, and finally deploy Django project. 
- In the Database tier, we will have another layer of private subnets hosting a MySQL database which will  eventually be accessed by Django project. -->
 
![Architecture diagram](https://github.com/miratwebpr/projectTerraform/blob/main/Untitled%20Diagram.drawio.png)
 
 
Here is a step-by-step guide to deploying this architecture on Amazon Web Services (AWS) using Terraform.

 
## Prerequisites
 
Before you begin, ensure that you have the following prerequisites:
 
1. AWS account, IAM user with proper permission, and configured AWS CLI. See the https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html on how to setup the AWS Command Line Interface.
2. Terraform installed on your local machine. You can download Terraform from the official website: https://www.terraform.io/downloads.html.
3. Basic knowledge of AWS services such as EC2, VPC, ELB, ASG, and RDS.
4. Familiarity with the basics of Terraform, including how to write Terraform configuration files (`.tf`).
5. Install GitHub.
6. Have Visual Studio Code or similar IDE. 
7. Connect to remote host using ssh keys. Please use the foolowing link https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html to create AWS EC2 key pair.
 
## Steps
 
Follow these step-by-step instructions to deploy a three-tier architecture on AWS using Terraform:
 
### Step 1: Clone the Repository
 
1. Open a terminal or command prompt on your local machine.
2. Clone the repository containing the Terraform configuration files:
   ```
   git clone https://github.com/miratwebpr/projectTerraform.git
   ```
3. Change into the project directory:
   ```
   cd projectTerraform
   ```

### Step 2: S3 bucket
- Comment out backend s3 backend in s3.tf

### Step 3: Configure Terraform Variables and Domain name.
 
1. Open the project directory in a text editor.
2. Locate the Terraform configuration file named `var.tf”. 
3. Modify the values of the variables according to your requirements.
   (ex. Change region, availability zones, or database info as needed)
4. Change your domain in route53.tf
5. Change the bucket name in s3.tf from datatechtorialbucket to your NAME
6. Change str 128 in instance.tf from
   ```
    sg = aws_rds_cluster
   ```
   on
   ```
    sg = aws_db_instance
   ```

(OPTIONAL)
- Comment out cluster resource in rds.tf
- Uncomment db instance creation in rds.tf

### Step 4: Initialize Terraform
 
1. In the terminal or command prompt, navigate to the project directory., cd to the root directory ‘terraform’
2. Run the following command to fix any syntax issue
    ```
    terraform fmt
    ```
3. Run the following command to initialize Terraform and download the required providers:
   ```
   terraform init
   ```
 
### Step 5: Review and Validate the Configuration
 
1. Run the following command to review the changes that Terraform will make:
   ```
   terraform plan
   ```
   Review the output to ensure that the planned infrastructure matches your expectations.
 
### Step 6: Deploy the Infrastructure
 
1. Run the following command to deploy the infrastructure:
   ```
   terraform apply 
   ```
   Terraform will show you a summary of the changes that will be made. Type `yes` to confirm and start the deployment.
 
2. Wait for Terraform to provision the infrastructure. This process may take several minutes.
 
### Step 7: Access the Application
 
1. After the deployment is complete, Terraform will output the DNS name of the ALB that is configured on hosted zone available on wordpress.<yourdomain>.com.
2. Copy the domain wordpress.<yourdomain>.com and paste it into your web browser.
3. If everything is set up correctly, you should see the application running.
 

### Step 8: Confirm Infrastructure
If you go into your AWS console, you should be able to see the VPC and subnets, internet gateway, route tables and associations, EC2 instances running in the proper locations, load balancers, and RDS database.


### Step 9: Destroy the Infrastructure (Optional)
 
If you want to tear down the infrastructure and remove all resources created by Terraform, you can follow these steps:
 
1. In the terminal or command prompt, navigate to the project directory.
2. Run the following command to destroy the infrastructure:
   ```
   terraform destroy
   ```
   Type `yes` to confirm the destruction.

## Conclusion
 
Congratulations! You have successfully deployed a three-tier architecture on AWS using Terraform. This architecture provides a scalable and highly available infrastructure for your applications. Make sure to follow AWS best practices and security recommendations when deploying your production workloads.

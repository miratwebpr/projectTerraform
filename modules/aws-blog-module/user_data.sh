#!/bin/bash

# Update package lists
apt-get update -y

# Install Python 3, pip, and MySQL development libraries
apt-get install python3 python3-pip libmysqlclient-dev -y
apt-get install python3 python3-pip -y

# Optional: Install virtualenv for Python
pip3 install virtualenv


# Clone your Django project repository
# Replace with your repository URL and access method
git clone https://github.com/miratwebpr/blogproject.git
cp -R blogproject/Blog-Project-main/. blogproject
rm -R blogproject/Blog-Project-main/
chmod -R 770 blogproject
# Change to the directory of your Django project
cd blogproject/src

# dbname="${db_name}"
# dbuser="${db_user}"
# dbpassword="${db_password}"
# dbendpoint="${db_endpoint}"
# bucketname="${bucket_name}"

sed -i "s/blogdb/${db_name}/g" ./cblog/settings.py

sed -i "s/mirat/${db_user}/g" ./cblog/settings.py 

sed -i "s/PASSWORDPLACEHOLDER/${db_password}/g" ./cblog/settings.py 

sed -i "s/blog-db1.c6j8ch9tppeu.us-east-1.rds.amazonaws.com/${db_endpoint}/g" ./cblog/settings.py 

sed -i "s/blogproject112/${bucket_name}/g" ./cblog/settings.py 


# Optional: Create and activate a virtual environment
virtualenv venv
source venv/bin/activate

# Install required Python packages from requirements.txt
# command to install packages in requirements.txt

pip3 install -r ../requirements.txt
pip install python-decouple
pip install Django

# Run Django management commands
python3 manage.py collectstatic --noinput
python3 manage.py makemigrations
python3 manage.py migrate
python3 manage.py runserver 0.0.0.0:80

#!/bin/bash

# Update package lists
apt-get update -y

# Install Python 3, pip, and MySQL development libraries
apt-get install python3 python3-pip libmysqlclient-dev -y
apt-get install python3 python3-pip -y

# Optional: Install virtualenv for Python
pip3 install virtualenv

wait_for_rds() {
    while true; do
        DB_ENDPOINT=$(terraform output rds_cluster_endpoint)
        if [ -n "$DB_ENDPOINT" ]; then
            echo "RDS cluster is ready."
            break
        else
            echo "Waiting for RDS cluster to be ready..."
            sleep 60  # Increase the sleep duration to 60 seconds
        fi
    done
}

# Wait for RDS cluster
wait_for_rds

# Clone your Django project repository
# Replace with your repository URL and access method
git clone https://github.com/miratwebpr/blogproject.git
cp -R blogproject/Blog-Project-main/. blogproject
rm -R blogproject/Blog-Project-main/
chmod -R 770 blogproject
# Change to the directory of your Django project
cd blogproject/src

sed -i "s/projectdb/${db_name}/" ./cblog/settings.py

sed -i "s/admin/${db_user}/" ./cblog/settings.py

sed -i "s/admin123/${db_password}/" ./cblog/settings.py

DB_ENDPOINT=$(terraform output rds_cluster_endpoint)

sed -i "s/'HOST': .*,/'HOST': '${DB_ENDPOINT}',/" ./cblog/settings.py

sed -i "s/newdanas3/${bucket_name}/" ./cblog/settings.py

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

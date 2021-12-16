# DevOps Academy Capstone

The goal of this project is to demonstrate your knowledge of DevOps practices by deploying a full application to AWS.
You will need to create a group of EC2 instances that will run the applications backend services, a RDS postgres instance for the application to store data, and deploy a frontend static site to an s3 bucket.


## Structure

The application consists of a Node frontend and a Go backend in separate directories.

There is also an infrastructure directory containing terraform code for setting up AWS resources to host the application.

Each directory contains a Makefile consisting of common commands for building, linting, running, testing,  etc...


## GitHub Actions Deployment Steps

### Frontend

#### Upload files to S3

```shell
aws s3 cp public s3://${{ secrets.S3_BUCKET_NAME }}/ --recursive --acl public-read
```

### Backend

#### Configure SSH

```shell
printf ${{ secrets.BASE64_SSH_PRIVATE_KEY }} | base64 -d > private_key && \
chmod 0600 private_key
```

#### Configure deploy .env

```shell
envsubst < .env.template > dist/todo.env
```

This step must be run with the following environment variables:

```shell
APP_BIND_ADDRESS: 0.0.0.0:8080
POSTGRES_ADDRESS: ${{ secrets.POSTGRES_ADDRESS }}
POSTGRES_USERNAME: ${{ secrets.POSTGRES_APP_USERNAME }}
POSTGRES_PASSWORD: ${{ secrets.POSTGRES_APP_PASSWORD }}
POSTGRES_DB: ${{ secrets.POSTGRES_DATABASE }}
```

#### Deploy to EC2

```shell
for i in ${{ secrets.EC2_INSTANCE_IPS }}; do
  echo "Starting deploy to $i...";
  echo "  Stopping service if running...";
  ssh -i ./private_key -o StrictHostKeyChecking=no ${{ secrets.EC2_INSTANCE_USER }}@$i 'sudo systemctl is-active --quiet todo && sudo systemctl stop todo || exit 0';
  echo "  Copying files to instance...";
  scp -ri ./private_key dist ${{ secrets.EC2_INSTANCE_USER }}@$i:~/todo;
  echo "  Moving files into place on instance...";
  ssh -i ./private_key ${{ secrets.EC2_INSTANCE_USER }}@$i '
    sudo rm -rf /opt/todo &&
    sudo mv ~/todo /opt/todo &&
    sudo ln -sfn /opt/todo/todo /usr/local/bin/todo &&
    sudo ln -sfn /opt/todo/todo.service /etc/systemd/system/todo.service &&
    sudo systemctl daemon-reload';
done
```

#### Start service
```shell
for i in ${{ secrets.EC2_INSTANCE_IPS }}; do
  echo "Starting service on $i...";
  ssh -i ./private_key ${{ secrets.EC2_INSTANCE_USER }}@$i 'sudo systemctl is-enabled --quiet todo || sudo systemctl enable todo';
  ssh -i ./private_key ${{ secrets.EC2_INSTANCE_USER }}@$i 'sudo systemctl start todo';
  ssh -i ./private_key ${{ secrets.EC2_INSTANCE_USER }}@$i 'sudo systemctl is-active --quiet todo';
done
```

## React Native Notes App Deployment

This repository automates the deployment of a React Native Notes app to an AWS EC2 instance using CI/CD pipelines, Terraform for infrastructure provisioning, and GitOps workflows.

### Project Structure:
```
.
├── .github/workflows/ci-cd.yml     # GitHub Actions pipeline configuration
├── Dockerfile                      # Dockerfile to containerize the app
├── terraform
│   ├── main.tf                     # Terraform configuration for AWS infrastructure
│   ├── variables.tf                # Terraform variables (excluded from version control)
│   ├── terraform.tfvars            # Terraform variable values (excluded from version control)
├── README.md                       # Project documentation
```

### Prerequisites

- **AWS Account:** Ensure you have an active AWS subscription.
- **GitHub Account:** Fork the repository to your GitHub account.
- **AWS CLI:** Installed and authenticated. [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- **Terraform:** Installed on your local machine. [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- **Node.js and npm:** Ensure you have Node.js (16.x) and npm installed.
- **SSH Keys:** Generate an SSH key pair for secure access to the AWS EC2 instance.

### CI/CD Pipeline Setup

1. **Create a GitHub Actions Workflow:**
   - Add a `.github/workflows/main.yml` file with the pipeline configuration as follows:

```yaml
name: CI/CD Pipeline

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-22.04
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install dependencies
        run: npm install

      - name: Run tests
        run: npm test

      - name: Build application
        run: npm run build

  deploy:
    needs: build
    runs-on: ubuntu-22.04
    steps:
      - name: SSH Deploy
        uses: appleboy/ssh-action@v0.1.9
        with:
          host: ${{ secrets.EC2_HOST }}
          username: ${{ secrets.EC2_USER }}
          key: ${{ secrets.EC2_PRIVATE_KEY }}
          script: |
            cd /home/ubuntu/react-native-notes-app/
            git pull origin main
            npm install
            npm run build
            pm2 restart app
```

2. **Configure AWS Credentials:**
   - Add your AWS credentials as GitHub Secrets (`AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`).
   - Add other necessary secrets: `EC2_HOST`, `EC2_USER`, `EC2_PRIVATE_KEY`.

### Provision AWS EC2 Instance

1. **Use Terraform:**
   - Create a `main.tf` file with the EC2 instance configuration as follows:

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "app" {
  ami           = "ami-0c55b159cbfafe1f0" # Replace with a valid Ubuntu AMI ID for your region
  instance_type = "t2.micro"

  tags = {
    Name = "ReactNativeNotesApp"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nodejs npm",
      "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash",
      ". ~/.nvm/nvm.sh",
      "nvm install 18",
      "nvm use 18",
      "npm install -g pm2"
    ]
  }
}

output "instance_ip" {
  value = aws_instance.app.public_ip
}
```

2. **Create Variables File:**
   - Create a `variables.tf` file in the `terraform` directory with the following content:

```hcl
variable "private_key_path" {
  description = "Path to the private key for SSH access"
  type        = string
  default     = "~/.ssh/id_rsa"
}
```

3. **Terraform Commands:**
   - Run `terraform init`, `terraform plan`, and `terraform apply` to provision the instance.

### Deployment

1. **Deploy to EC2:**
   - The pipeline will automatically deploy the app to the EC2 instance upon a successful build.

### Prerequisites

- Ensure you have AWS credentials with the necessary permissions.
- Install Terraform if using it for infrastructure provisioning.

### Dockerfile

```dockerfile
# Use an official Node.js runtime as a parent image
FROM node:16

# Set the working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json .
RUN npm install

# Copy the rest of the application files
COPY . .

# Expose the application port
EXPOSE 3000

# Start the app
CMD ["npm", "start"]
```

By following these instructions, you can deploy your React Native Notes App to an AWS EC2 instance using GitHub Actions and Terraform. Let me know if you have any further questions or need additional assistance! 😊

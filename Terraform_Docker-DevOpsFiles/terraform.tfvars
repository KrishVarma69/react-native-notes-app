# AWS Authentication
region = "us-west-2"
instance_type = "t2.micro"
ami = "ami-0c55b159cbfafe1f0"  # Replace with a valid Ubuntu AMI ID for your region
key_name = "<your-key-pair-name>"
private_key_path = "~/.ssh/id_rsa"  # Path to your SSH private key for EC2 instance access

# Summary of Changes:
# Region: Specify the AWS region where the EC2 instance will be created.
# Instance Type: Define the type of EC2 instance to be created (e.g., t2.micro).
# AMI: Provide the Amazon Machine Image (AMI) ID for the instance.
# Key Name: Specify the name of the key pair to be used for SSH access to the instance.
# Private Key Path: Define the path to your SSH private key for accessing the EC2 instance.

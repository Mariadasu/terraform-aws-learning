# Terraform AWS Learning

Hands-on Terraform exercises for AWS. The project keeps small examples in separate root configurations so each can be initialized, planned, applied, and cleaned up independently.

## Project layout

```text
.
├── main.tf                 # AWS caller-identity check
├── .terraform.lock.hcl     # Provider selections for the root configuration
└── 01-ec2/
    ├── main.tf             # Amazon Linux EC2 lab and network rules
    ├── variables.tf        # Local SSH CIDR and EC2 key-pair inputs
    ├── terraform.tfvars.example
    └── .terraform.lock.hcl # Provider selections for this root configuration
```

Terraform treats each directory as a separate root module. Run commands from the directory you want to operate on.

## EC2 lab

The `01-ec2` configuration provisions:

- An Amazon Linux 2023 x86-64 `t3.micro` instance in `us-east-1`
- A security group that allows SSH on TCP 22 only from one configured IPv4 address
- Outbound HTTP and HTTPS on TCP 80 and 443
- IMDSv2 token enforcement
- Outputs for the instance ID and public IPv4 address

The configuration looks up an existing default VPC, the latest Amazon Linux 2023 AMI through AWS Systems Manager Parameter Store, and an existing EC2 key pair. It does not create a VPC or key pair.

## Prerequisites

- Terraform CLI
- AWS CLI configured with the `terraform-lab` profile
- An EC2 key pair available in `us-east-1`, with its matching private key on your Mac
- A default VPC in `us-east-1`

Sign in to AWS and create your local inputs:

```bash
aws sso login --profile terraform-lab
cd 01-ec2
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:

- Set `ssh_allowed_cidr` to your current public IPv4 address followed by `/32`. You can check the address with `curl -4 https://checkip.amazonaws.com`.
- Set `ec2_key_pair_name` to the EC2 key-pair name shown in AWS. This is the AWS key-pair name, not necessarily the local private-key filename.

The local `terraform.tfvars` file is ignored by Git. Do not commit it or any private key.

## Initialize, review, and create

From `01-ec2`:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

Review the plan before approving `apply`. To connect from your Mac, retrieve the public IP and use the private key associated with the configured EC2 key pair:

```bash
terraform output -raw public_ip
ssh -i ~/.ssh/YOUR_PRIVATE_KEY.pem ec2-user@YOUR_INSTANCE_PUBLIC_IP
```

## State and costs

This lab uses Terraform's default local backend. Its state file is stored locally in `01-ec2/terraform.tfstate` and is excluded from Git. Do not commit state files; they can contain sensitive infrastructure details. A remote backend is not configured yet.

EC2 compute, the root EBS volume, and public IPv4 usage may incur charges. Check your account's current Free Tier or credits and destroy the lab when you are finished:

```bash
terraform destroy
```

Review the destroy plan before confirming. The Terraform configuration and lock files remain in Git so the lab can be recreated later.

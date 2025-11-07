# Security Hardening for Cloud Infrastructure

Automated security hardening scripts and Terraform modules implementing CIS benchmarks and security best practices for AWS, GCP, and Azure.

## Features

- **CloudTrail**: Comprehensive audit logging
- **GuardDuty**: Threat detection
- **Security Hub**: Centralized security findings
- **AWS Config**: Configuration compliance monitoring
- **IAM Hardening**: Password policies and access controls

## Tools

- **AWS**: CloudTrail, GuardDuty, Security Hub, Config
- **GCP**: Cloud Asset Inventory, Security Command Center
- **Azure**: Security Center, Azure Policy

## Usage

### AWS Hardening Script

```bash
chmod +x scripts/harden-aws.sh
./scripts/harden-aws.sh
```

### Terraform

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## Security Controls

- Enable audit logging (CloudTrail)
- Enable threat detection (GuardDuty)
- Configure password policies
- Enable security monitoring (Security Hub)
- Enable configuration compliance (Config)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License

## Author

**Dmytro Bazeliuk**
- Portfolio: https://devsecops.cv
- GitHub: [@dmytrobazeliuk-devops](https://github.com/dmytrobazeliuk-devops)

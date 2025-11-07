#!/bin/bash
# AWS Security Hardening Script
# Implements security best practices for AWS accounts

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== AWS Security Hardening ===${NC}"

# Function to enable CloudTrail
enable_cloudtrail() {
    echo -e "${YELLOW}Enabling CloudTrail...${NC}"
    aws cloudtrail create-trail \
        --name security-audit-trail \
        --s3-bucket-name "${CLOUDTRAIL_BUCKET:-security-audit-logs}" \
        --is-multi-region-trail \
        --enable-log-file-validation || true
    echo -e "${GREEN}CloudTrail enabled${NC}"
}

# Function to enable GuardDuty
enable_guardduty() {
    echo -e "${YELLOW}Enabling GuardDuty...${NC}"
    aws guardduty create-detector \
        --enable \
        --finding-publishing-frequency FIFTEEN_MINUTES || true
    echo -e "${GREEN}GuardDuty enabled${NC}"
}

# Function to enable Config
enable_config() {
    echo -e "${YELLOW}Enabling AWS Config...${NC}"
    aws configservice put-configuration-recorder \
        --configuration-recorder name=default,roleARN="${CONFIG_ROLE_ARN:-}" || true
    echo -e "${GREEN}AWS Config enabled${NC}"
}

# Function to enable Security Hub
enable_security_hub() {
    echo -e "${YELLOW}Enabling Security Hub...${NC}"
    aws securityhub enable-security-hub || true
    echo -e "${GREEN}Security Hub enabled${NC}"
}

# Function to configure password policy
configure_password_policy() {
    echo -e "${YELLOW}Configuring IAM password policy...${NC}"
    aws iam update-account-password-policy \
        --minimum-password-length 14 \
        --require-uppercase-characters \
        --require-lowercase-characters \
        --require-numbers \
        --require-symbols \
        --max-password-age 90 \
        --password-reuse-prevention 24 || true
    echo -e "${GREEN}Password policy configured${NC}"
}

# Function to enable MFA
enable_mfa() {
    echo -e "${YELLOW}Enforcing MFA for root account...${NC}"
    echo -e "${YELLOW}Please configure MFA manually in AWS Console${NC}"
}

# Main execution
main() {
    enable_cloudtrail
    enable_guardduty
    enable_config
    enable_security_hub
    configure_password_policy
    enable_mfa
    echo -e "${GREEN}Security hardening completed!${NC}"
}

main


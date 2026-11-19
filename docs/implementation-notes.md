# Implementation and engineering decisions

## Security boundaries
- Public subnet: internet-facing Application Load Balancer only.
- Private application subnet: ECS Fargate tasks without public IP addresses.
- Isolated database subnet: RDS PostgreSQL with no default internet route.
- Security-group references restrict ALB → ECS → RDS traffic.
- RDS storage, CloudWatch log groups, SNS and managed DB credentials use a customer-managed KMS key where supported. ALB access logs use SSE-S3 because ALB log delivery does not support SSE-KMS.
- ECS execution role is separate from the application task role. The task role starts with no application permissions.
- The RDS master credential is managed by RDS/Secrets Manager and is not injected into the demo application. Create a dedicated application DB principal before enabling DB connectivity.

## Availability and cost trade-offs
The defaults are intentionally sized for a disposable development assessment: one NAT gateway, one ECS task, a small single-AZ PostgreSQL instance, 7-day backups and 30-day CloudWatch retention. These are not production availability settings. For production, use multi-AZ database deployment, NAT per AZ or VPC endpoints, at least two ECS tasks, deletion protection, a validated ACM certificate, remote Terraform state with locking, and tested backup/restore procedures. WAF and NAT gateways can incur ongoing charges.

## Deployment safety
1. Confirm `aws sts get-caller-identity --profile kpmg-devsecops` and region.
2. Run format, init, validate and static security checks.
3. Generate a saved plan and review every create/change/destroy action.
4. Apply only after cost and security review.
5. Capture evidence and destroy lab resources after the assessment.

## Known deliberate limitations
- The default Nginx unprivileged image is a connectivity/demo workload, not a business application. Replace it with a pinned application image before claiming application-to-database integration.
- HTTP-only mode is available only when no ACM certificate ARN is supplied and is for development demonstrations. Do not describe it as HTTPS-secured.
- IAM database authentication does not create a PostgreSQL database user. A matching DB principal and grants must be provisioned separately.
- Terraform state and saved plans can contain sensitive infrastructure metadata. Never commit `.tfstate`, `.tfplan`, credentials or secret files.

## Security scanning and accepted findings

The Terraform configuration is reviewed using Checkov.

The following development choices may produce policy findings:

- Single-AZ RDS and disabled enhanced monitoring are cost-conscious assessment defaults.
- Thirty-day CloudWatch log retention is intended for a temporary development environment.
- HTTP access is permitted only in development mode when no ACM certificate is configured.
- ALB access logs use SSE-S3 because SSE-KMS is not supported for this log delivery configuration.
- The KMS account-root statement preserves account-level key administration and IAM policy delegation.
- Internal ALB-to-ECS traffic uses HTTP because TLS terminates at the ALB.

These findings are reviewed against the intended architecture rather than blindly suppressed. Production deployments must meet the organisation's security, availability and compliance requirements.

Trivy and Gitleaks will be used in the CI pipeline for vulnerability and secret scanning.
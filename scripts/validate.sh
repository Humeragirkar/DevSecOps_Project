#!/usr/bin/env bash
set -euo pipefail

terraform fmt -recursive
terraform init -backend=false
terraform validate

if command -v tflint >/dev/null 2>&1; then
  tflint --init
  tflint --recursive
else
  echo "tflint not installed; skipping lint step"
fi

if command -v checkov >/dev/null 2>&1; then
  checkov -d . --framework terraform
else
  echo "checkov not installed; skipping IaC policy scan"
fi

if command -v trivy >/dev/null 2>&1; then
  trivy config .
else
  echo "trivy not installed; skipping config scan"
fi

# Azure Terraform Infrastructure - Task 03

This Terraform configuration creates Azure infrastructure including a Resource Group, Storage Account, Virtual Network, and two Subnets.

## Resources Created

- **Resource Group**: `cmaz-31zawnrd-mod3-rg`
- **Storage Account**: `cmaz31zawnrdsa`
- **Virtual Network**: `cmaz-31zawnrd-mod3-vnet`
- **Subnets**:
  - `frontend` (10.0.1.0/24)
  - `backend` (10.0.2.0/24)

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure subscription

## Usage

1. **Login to Azure**:
   ```bash
   az login
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Validate configuration**:
   ```bash
   terraform validate
   ```

4. **Plan deployment**:
   ```bash
   terraform plan
   ```

5. **Apply configuration**:
   ```bash
   terraform apply
   ```

6. **View outputs**:
   ```bash
   terraform output
   ```

7. **Destroy resources** (when needed):
   ```bash
   terraform destroy
   ```

## Outputs

- `rg_id`: Resource Group ID
- `sa_blob_endpoint`: Storage Account Blob Service Primary Endpoint
- `vnet_id`: Virtual Network ID

## Tags

All resources are tagged with:
- Creator: behroz_ilhomov@epam.com

## Directory Structure

```
task03/
├── main.tf           # Main resource definitions
├── outputs.tf        # Output values  
├── terraform.tfvars  # Variable values
├── variables.tf      # Variable definitions
└── versions.tf       # Terraform and provider versions
```

## Author

Created by: behroz_ilhomov@epam.com

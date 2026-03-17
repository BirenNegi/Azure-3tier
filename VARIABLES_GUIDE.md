# Variable-Based Terraform Configuration Guide

## Overview
This Terraform project is now **100% variable-based** with no hardcoded values. All configuration parameters can be customized through variables.

---

## Quick Start

### 1. Copy the Example Variables File
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

### 2. Edit terraform.tfvars
Customize values for your environment:
```hcl
resource_group_name = "rg-my-custom-env"
location            = "East US"
web_vm_name         = "my-web-server"
# ... edit other values as needed
```

### 3. Sensitive Variables (Passwords)
**DO NOT** put passwords in terraform.tfvars file. Instead, set them via environment variables:

```bash
# Option 1: Export as environment variables
export TF_VAR_admin_password="YourSecurePassword123!"
export TF_VAR_sql_admin_password="YourSecurePassword123!"

# Option 2: Use terraform apply with -var flag
terraform apply -var="admin_password=YourSecurePassword123!"

# Option 3: Use .auto.tfvars (create with restricted permissions)
cat > secrets.auto.tfvars << EOF
admin_password = "YourPassword123!"
sql_admin_password = "YourPassword123!"
EOF
chmod 600 secrets.auto.tfvars
# Add to .gitignore: secrets.auto.tfvars
```

### 4. Plan and Apply
```bash
terraform plan
terraform apply
```

---

## Variable Categories

### Resource Group & Location
```hcl
resource_group_name = "rg-3tier-demo"
location            = "Central India"
environment         = "demo"
```

### Networking Variables
```hcl
# Virtual Network
vnet_name          = "3tier-vnet"
vnet_address_space = ["10.0.0.0/16"]

# Subnets
web_subnet_name  = "web-subnet"
web_subnet_prefix = ["10.0.1.0/24"]

app_subnet_name  = "app-subnet"
app_subnet_prefix = ["10.0.2.0/24"]

db_subnet_name  = "db-subnet"
db_subnet_prefix = ["10.0.3.0/24"]
```

### Security & Network Security Groups
```hcl
web_nsg_name      = "web-nsg"
app_port          = 5000           # Flask application port
rdp_port          = 3389           # Windows RDP port
app_priority      = 1001           # Security rule priority
rdp_priority      = 1002           # Security rule priority
allowed_source_ip = "*"            # ⚠️ Restrict for production
```

### Virtual Machine
```hcl
web_vm_name       = "webvm"
web_pip_name      = "web-pip"
web_nic_name      = "web-nic"
vm_size           = "Standard_D2as_v4"
os_disk_name      = "webvm-osdisk"
os_disk_caching   = "ReadWrite"
storage_account_type = "Standard_LRS"

# Admin credentials
admin_username    = "azureuser"
admin_password    = "Password1234!"  # Set via env var
```

### VM Image
```hcl
image_publisher = "MicrosoftWindowsServer"
image_offer     = "WindowsServer"
image_sku       = "2019-Datacenter"  # 2016, 2019, or 2022
image_version   = "latest"
```

### SQL Server
```hcl
sql_server_name   = "3tier-sqlserver"
sql_admin_login   = "sqladmin"
sql_admin_password = "Password1234!"  # Set via env var
sql_version       = "12.0"
```

### Common Tags
```hcl
common_tags = {
  Environment = "demo"
  CreatedBy   = "Terraform"
  Project     = "3Tier-App"
}
```

---

## Usage Examples

### Example 1: Development Environment
```bash
# Create dev-specific terraform.tfvars
cat > terraform.tfvars << EOF
resource_group_name = "rg-dev"
location            = "East US"
environment         = "development"
web_vm_name         = "dev-webvm"
vm_size             = "Standard_B2s"
common_tags = {
  Environment = "development"
  CostCenter  = "R&D"
}
EOF

export TF_VAR_admin_password="DevPassword123!"
export TF_VAR_sql_admin_password="DevPassword123!"

terraform plan -out=dev.tfplan
terraform apply dev.tfplan
```

### Example 2: Production Environment
```bash
# Create production terraform.tfvars
cat > terraform.tfvars << EOF
resource_group_name = "rg-prod"
location            = "East US 2"
environment         = "production"
web_vm_name         = "prod-webvm-01"
vm_size             = "Standard_D4s_v3"
storage_account_type = "Premium_LRS"
allowed_source_ip   = "203.0.113.0/24"
common_tags = {
  Environment  = "production"
  CostCenter   = "Operations"
  Owner        = "DevOps-Team"
  Compliance   = "SOC2"
}
EOF

# Load from secure secrets manager or use env vars
export TF_VAR_admin_password=$(aws secretsmanager get-secret-value --secret-id prod-vm-password)
terraform apply
```

### Example 3: Multiple Environments
```bash
# Use workspace feature
terraform workspace new prod
terraform workspace new dev

# Create separate tfvars files
terraform.tfvars.dev
terraform.tfvars.prod

# Apply to specific workspace
terraform workspace select prod
terraform apply -var-file="terraform.tfvars.prod"
```

---

## Validating Variable Values

### Check Current Variables
```bash
# Display all variable values
terraform console
> var.web_vm_name
> var.vnet_address_space

# Exit with Ctrl+C
```

### Preview Changes
```bash
terraform plan -out=tfplan
terraform show tfplan
```

---

## AI/ML Integration for Variable Optimization

If you want to auto-optimize variables based on performance, you can integrate with Azure Advisor or use a script:

```hcl
# Example: Auto-size VM based on past usage
variable "enable_autoscaling" {
  type    = bool
  default = false
}

variable "auto_sizing_parameters" {
  type = object({
    cpu_threshold    = number
    memory_threshold = number
  })
  default = {
    cpu_threshold    = 80
    memory_threshold = 85
  }
}
```

---

## Security Best Practices

1. **Never commit passwords to version control**
   ```bash
   echo 'terraform.tfvars' >> .gitignore
   echo '*.auto.tfvars' >> .gitignore
   echo 'secrets.tfvars' >> .gitignore
   ```

2. **Use Azure Key Vault for secrets**
   ```hcl
   data "azurerm_key_vault" "kv" {
     name                = "my-keyvault"
     resource_group_name = azurerm_resource_group.rg.name
   }
   
   data "azurerm_key_vault_secret" "vm_password" {
     name         = "vm-password"
     key_vault_id = data.azurerm_key_vault.kv.id
   }
   ```

3. **Restrict IP access for RDP**
   ```hcl
   allowed_source_ip = "203.0.113.50/32"  # Your office IP
   ```

4. **Use strong passwords**
   - At least 12 characters
   - Mix of uppercase, lowercase, numbers, special characters
   - Example: `P@ssw0rd#2024Secure`

---

## Troubleshooting

### Error: Variable not set
```bash
# Check which variables are missing
terraform validate

# Set missing variables
export TF_VAR_admin_password="Password123!"
```

### Error: Invalid variable value
```bash
# View variable constraints
grep -A5 "variable \"vm_size\"" terraform/variables.tf

# Use valid value
vm_size = "Standard_B2s"  # Valid option
```

### Preview what will change
```bash
terraform plan -var-file="terraform.tfvars"
```

---

## Common Variable Patterns

### Switch between environments
```bash
# Use -var-file for environment-specific configs
terraform apply -var-file="dev.tfvars"
terraform apply -var-file="prod.tfvars"
terraform apply -var-file="staging.tfvars"
```

### Override single variable
```bash
terraform apply \
  -var-file="terraform.tfvars" \
  -var="vm_size=Standard_D4s_v3"
```

### Use environment variables
```bash
# Set TF_VAR_* environment variables
export TF_VAR_location="West Europe"
export TF_VAR_web_vm_name="new-webvm"
terraform apply
```

---

## Next Steps

1. ✅ Copy `terraform.tfvars.example` to `terraform.tfvars`
2. ✅ Customize variables for your environment
3. ✅ Set sensitive variables via environment variables
4. ✅ Run `terraform plan` to preview changes
5. ✅ Run `terraform apply` to deploy
6. ✅ Check `terraform output` to see deployed resources

---

## References

- [Terraform Variables Documentation](https://www.terraform.io/docs/language/values/variables)
- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Best Practices](https://cloud.hashicorp.com/products/terraform)

# Quick Reference - Variable-Based Terraform Deployment

## 🚀 5-Minute Quick Start

```bash
# 1. Go to terraform directory
cd terraform

# 2. Copy example config
cp terraform.tfvars.example terraform.tfvars

# 3. Edit for your environment
# Edit terraform.tfvars and change:
#   - resource_group_name
#   - location
#   - web_vm_name
#   - other values as needed

# 4. Set passwords (use environment variables!)
$env:TF_VAR_admin_password = "YourPassword123!@#"
$env:TF_VAR_sql_admin_password = "YourPassword123!@#"

# 5. Deploy
terraform plan
terraform apply
```

---

## 📋 Key Variables at a Glance

### Infrastructure
```hcl
resource_group_name = "rg-3tier-demo"
location            = "Central India"  # Change to your region
environment         = "demo"
```

### Networking (CIDR blocks)
```hcl
vnet_address_space = ["10.0.0.0/16"]
web_subnet_prefix  = ["10.0.1.0/24"]
app_subnet_prefix  = ["10.0.2.0/24"]
db_subnet_prefix   = ["10.0.3.0/24"]
```

### Virtual Machine
```hcl
web_vm_name    = "webvm"
vm_size        = "Standard_D2as_v4"
admin_username = "azureuser"
# admin_password = set via env var!

image_sku      = "2019-Datacenter"  # or 2016, 2022
```

### Security
```hcl
app_port         = 5000
rdp_port         = 3389
allowed_source_ip = "*"  # Restrict in production!
```

### Database
```hcl
sql_server_name   = "3tier-sqlserver"
sql_admin_login   = "sqladmin"
# sql_admin_password = set via env var!
```

---

## 🔐 Set Passwords (IMPORTANT!)

### Option 1: Environment Variables (Recommended)
```powershell
# PowerShell
$env:TF_VAR_admin_password = "ComplexPassword123!@#"
$env:TF_VAR_sql_admin_password = "ComplexPassword123!@#"

# Bash
export TF_VAR_admin_password="ComplexPassword123!@#"
export TF_VAR_sql_admin_password="ComplexPassword123!@#"
```

### Option 2: Command Line
```bash
terraform apply \
  -var="admin_password=ComplexPassword123!@#" \
  -var="sql_admin_password=ComplexPassword123!@#"
```

### Option 3: Secrets File (Less Secure)
```bash
# Create secrets.auto.tfvars
cat > secrets.auto.tfvars << EOF
admin_password = "ComplexPassword123!@#"
sql_admin_password = "ComplexPassword123!@#"
EOF

chmod 600 secrets.auto.tfvars
# Add to .gitignore (already done)
```

---

## 🔧 Common Changes

### Change VM Size
Edit `terraform.tfvars`:
```hcl
vm_size = "Standard_B2s"      # Small
vm_size = "Standard_D2as_v4"  # Medium (default)
vm_size = "Standard_D4s_v3"   # Large
vm_size = "Standard_D8s_v3"   # XLarge
```

### Change Region
Edit `terraform.tfvars`:
```hcl
location = "East US"           # or East US 2, West US, etc.
```

### Restrict RDP Access
Edit `terraform.tfvars`:
```hcl
allowed_source_ip = "203.0.113.50/32"  # Your IP only
```

### Use Different OS
Edit `terraform.tfvars`:
```hcl
image_sku = "2016-Datacenter"  # Windows 2016
# or
image_sku = "2022-Datacenter"  # Windows 2022
```

---

## 🧪 Terraform Commands Cheat Sheet

```bash
# Initialize (first time only)
terraform init

# Validate syntax
terraform validate

# See what will be created/changed/destroyed
terraform plan

# Save plan to file for review
terraform plan -out=tfplan
terraform show tfplan

# Apply changes
terraform apply

# Apply saved plan
terraform apply tfplan

# See current outputs
terraform output

# Destroy all resources
terraform destroy

# Destroy specific resource
terraform destroy -target=azurerm_windows_virtual_machine.web_vm

# View variable values
terraform console
# Then type: var.web_vm_name

# Format .tf files
terraform fmt

# Cleanup .terraform directory
rm -rf .terraform
terraform init
```

---

## 📊 View Deployment Results

```bash
# Show all outputs
terraform output

# Get specific output
terraform output web_vm_public_ip
terraform output sql_server_fqdn

# Full resource list
terraform state list

# Resource details
terraform state show azurerm_windows_virtual_machine.web_vm
```

---

## ⚠️ Common Issues & Fix

### Issue: "Variable not set"
```bash
# Solution: Set environment variable
export TF_VAR_admin_password="Password123!"
```

### Issue: "Validation failed"
```bash
# Check variable definitions
grep -A5 "variable \"vm_size\"" variables.tf
# Use a valid value from the list
```

### Issue: "Resource already exists"
```bash
# Solution: Use unique names
resource_group_name = "rg-unique-$(date +%s)"
# Or destroy old resources
terraform destroy
```

### Issue: Need to roll back
```bash
# Revert terraform.tfvars to previous state
git checkout terraform.tfvars

# Or destroy and redeploy
terraform destroy
terraform apply
```

---

## 🔍 File Locations

```
terraform/
├── variables.tf              ← Add/modify variables here
├── terraform.tfvars          ← Your custom configuration
├── terraform.tfvars.example  ← Reference/template
├── *.tf                      ← Resource definitions
├── outputs.tf                ← View after deployment
└── .gitignore               ← Protects secrets
```

---

## 📝 Example terraform.tfvars

```hcl
# Copy terraform.tfvars.example and customize:

resource_group_name = "my-company-prod"
location            = "East US"
web_vm_name         = "prod-web-01"
vm_size             = "Standard_D2as_v4"
allowed_source_ip   = "203.0.113.0/24"

common_tags = {
  Environment = "production"
  Owner       = "DevOps"
  CostCenter  = "Operations"
}

# Then set passwords via environment:
# export TF_VAR_admin_password="..."
```

---

## ✅ Deployment Checklist

- [ ] Copied `terraform.tfvars.example` to `terraform.tfvars`
- [ ] Edited network settings for your environment
- [ ] Changed resource names to your naming convention
- [ ] Set `allowed_source_ip` if more restrictive than "*"
- [ ] Set environment variables for passwords
- [ ] Ran `terraform validate` ✓
- [ ] Ran `terraform plan` ✓
- [ ] Reviewed plan output
- [ ] Ran `terraform apply` ✓
- [ ] Noted VM public IP from outputs
- [ ] Connected via RDP to verify

---

## 🎯 Variables by Use Case

### Development Environment
```hcl
resource_group_name = "rg-dev"
vm_size             = "Standard_B2s"  # Small/cheap
storage_account_type = "Standard_LRS"
allowed_source_ip   = "203.0.113.50/32"  # Your IP
```

### Staging Environment
```hcl
resource_group_name = "rg-staging"
vm_size             = "Standard_D2as_v4"
storage_account_type = "Standard_LRS"
allowed_source_ip   = "*"  # Internal access
```

### Production Environment
```hcl
resource_group_name = "rg-prod"
vm_size             = "Standard_D4s_v3"  # Better performance
storage_account_type = "Premium_LRS"     # Better reliability
allowed_source_ip   = "203.0.113.0/24"  # Restricted
```

---

## 🚨 Security Reminders

✅ **DO:**
- Set passwords via environment variables
- Use `allowed_source_ip` restricted to your network
- Run `terraform plan` before `terraform apply`
- Keep `terraform.tfvars` out of git
- Use strong passwords (12+ chars with special chars)

❌ **DON'T:**
- Put passwords in `terraform.tfvars`
- Use `allowed_source_ip = "*"` in production
- Share `.tfstate` files
- Commit secrets to version control
- Use weak/simple passwords

---

## 📞 Support Resources

- SETUP_INSTRUCTIONS.md - Full setup guide
- VARIABLES_GUIDE.md - Detailed variable reference
- CONVERSION_SUMMARY.md - What changed from original

---

**All values configurable. Zero hardcoding. Maximum flexibility. 🎉**

# Setup Instructions - Variable-Based Azure 3-Tier Deployment

## ✅ What Was Changed

Your Terraform project has been **fully converted to variable-based configuration**:

- ✅ All hardcoded values moved to `variables.tf`
- ✅ All resource files now reference variables instead of hardcoded values
- ✅ Created `terraform.tfvars.example` with all configurable options
- ✅ Created comprehensive `outputs.tf` to display deployment information
- ✅ Added `.gitignore` to prevent committing sensitive data
- ✅ Created `VARIABLES_GUIDE.md` with detailed documentation

---

## 🚀 Quick Start (3 Steps)

### Step 1: Copy Example Variables
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

### Step 2: Edit Configuration
Edit `terraform.tfvars` to customize your deployment:
```hcl
resource_group_name = "my-custom-rg"
location            = "East US"
web_vm_name         = "my-webvm"
# ... customize other values
```

### Step 3: Deploy
```bash
# Set password via environment variable
$env:TF_VAR_admin_password = "YourSecurePassword123!"
$env:TF_VAR_sql_admin_password = "YourSecurePassword123!"

# Plan and apply
terraform plan
terraform apply
```

---

## 📋 All Variables Reference

### Infrastructure Naming
| Variable | Default | Purpose |
|----------|---------|---------|
| `resource_group_name` | rg-3tier-demo | Azure Resource Group name |
| `location` | Central India | Azure region |
| `environment` | demo | Environment identifier |

### Networking
| Variable | Default | Purpose |
|----------|---------|---------|
| `vnet_name` | 3tier-vnet | Virtual Network name |
| `vnet_address_space` | ["10.0.0.0/16"] | VNet CIDR block |
| `web_subnet_name` | web-subnet | Web tier subnet |
| `web_subnet_prefix` | ["10.0.1.0/24"] | Web tier CIDR |
| `app_subnet_name` | app-subnet | App tier subnet |
| `app_subnet_prefix` | ["10.0.2.0/24"] | App tier CIDR |
| `db_subnet_name` | db-subnet | Database tier subnet |
| `db_subnet_prefix` | ["10.0.3.0/24"] | DB tier CIDR |

### Security
| Variable | Default | Purpose |
|----------|---------|---------|
| `web_nsg_name` | web-nsg | Network Security Group |
| `app_port` | 5000 | App server port |
| `rdp_port` | 3389 | RDP port |
| `allowed_source_ip` | * | IP CIDR for access ⚠️ |

### Virtual Machine
| Variable | Default | Purpose |
|----------|---------|---------|
| `web_vm_name` | webvm | VM name |
| `vm_size` | Standard_D2as_v4 | VM size/SKU |
| `admin_username` | azureuser | VM admin user |
| `admin_password` | (no default) | VM admin password ⚠️ |
| `image_sku` | 2019-Datacenter | Windows version |

### SQL Server
| Variable | Default | Purpose |
|----------|---------|---------|
| `sql_server_name` | 3tier-sqlserver | SQL Server name |
| `sql_admin_login` | sqladmin | SQL admin user |
| `sql_admin_password` | (no default) | SQL password ⚠️ |

---

## ⚠️ Important Security Notes

### 1. Passwords Must Be Set via Environment Variables
```powershell
# PowerShell
$env:TF_VAR_admin_password = "ComplexPassword123!@#"
$env:TF_VAR_sql_admin_password = "ComplexPassword123!@#"

# Bash
export TF_VAR_admin_password="ComplexPassword123!@#"
export TF_VAR_sql_admin_password="ComplexPassword123!@#"
```

### 2. Never Commit `terraform.tfvars` to Git
The `.gitignore` file includes:
```
terraform.tfvars
*.auto.tfvars
```

### 3. Restrict Access for Production
```hcl
# In terraform.tfvars
allowed_source_ip = "203.0.113.50/32"  # Your office IP, not "*"
```

### 4. Use Azure Key Vault for Enterprise
```bash
# Store secrets in Azure Key Vault
az keyvault secret set --vault-name my-kv --name admin-password --value "YourPassword"
```

---

## 📝 File Structure

```
Azure-3tier/
├── terraform/
│   ├── main.tf                    # Resource group (now variable-based)
│   ├── network.tf                 # All networking (now variable-based)
│   ├── compute.tf                 # VMs and NICs (now variable-based)
│   ├── database.tf                # SQL Server (now variable-based)
│   ├── provider.tf                # Azure provider config
│   ├── variables.tf               # ✅ NEW: All variable definitions
│   ├── outputs.tf                 # ✅ NEW: Comprehensive outputs
│   ├── terraform.tfvars.example   # ✅ NEW: Example configuration
│   ├── .gitignore                 # ✅ NEW: Prevent committing secrets
│   ├── .terraform.lock.hcl        # Dependency lock file
│   └── terraform.tfstate*         # State files (in .gitignore)
├── scripts/
│   ├── app-setup.ps1              # Windows setup script
│   └── web-setup.ps1              # Web server setup
├── app/
│   ├── backend.py                 # Flask application
│   └── requirements.txt
├── VARIABLES_GUIDE.md             # ✅ NEW: Detailed variable guide
├── README.md
├── terraform-deploy.yml           # Ansible playbook
└── .gitignore
```

---

## 🔧 Common Tasks

### Change VM Size
Edit `terraform.tfvars`:
```hcl
vm_size = "Standard_D4s_v3"  # Larger VM
```

Available sizes:
- `Standard_B2s` - Small (dev/test)
- `Standard_D2as_v4` - Medium (default)
- `Standard_D4s_v3` - Large
- `Standard_D8s_v3` - XLarge

### Change Azure Region
Edit `terraform.tfvars`:
```hcl
location = "East US 2"
```

Popular regions:
- `East US`
- `West US`
- `Central India`
- `West Europe`
- `Southeast Asia`

### Change Network CIDR
Edit `terraform.tfvars`:
```hcl
vnet_address_space = ["192.168.0.0/16"]
web_subnet_prefix  = ["192.168.1.0/24"]
app_subnet_prefix  = ["192.168.2.0/24"]
db_subnet_prefix   = ["192.168.3.0/24"]
```

### Restrict RDP Access
Edit `terraform.tfvars`:
```hcl
allowed_source_ip = "203.0.113.50/32"  # Your IP only
```

### Add Custom Tags
Edit `terraform.tfvars`:
```hcl
common_tags = {
  Environment  = "demo"
  CreatedBy    = "Terraform"
  Project      = "3Tier-App"
  Owner        = "DevOps-Team"
  CostCenter   = "Engineering"
  ManagedBy    = "IaC"
  Compliance   = "SOC2"
}
```

---

## 🧪 Testing Your Configuration

### Validate Terraform Files
```bash
terraform validate
```

### Check What Will Be Deployed
```bash
terraform plan -out=tfplan
terraform show tfplan
```

### Review Variable Values
```bash
terraform plan | grep -i "provider"
```

---

## 📊 After Deployment

Check deployed resources:
```bash
terraform output
```

Example output:
```
web_vm_public_ip = "203.0.113.100"
web_vm_private_ip = "10.0.1.10"
sql_server_fqdn = "3tier-sqlserver.database.windows.net"
```

Connect to VM via RDP:
```bash
# Use the output from commands above
mstsc.exe /v:203.0.113.100:3389 /admin
```

---

## ❌ Troubleshooting

### Error: Variable not specified
```bash
# Ensure terraform.tfvars exists and is in correct directory
ls -la terraform/terraform.tfvars

# Check for typos in variable names
terraform validate
```

### Error: Password complexity requirement not met
Make sure your password includes:
- Minimum 12 characters
- At least 1 uppercase letter
- At least 1 lowercase letter
- At least 1 number
- At least 1 special character (!@#$%^&*)

Example: `MyP@ssw0rd!23`

### Error: Resource already exists
Either:
1. Use different names in `terraform.tfvars`
2. Destroy previous deployment: `terraform destroy`

---

## 🎯 Next Steps

1. ✅ **Review** the variables in `terraform.tfvars.example`
2. ✅ **Create** your custom `terraform.tfvars`
3. ✅ **Set** environment variables for passwords
4. ✅ **Validate** with `terraform plan`
5. ✅ **Deploy** with `terraform apply`
6. ✅ **Check** outputs with `terraform output`
7. ✅ **Connect** to VM and verify deployment
8. ✅ **Document** your configuration changes

---

## 📖 Additional Resources

- [Terraform Variables Guide](VARIABLES_GUIDE.md) - Detailed reference
- [Terraform Docs](https://www.terraform.io/docs/language/values/variables)
- [Azure Provider Docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure VM Sizing](https://docs.microsoft.com/en-us/azure/virtual-machines/sizes)

---

**All your infrastructure is now 100% variable-based - zero hardcoded values! 🎉**

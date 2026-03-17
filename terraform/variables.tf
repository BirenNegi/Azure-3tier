# ============================================================================
# RESOURCE GROUP VARIABLES
# ============================================================================
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-3tier-demo"
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "Central India"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "demo"
}

# ============================================================================
# NETWORK VARIABLES
# ============================================================================
variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "3tier-vnet"
}

variable "vnet_address_space" {
  description = "Address space for virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "web_subnet_name" {
  description = "Name of the web subnet"
  type        = string
  default     = "web-subnet"
}

variable "web_subnet_prefix" {
  description = "Address prefix for web subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "app_subnet_name" {
  description = "Name of the app subnet"
  type        = string
  default     = "app-subnet"
}

variable "app_subnet_prefix" {
  description = "Address prefix for app subnet"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "db_subnet_name" {
  description = "Name of the database subnet"
  type        = string
  default     = "db-subnet"
}

variable "db_subnet_prefix" {
  description = "Address prefix for database subnet"
  type        = list(string)
  default     = ["10.0.3.0/24"]
}

# ============================================================================
# NETWORK SECURITY GROUP VARIABLES
# ============================================================================
variable "web_nsg_name" {
  description = "Name of the web network security group"
  type        = string
  default     = "web-nsg"
}

variable "app_port" {
  description = "Application port for Flask/web app"
  type        = number
  default     = 5000
}

variable "rdp_port" {
  description = "RDP port for Windows VM"
  type        = number
  default     = 3389
}

variable "app_priority" {
  description = "Priority for app security rule"
  type        = number
  default     = 1001
}

variable "rdp_priority" {
  description = "Priority for RDP security rule"
  type        = number
  default     = 1002
}

variable "allowed_source_ip" {
  description = "Source IP allowed for security rules (use specific IP for security)"
  type        = string
  default     = "*"
}

# ============================================================================
# COMPUTE/VM VARIABLES
# ============================================================================
variable "web_vm_name" {
  description = "Name of the web virtual machine"
  type        = string
  default     = "webvm"
}

variable "web_pip_name" {
  description = "Name of the public IP"
  type        = string
  default     = "web-pip"
}

variable "web_nic_name" {
  description = "Name of the network interface"
  type        = string
  default     = "web-nic"
}

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_D2as_v4"
}

variable "admin_username" {
  description = "Administrator username for VM"
  type        = string
  default     = "azureuser"
  sensitive   = true
}

variable "admin_password" {
  description = "Administrator password for VM (must meet complexity requirements)"
  type        = string
  sensitive   = true
  # No default - should be provided via tfvars or environment variable
}

variable "os_disk_name" {
  description = "Name of the OS disk"
  type        = string
  default     = "webvm-osdisk"
}

variable "os_disk_caching" {
  description = "Caching type for OS disk"
  type        = string
  default     = "ReadWrite"
  
  validation {
    condition     = contains(["None", "ReadOnly", "ReadWrite"], var.os_disk_caching)
    error_message = "os_disk_caching must be None, ReadOnly, or ReadWrite."
  }
}

variable "storage_account_type" {
  description = "Storage account type for OS disk"
  type        = string
  default     = "Standard_LRS"
  
  validation {
    condition     = contains(["Standard_LRS", "Standard_GRS", "Standard_RAGRS", "Premium_LRS"], var.storage_account_type)
    error_message = "storage_account_type must be Standard_LRS, Standard_GRS, Standard_RAGRS, or Premium_LRS."
  }
}

variable "image_publisher" {
  description = "Publisher of the VM image"
  type        = string
  default     = "MicrosoftWindowsServer"
}

variable "image_offer" {
  description = "Offer of the VM image"
  type        = string
  default     = "WindowsServer"
}

variable "image_sku" {
  description = "SKU of the VM image"
  type        = string
  default     = "2019-Datacenter"
}

variable "image_version" {
  description = "Version of the VM image"
  type        = string
  default     = "latest"
}

variable "private_ip_allocation" {
  description = "Private IP allocation method"
  type        = string
  default     = "Dynamic"
}

variable "public_ip_allocation" {
  description = "Public IP allocation method"
  type        = string
  default     = "Static"
}

# ============================================================================
# DATABASE VARIABLES
# ============================================================================
variable "sql_server_name" {
  description = "Name of the SQL Server"
  type        = string
  default     = "3tier-sqlserver"
}

variable "sql_admin_login" {
  description = "Administrator login for SQL Server"
  type        = string
  default     = "sqladmin"
  sensitive   = true
}

variable "sql_admin_password" {
  description = "Administrator password for SQL Server (must meet complexity requirements)"
  type        = string
  sensitive   = true
  # No default - should be provided via tfvars or environment variable
}

variable "sql_version" {
  description = "SQL Server version"
  type        = string
  default     = "12.0"
}

# ============================================================================
# TAGS
# ============================================================================
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "demo"
    CreatedBy   = "Terraform"
    Project     = "3Tier-App"
  }
}

variable "proxmox_datacenter" {
    type = object({
        api_token           = string
        api_secret           = string
        api_url          = string
    })
}

variable "proxmox_node_details" {
    type = object({
        node_name           = string
        host_user           = string
        use_agent           = bool
    })
}

variable "cpu_details" {
    type = object({
      no_of_cores = number
      sockets = number
      type = string 
    })
    default = {
        no_of_cores = 1
        sockets = 1
        type = "host"
    }
}

variable "memory" {
    type = object({
      total_mem = number
    })
    default = {
        total_mem = 2048
    }
}

variable "disk_details" {
    type = object({
        interface = string
        datastore_id = string
        size = number
        iothread = bool
        file_format = string 
    })
    default = {
        interface = "scsi0"
        datastore_id = "local-lvm"
        size = 5
        iothread = true
        file_format = "raw"
    }

}

variable "network_details" {
    type = object({
      model = string
      bridge = string
      ipv4 = string
      gw = string 
    })
    default = {
        model = "virtio"
        bridge = "vmbr0"
        gw = "192.168.0.1"
        ipv4 = "192.168.0.100"
    }
}

variable "user_account_details" {
    type = object({
        username = string
        password = string
        file_path = optional(string, null)
    })
    default = {
      username = "ubuntu"
      password = "ubuntu"
    }
}

variable "public_key_path" {
    type = string
    default = null
    description = "Public key to be set on the new vm"
}

variable new_vm_details{
    type = object({
        vm_name = string
        vm_id = number
        #  cpu = var.cpu_details
        #   memory = var.memory
        #   disk = var.disk_details
        #   network = var.network_details
        #   user_acc = var.user_account_details
        enable_agent = bool
        scsi_hardware = string
    })
    default = {
        vm_name = "new-vm"
        vm_id = 5000
        enable_agent = true
        scsi_hardware = "virtio-scsi-pci"
    }
}

variable "pri_key_path" {
    type = string
    description = "Path of private key (where terraform runs) to ssh into"
    default = "~/.ssh/id_rsa"
}

variable "cloud_init" {
  type = object({
    type = string
    datastore_id = string
    url = string 
  })
  default = {
    datastore_id = "local"
    type = "iso"
    url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  }

}

# variable "proxmox_api_url"{
#     type = string
#     description = "Proxmox URL"
# }

# variable "proxmox_api_token"{
#     type = string
#     description = "The Proxmox api token"
# }

# variable "proxmox_api_secret"{
#     type = string
#     description = "The Proxmox api token"
# }

# variable "no_of_cores"{
#     description = "Total number of cores required"
#     type = number
#     default = 2
# }

# variable "vm_memory" {
#   description = "Amount of RAM (in MB)"
#   type        = number
#   default     = 2048
# }

# variable "vm_disk_size" {
#   description = "Size of the VM disk (in GB)"
#   type = number
#   default     = 5
# }

# variable "vm_name"{
#     type = string
#     description = "Name of the vm"
#     default = "testing2"
# }

# variable "proxmox_host" {
#     type = string
#     description = "Name of the node to insert the vm into"
# }

# variable "template_name" {
#     type = string
#     description = "Name of the template to reference from"
# }

# variable "sshkeys" {
#     type = string
    
# }
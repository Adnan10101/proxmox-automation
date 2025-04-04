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

variable "new_node_details" {
    type = object({
      proxmox_nodename = string
      proxmox_id = number 
    })
}

variable "misc" {
  type = object({
    bios = string 
  })
  default = {
    bios = "seabios"
  }
}

variable "cpu_core" {
    type = string
    default = 2
}

variable "memory" {
    type = string
    default = 1024
}

variable "disk_details" {
    type = object({
        interface = string
        datastore_id = string
        size = number
        file_format = string 
    })
    default = {
        interface = "scsi0"
        datastore_id = "local-lvm"
        size = 5
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
        ipv4 = "192.168.0.100/24"
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

variable new_template_details{
    type = object({
        template_name = string
        template_id = number
        enable_agent = bool
        scsi_hardware = string
    })
    default = {
        template_name = "new-vm"
        template_id = 5000
        enable_agent = true
        scsi_hardware = "virtio-scsi-pci"
    }
}

variable "pri_key_path" {
    type = string
    description = "Path of private key (where terraform runs) to ssh into"
    default = "~/.ssh/id_rsa"
}

variable "cloud_img" {
  type = object({
    type = string
    datastore_id = string
    url = string 
  })
  default = {
    datastore_id = "local"
    type = "iso"
    url = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
  }

}
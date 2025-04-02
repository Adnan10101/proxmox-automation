terraform {
    required_providers {
      proxmox = {
        source = "bpg/proxmox"
       version = "~> 0.62.0"
      }
    }
}

provider "proxmox" {
    endpoint = var.proxmox_datacenter.api_url
    api_token = "${var.proxmox_datacenter.api_token}=${var.proxmox_datacenter.api_secret}"
    insecure = true
    ssh {
      agent = var.proxmox_node_details.use_agent
      username = var.proxmox_node_details.host_user
      private_key = file(var.pri_key_path)
  }
    
}

data "local_file" "ssh_public_key" {
  count = var.public_key_path != null ? 1 : 0
  filename = var.public_key_path
}

resource "proxmox_virtual_environment_vm" "pv-1" {
    name        = var.new_vm_details.vm_name
    vm_id       = var.new_vm_details.vm_id
    node_name   = var.proxmox_node_details.node_name
    cpu {
      cores   = var.cpu_details.no_of_cores
      sockets = var.cpu_details.sockets
      type    = var.cpu_details.type  
  }
  efi_disk {
    datastore_id = var.disk_details.datastore_id
    type         = "4m"
  }
  memory {
    dedicated = var.memory.total_mem  
  }
  disk {
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = var.disk_details.interface     
    datastore_id = var.disk_details.datastore_id  
    size         = var.disk_details.size 
    iothread     = var.disk_details.iothread        
    file_format  = var.disk_details.file_format
  }
  # agent {
  #   enabled = true  # Matches agent = 1
  # }
  scsi_hardware = var.new_vm_details.scsi_hardware
  
  initialization {
    ip_config {
      ipv4 {
        address = var.network_details.ipv4
        gateway = var.network_details.gw
      }
    }
    user_account {
      username = var.user_account_details.username
      password = var.user_account_details.password
      keys = var.public_key_path != null ? [trimspace(data.local_file.ssh_public_key[0].content)] : []
    }
  }
  
  network_device {
      model = var.network_details.model
      bridge = var.network_details.bridge
  }
  lifecycle {
      ignore_changes = [network_device]
  }
}

resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = var.cloud_init.type
  datastore_id = var.cloud_init.datastore_id
  node_name    = var.proxmox_node_details.node_name

  url = var.cloud_init.url
}

# output "v" {
#         value = data.local_file.ssh_public_key.content
#     }


output "disk_size" {
        value = var.disk_details.size
    }


output "ubuntu_vm_password" {
  value     =  proxmox_virtual_environment_vm.pv-1.initialization[0].user_account[0].password
  sensitive = true
}


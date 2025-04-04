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


resource "proxmox_virtual_environment_vm" "ubuntu_template" {
    name      = var.new_node_details.proxmox_nodename
    node_name = var.proxmox_node_details.node_name
    vm_id = var.new_node_details.proxmox_id
    template = true
    started  = false

    bios        = "seabios"
    description = "Managed by Terraform"

    cpu {
        cores = var.cpu_core
    }

    memory {
        dedicated = var.memory
    }

    efi_disk {
        datastore_id = var.disk_details.datastore_id
        type         = "4m"
    }

    disk {
        datastore_id = var.disk_details.datastore_id
        file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
        interface    = var.disk_details.interface
        size         = var.disk_details.size
    }

    initialization {
        ip_config {
            ipv4 {
                address = var.network_details.ipv4 #var.network_details.ipv4
                gateway = var.network_details.gw #var.network_details.gw
            }
            
        }

        user_account {
        username = var.user_account_details.username
        password = var.user_account_details.password
        #keys = var.public_key_path != null ? [trimspace(data.local_file.ssh_public_key[0].content)] : []
    }

        #user_data_file_id = proxmox_virtual_environment_file.user_data_cloud_config.id
    }

    network_device {
        bridge = var.network_details.bridge
    }

}

resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
    content_type = var.cloud_img.type
    datastore_id = var.cloud_img.datastore_id
    node_name    = var.proxmox_node_details.node_name

    url = var.cloud_img.url
}

output  "password" {
    sensitive = true
    value = proxmox_virtual_environment_vm.ubuntu_template.initialization[0].user_account[0].password
}
# Proxmox Terraform Automation

This repository contains Terraform scripts to automate virtual machine (VM) management on a Proxmox VE server. It includes two main automation workflows:

1. **VM Creation**: Spins up a new VM with customizable settings.
2. **VM Templating**: Creates a reusable VM template from a base VM.

These scripts leverage the [BPG Proxmox Terraform provider](https://registry.terraform.io/providers/bpg/proxmox) to interact with Proxmox VE.

## Directory Structure

- **`proxmox_vm_template/`**: Contains the Terraform script for creating a VM template.
- **`vm_cloudinit/`**: Contains the Terraform script for spinning up a new VM.
- **`.gitignore`**: Ignores Terraform state files, backups, and other artifacts.

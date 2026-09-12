packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "1.1.6"
    }
  }
}

variable "iso_path" {
  type = string
}

variable "iso_checksum" {
  type = string
}

variable "output_directory" {
  type = string
}

source "qemu" "fedora" {
  accelerator      = "kvm"
  boot_command = [
    "c<wait>",
    "linux /images/pxeboot/vmlinuz inst.stage2=hd:LABEL=Fedora-E-dvd-x86_64-44 quiet inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/fedora/kickstart.cfg inst.repo=https://download.fedoraproject.org/pub/fedora/linux/releases/44/Everything/x86_64/os/ inst.cmdline console=ttyS0<enter>",
    "initrd /images/pxeboot/initrd.img<enter>",
    "boot<enter>",
  ]
  boot_wait        = "3s"
  communicator     = "none"
  cpus             = 2
  disk_interface   = "virtio"
  disk_size        = "50G"
  format           = "qcow2"
  headless         = false
  http_directory   = "${path.root}/../data"
  iso_checksum     = var.iso_checksum
  iso_url          = var.iso_path
  memory           = 4096
  net_device       = "virtio-net"
  output_directory = "${var.output_directory}/fedora"
  shutdown_timeout = "45m"
  vm_name          = "fedora.qcow2"
}

source "qemu" "ubuntu" {
  accelerator      = "kvm"
  boot_command     = ["<enter><wait><f6><esc><wait> autoinstall ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ubuntu/ ---<enter>"]
  boot_wait        = "10s"
  communicator     = "none"
  cpus             = 2
  disk_interface   = "virtio"
  disk_size        = "50G"
  format           = "qcow2"
  headless         = false
  http_directory   = "${path.root}/../data"
  iso_checksum     = var.iso_checksum
  iso_url          = var.iso_path
  memory           = 4096
  net_device       = "virtio-net"
  output_directory = "${var.output_directory}/ubuntu"
  shutdown_timeout = "45m"
  vm_name          = "ubuntu.qcow2"
}

source "qemu" "arch" {
  accelerator      = "kvm"
  boot_command     = ["<enter><wait60s>curl --fail --output /root/archinstall.json http://{{ .HTTPIP }}:{{ .HTTPPort }}/arch/archinstall.json<enter>archinstall --config /root/archinstall.json<enter>poweroff<enter>"]
  boot_wait        = "10s"
  communicator     = "none"
  cpus             = 2
  disk_interface   = "virtio"
  disk_size        = "50G"
  format           = "qcow2"
  headless         = false
  http_directory   = "${path.root}/../data"
  iso_checksum     = var.iso_checksum
  iso_url          = var.iso_path
  memory           = 4096
  net_device       = "virtio-net"
  output_directory = "${var.output_directory}/arch"
  shutdown_timeout = "45m"
  vm_name          = "arch.qcow2"
}

source "qemu" "windows" {
  accelerator      = "kvm"
  boot_wait        = "10s"
  communicator     = "none"
  cpus             = 2
  disk_interface   = "sata"
  disk_size        = "64G"
  efi_boot         = true
  floppy_files     = ["${path.root}/../data/windows/Autounattend.xml"]
  format           = "qcow2"
  headless         = false
  iso_checksum     = var.iso_checksum
  iso_url          = var.iso_path
  machine_type     = "q35"
  memory           = 4096
  net_device       = "e1000"
  output_directory = "${var.output_directory}/windows"
  shutdown_timeout = "45m"
  vm_name          = "windows.qcow2"
  vtpm             = true
}

build {
  sources = ["source.qemu.fedora"]
}

build {
  sources = ["source.qemu.ubuntu"]
}

build {
  sources = ["source.qemu.arch"]
}

build {
  sources = ["source.qemu.windows"]
}

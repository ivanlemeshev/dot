# Windows source options

This note lists Microsoft sources that work on 2026-09-14.

## Local KVM VM

Use the [standard Windows 11 ISO](https://www.microsoft.com/en-us/software-download/windows11)
for a normal local VM.
Microsoft says that this multi-edition ISO can create a VM.
A valid product key selects and activates the correct edition.
Microsoft publishes a SHA-256 value after the ISO selection.
The current target uses `Win11_25H2_English_x64_v2.iso`.
Click `I don't have a product key` during Setup.
Select Windows 11 Pro when Setup asks for an edition.
Windows remains unactivated for this disposable test.

Use the Windows 11 Enterprise Evaluation ISO from the [Microsoft Evaluation
Center](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-11-enterprise)
only when a short evaluation is enough.
The download needs registration.
It is a 90-day evaluation.
It does not need a product key during installation.
The evaluation expires and is not a permanent license.

Keep either ISO as a manual download.
The standard ISO has a temporary URL.
The Evaluation Center does not expose a stable public ISO URL.
Microsoft provides evaluation hash values through its download verification
flow.

## Ready VM images

Do not use a ready Microsoft VM image for this KVM target.
Microsoft previously provided Windows development environment images for
Hyper-V, Parallels, VirtualBox, and VMware.
Those downloads have been unavailable since 2024-10-23, as stated in the
[Microsoft Q&A answer](https://learn.microsoft.com/en-us/answers/questions/2169617/download-of-testing-windows-11-hyper-v-vms).
The former download page now redirects to the general [Windows developer
tools](https://learn.microsoft.com/en-us/windows/dev-environment/) page.
It does not offer a VM image.

Microsoft does not publish a ready qcow2 or libvirt image for local KVM.

## Microsoft hosted Windows

Azure Marketplace provides Windows 11 images under publisher
`MicrosoftWindowsDesktop` and offer `Windows-11`.
These images run in Azure.
They are not public ready local KVM disks.
An eligible customer can provision an image, generalize its VHD, and download
that customer-created VHD.
This is an Azure export flow, not a ready-image download.
Production use needs a qualifying Windows license.
[Azure Windows 11 deployment](https://learn.microsoft.com/en-us/azure/virtual-machines/windows/windows-desktop-multitenant-hosting-deployment)
lists the images and license rules.
[Download a Windows VHD from Azure](https://learn.microsoft.com/en-us/azure/virtual-machines/windows/download-vhd)
documents the generalize and export steps.

For Azure development and test use, an active Visual Studio subscription is
required for Windows 11 Enterprise client images.
[Azure client images for development and test](https://learn.microsoft.com/en-us/azure/virtual-machines/windows/client-images)
lists the eligible offers.

Windows 365 provides a hosted Cloud PC, not a local VM.
It needs Windows 365, Intune, and Microsoft Entra licensing for Enterprise.
A Linux user can connect with the web client.
See [Windows 365 requirements](https://learn.microsoft.com/en-us/windows-365/enterprise/requirements)
and [Linux access](https://learn.microsoft.com/en-us/windows-365/end-user-hardware-requirements).

## Decision

Prefer the standard multi-edition ISO for a local KVM VM.
The target installs Windows 11 Pro without activation for a disposable test.
Use a valid license before you use the VM beyond that test.
Do not add an unsupported conversion path for VirtualBox, VMware, or Azure
images.
Use Azure or Windows 365 only when a hosted Windows desktop meets the need.

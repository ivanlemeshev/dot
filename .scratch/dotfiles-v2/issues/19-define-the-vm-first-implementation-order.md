# Define the VM-first implementation order

Type: grilling
Status: resolved

## Question

What implementation order makes real Fedora KDE Plasma VM checks mandatory before later Bootstrap work starts?

## Answer

First implement one local libvirt/QEMU VM runner. It verifies the Fedora ISO, creates a fresh UEFI Fedora KDE Plasma VM with 4 GiB RAM and a 30 GiB disk, creates a non-root test user, starts a KDE Plasma session through SDDM auto-login, and runs checks through SSH. Each later implementation ticket creates a new VM, retains its evidence, and removes its VM and disk after the run. No other VM provider is in scope. A ticket must pass its VM check before the next ticket starts.

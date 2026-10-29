# NixOS System Configurations

This repository contains my NixOS system configurations.

# Hosts 
I currently manage 2 hosts, my framework desktop, and various aarch64 VMs running on Apple silicon via vmware fusion. Each of these machines is managed via flakes, and share configurations. Both also run a Rex server -- see [Rex](#rex). 

## Bootstrapping VMs

My bootstrap script draws inspo from Mitchell Hashimoto's NixOS configs: https://github.com/mitchellh/nixos-config/. 

I run NixOS from my Mac machines through VMware Fusion. 

![Screenshot](https://raw.githubusercontent.com/aumitleon/nixos-config/main/.github/images/vm-aarch64-screenshot.png)

### Minimal NixOS install
First we'll grab the minimal NixOS installer from [here](https://nixos.org/download/). 

In VMware Fusion, we'll create our boot system with the following configurations:

- Name the machine accordingly. I usually go with `NixOS`.
- Set CPU cores to about half available, and memory to about half - 2/3s. Whatever feels comfortable, this can be tweaked.
- Use bridged networking. NAT networking is preferred, but there is an issue DNS currently. 
- Set hardrive to `nvme`, and give it at least 150 GB. Note, my particular M4 Max machine has nvme drives, but other machines might have different types of drives -- you should confirm this in your system report. You would need to modify the Makefile accordingly for different SSD types because they would be identified differently for the partioning. 
  - Ensure that your Mac's home directory is shared. This will be mounted as `/host` in the VM, and the bootstrap will fail if this isn't set.
- Enable graphics acceleration and use full retina display for diaplay settings.
- Remove extra configs like the sounds card, video, etc. 


Then boot!

### VM Setup

First, we need to find the IP of the machine we're setting up. From the booted machine, we'll set the root password:

```
sudo su 
passwd
```
Make a note of the root password, and keep it simple. We'll enter it multiple times throughout the bootstrapping process.

Grab the IP with: 

```
ifconfig
```

On the Mac terminal, in the shell where you will run all the bootstrap commands, set the `NIXADDR` IP address to the IP from the VM: 

```
export NIXADDR=<IP>
```

To get the initial system setup, run our pre bootstrap set:
```
make vm/bootstrap0
```
This will create the partitions and mount the relevant disks. 

Now give the VM the Rex package token. The flake has an auth-gated `rex` input, so `make vm/bootstrap` fails with `HTTP error 401 -- Rex packages require a token` without it. From the VM, logged in as root:

```
install -m 600 /dev/null /etc/nix/netrc
printf 'machine pkgs.superlogical.com login rex password %s\n' 'TOKEN' > /etc/nix/netrc
```

The token appears on the [Rex Linux install docs](https://www.superlogical.com/rex/docs/linux/installation) once you're logged in with Linux testing-wave access. See [Rex](#rex) for the rest.

Next, we'll want to run the actual bootstrap script with: 
```
make vm/bootstrap 
```
Before transferring secrets and making them accessible under the primary user (`leon`) for me, you need to set the password for the user. Go back to the VM now, and login as root with the root password set earlier. Then, run the following to set the password for your main main user:

```
sudo passwd leon
```

Once the password is set, go back to my Mac terminal and enter that password to the prompt to continue transferring the secrets. 

One the script is done, uoi can go back to the VM that is rebooting, and it will open up to our configured environment!

### Other VMware Fusion Tips:
- If your mouse is offset, under your VM's mouse/keyboard settings, enable `Always optimize mouse for games`. 

# Rex

Both hosts run a [Rex](https://www.superlogical.com/rex/) server, configured in `modules/rex.nix` and imported by each host. That file's header comment explains why it runs the *login server* rather than the shared or personal server.

Each host is reachable from a Rex client at its own tailnet name:

```
rex hosts add vm-dev   vm-dev.tailb3adf.ts.net
rex hosts add desktop  framework-desktop-nixos.tailb3adf.ts.net
rex -S vm-dev ls
```

Serve listens on port 7297 rather than 443, so that it doesn't take over every tailnet connection to the host. A bare hostname is still enough, because the CLI tries 443 and then 7297. To see what a host is actually serving, run `tailscale serve status` on it:

```
https://vm-dev.tailb3adf.ts.net:7297 (tailnet only)
|-- / proxy unix:/run/rex/serve.sock
```

Prerequisites, all of which both hosts already meet:

- `services.tailscale.enable`, with the host enrolled in the tailnet and HTTPS enabled for it. The module asserts the first of those.
- `users.users.leon` exists. The module writes `/etc/rex/accounts.jsonc` but does not create the accounts in it.
- The principal in `modules/rex.nix` is a *tailnet* identity (`tailscale:aumitleon@gmail.com`), not a local username. `tailscale status --json` reports it as `LoginName`.

## The package token

The `rex` flake input is auth-gated until the first stable release, so Nix needs the token in `/etc/nix/netrc` on every host:

```
sudo install -m 600 /dev/null /etc/nix/netrc
printf 'machine pkgs.superlogical.com login rex password %s\n' 'TOKEN' | sudo tee /etc/nix/netrc >/dev/null
```

Two consequences worth remembering:

- **`nix flake update rex` has to run as root.** Flake tarball inputs are fetched by the client process rather than the daemon, and the netrc is `0600` root-only. Run `sudo chown leon:users flake.lock` afterwards. Locking unrelated inputs works as a normal user, since `rex` is already locked and in the store.
- **The token must never be committed.** This repo is public, and `make vm/copy` rsyncs the whole tree.


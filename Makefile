# Connectivity info for Linux VM
NIXADDR ?= unset
NIXPORT ?= 22
NIXUSER ?= leon

# Get the path to this Makefile and directory
MAKEFILE_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

# The name of the nixosConfiguration in the flake
NIXNAME ?= vm-aarch64

# Disk device to use for partitioning (override with NIXDISK=vda for virtio)
NIXDISK ?= nvme0n1

# SSH options that are used. These aren't meant to be overridden but are
# reused a lot so we just store them up here.
SSH_OPTIONS=-o PubkeyAuthentication=no -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no



# vm/bootstrap0:
# 	ssh $(SSH_OPTIONS) -p$(NIXPORT) root@$(NIXADDR) " \
# 		parted /dev/$(NIXDISK) -- mklabel gpt; \
# 		parted /dev/$(NIXDISK) -- mkpart primary 512MB -8GB; \
# 		parted /dev/$(NIXDISK) -- mkpart primary linux-swap -8GB 100\%; \
# 		parted /dev/$(NIXDISK) -- mkpart ESP fat32 1MB 512MB; \
# 		parted /dev/$(NIXDISK) -- set 3 esp on; \
# 		sleep 1; \
# 		mkfs.ext4 -L nixos /dev/$(NIXDISK)1; \
# 		mkswap -L swap /dev/$(NIXDISK)2; \
# 		mkfs.fat -F 32 -n boot /dev/$(NIXDISK)3; \
# 		sleep 1; \
# 		mount /dev/disk/by-label/nixos /mnt; \
# 		mkdir -p /mnt/boot; \
# 		mount /dev/disk/by-label/boot /mnt/boot; \
# 		nixos-generate-config --root /mnt; \
# 		sed --in-place '/system\.stateVersion = .*/a \
# 			nix.package = pkgs.nixVersions.latest;\n \
# 			nix.extraOptions = \"experimental-features = nix-command flakes\";\n \
#   		services.openssh.enable = true;\n \
# 			services.openssh.settings.PasswordAuthentication = true;\n \
# 			services.openssh.settings.PermitRootLogin = \"yes\";\n \
# 			users.users.root.initialPassword = \"root\";\n \
# 		' /mnt/etc/nixos/configuration.nix; \
# 		nixos-install --no-root-passwd && reboot; \
# 	"


vm/bootstrap0:
	ssh $(SSH_OPTIONS) -p$(NIXPORT) root@$(NIXADDR) 'set -euxo pipefail; \
	  DISK="/dev/$(NIXDISK)"; \
	  P1="$$DISK"p1; P2="$$DISK"p2; P3="$$DISK"p3; \
	  parted "$$DISK" --script -- \
	    mklabel gpt \
	    mkpart primary 512MiB -8GiB \
	    mkpart primary linux-swap -8GiB 100% \
	    mkpart ESP fat32 1MiB 512MiB \
	    set 3 esp on; \
	  partprobe "$$DISK"; udevadm settle; sleep 1; \
	  mkfs.ext4 -F -L nixos "$$P1"; \
	  mkswap -L swap "$$P2"; \
	  mkfs.fat -F 32 -n boot "$$P3"; \
	  udevadm settle; sleep 1; \
	  mount /dev/disk/by-label/nixos /mnt; \
	  mkdir -p /mnt/boot; \
	  mount /dev/disk/by-label/boot /mnt/boot; \
	  nixos-generate-config --root /mnt; \
	  sed --in-place "/system\\.stateVersion = .*/a \
	    nix.package = pkgs.nixVersions.latest;\\n \
	    nix.extraOptions = \\\"experimental-features = nix-command flakes\\\";\\n \
	    services.openssh.enable = true;\\n \
	    services.openssh.settings.PasswordAuthentication = true;\\n \
	    services.openssh.settings.PermitRootLogin = \\\"yes\\\";\\n \
	    users.users.root.initialPassword = \\\"root\\\";\\n" \
	    /mnt/etc/nixos/configuration.nix; \
	  nixos-install --no-root-passwd && reboot;'


vm/bootstrap:
	NIXUSER=root $(MAKE) vm/copy
	NIXUSER=root $(MAKE) vm/switch
	$(MAKE) vm/secrets
	ssh $(SSH_OPTIONS) -p$(NIXPORT) $(NIXUSER)@$(NIXADDR) " \
		sudo reboot; \
	"


# copy our secrets into the VM
vm/secrets:
	# GPG keyring
	rsync -av -e 'ssh $(SSH_OPTIONS)' \
		--exclude='.#*' \
		--exclude='S.*' \
		--exclude='*.conf' \
		$(HOME)/.gnupg/ $(NIXUSER)@$(NIXADDR):~/.gnupg
	# SSH keys
	rsync -av -e 'ssh $(SSH_OPTIONS)' \
		--exclude='environment' \
		$(HOME)/.ssh/ $(NIXUSER)@$(NIXADDR):~/.ssh


# copy the Nix configurations into the VM.
vm/copy:
	rsync -av -e 'ssh $(SSH_OPTIONS) -p$(NIXPORT)' \
		--exclude='.git/' \
		--rsync-path="sudo rsync" \
		$(MAKEFILE_DIR)/ $(NIXUSER)@$(NIXADDR):/nixos-config

# run the nixos-rebuild switch command. This does NOT copy files so you
# have to run vm/copy before.
vm/switch:
	ssh $(SSH_OPTIONS) -p$(NIXPORT) $(NIXUSER)@$(NIXADDR) " \
		sudo NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1 nixos-rebuild switch --show-trace -v --flake \"/nixos-config#${NIXNAME}\" \
	"

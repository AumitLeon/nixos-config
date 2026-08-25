# Personal Cachix binary cache, shared across hosts.
# Public key from `cachix use aumitleon-nixos-cache --mode nixos`.
{...}: {
  nix.settings = {
    # Allow my user to push / add substituters without sudo.
    trusted-users = ["root" "leon"];

    # extra-* appends to the defaults, so cache.nixos.org is preserved.
    extra-substituters = ["https://aumitleon-nixos-cache.cachix.org"];
    extra-trusted-public-keys = ["aumitleon-nixos-cache.cachix.org-1:EDT4nsToWhEzLYiB+KA3+1+YT0KfTa0rQzw/zeNx/DI="];
  };
}

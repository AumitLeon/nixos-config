{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jj-starship = {
      url = "github:dmmulroy/jj-starship";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    nixosConfigurations = {
      framework-desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          {nixpkgs.overlays = [inputs.jj-starship.overlays.default];}
          ./hosts/framework-desktop/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };

      vm-aarch64 = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          {nixpkgs.overlays = [inputs.jj-starship.overlays.default];}
          ./hosts/vm/vm-aarch64-configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}

# dx-nix

Nix flake for dioxus-cli v6 and v7

## Usage

To use this flake, add it to your `flake.nix` inputs:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    dx-nix.url = "github:0rvar/dx-nix";
  };

  outputs = { self, nixpkgs, dx-nix }: {
    # Your flake outputs here
  };
}
```

## Binary Cache

To use the binary cache and avoid building from source, add the following to your `flake.nix`:

```nix
{
  nixConfig = {
    extra-substituters = [ "https://0rvar.cachix.org" ];
    extra-trusted-public-keys = [ "0rvar.cachix.org-1:6BTh3kjCRE0zrZ+Pl0fZW0XfhRG6AECjtm9YefYT/7o=" ];
  };
}
```

## Available Packages

- `dioxus-cli_v6` - Dioxus CLI v6
- `dioxus-cli_v7` - Dioxus CLI v7

## Example Usage

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    dx-nix.url = "github:0rvar/dx-nix";
  };

  nixConfig = {
    extra-substituters = [ "https://0rvar.cachix.org" ];
    extra-trusted-public-keys = [ "0rvar.cachix.org-1:6BTh3kjCRE0zrZ+Pl0fZW0XfhRG6AECjtm9YefYT/7o=" ];
  };

  outputs = { self, nixpkgs, dx-nix }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          dx-nix.packages.${system}.dioxus-cli_v7
        ];
      };
    };
}
```

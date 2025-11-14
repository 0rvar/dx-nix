{
  description = "Dioxus CLI builds from different branches";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          dx =
            let
              pname = "dx";
              rev = "03ab7fa";
              version = "0.7.1";
              sha256 = "sha256-EzfuD3rWVuomyzqSv4b3SVA6MmQiWAeePbdfXEvkiRk=";
              src = pkgs.fetchFromGitHub {
                owner = "DioxusLabs";
                repo = "dioxus";
                inherit rev sha256;
              };
            in
            pkgs.rustPlatform.buildRustPackage {
              inherit pname version src;

              cargoLock = {
                lockFile = "${src}/Cargo.lock";
              };

              cargoBuildFlags = [
                "--package"
                "dioxus-cli"
              ];

              nativeBuildInputs = with pkgs; [
                pkg-config
              ];

              buildInputs =
                with pkgs;
                (
                  [
                    openssl
                    libiconv
                    pkg-config
                  ]
                  ++ lib.optionals stdenv.isLinux [
                    glib
                    gtk3
                    libsoup_3
                    webkitgtk_4_1
                    xdotool
                  ]
                  ++ lib.optionals stdenv.isDarwin (
                    with darwin.apple_sdk.frameworks;
                    [
                      IOKit
                      Carbon
                      WebKit
                      Security
                      Cocoa
                    ]
                  )
                );

              meta = with pkgs.lib; {
                description = "Dioxus CLI tool";
                homepage = "https://github.com/DioxusLabs/dioxus";
                license = licenses.mit;
                maintainers = [ ];
                mainProgram = "dx";
              };
            };
        };

        defaultPackage = self.packages.${system}.dx7;
      }
    );
}

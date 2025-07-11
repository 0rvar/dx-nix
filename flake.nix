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

        buildDioxusCli =
          {
            pname,
            rev,
            version,
            sha256,
          }:
          let
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
      in
      {
        packages = {
          v7 = buildDioxusCli {
            pname = "dioxus-cli_v7";
            # rev = "main";
            rev = "ddc94cf44c5e2ead5fb15c1db98741ba3242e6e3";
            version = "0.7.0-alpha.2";
            sha256 = "sha256-0cbKCVOC6JW9mYNv+yvKcV3+M11knmYhH+mjhs73lHY";
          };

          v6 = buildDioxusCli {
            pname = "dioxus-cli_v6";
            # rev = "v0.6-last";
            rev = "fc1f1c2";
            version = "0.6.3";
            sha256 = "sha256-iA9GDN1hE6KuKINizHZGhXADVZ6xYxl4bbEGqSsl42g";
          };
        };

        defaultPackage = self.packages.${system}.dx7;
      }
    );
}

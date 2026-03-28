{
  description = "Nix flake for tg-ws-proxy (local SOCKS5 proxy for Telegram)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    tg-ws-proxy-src = {
      url = "github:Flowseal/tg-ws-proxy/v1.2.1";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      tg-ws-proxy-src,
    }:
    let
      forAllSystems = f: nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] f;

      pkgsFor = system: import nixpkgs { inherit system; };
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
          pythonEnv = pkgs.python3.withPackages (
            ps: with ps; [
              websockets
              requests
              cryptography
            ]
          );
        in
        {
          default = pkgs.writeShellApplication {
            name = "tg-ws-proxy";
            runtimeInputs = [ pythonEnv ];
            text = ''
              export PYTHONPATH="${tg-ws-proxy-src}"
              exec python ${tg-ws-proxy-src}/proxy/tg_ws_proxy.py "$@"
            '';
          };
        }
      );

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/tg-ws-proxy";
        };
      });
    };
}

# certilia-overlay

- [English](#english)
- [Hrvatski](#hrvatski)

## English

This repository contains the Nix package recipe for [Certilia Middleware](https://www.certilia.com/preuzimanja/). It's a software client that allows citizens to sign in to the website of the Croatian e-government ([https://gov.hr/](https://gov.hr/)) using their ID.

### Usage

#### Standard Nix

1. Clone this repository
```console
git clone https://git.sr.ht/~marijan/certilia-overlay
```
or
```console
git clone https://github.com/marijanp/certilia-overlay.git
```

2. Build the package
```console
nix-build
```

3. Run the application: After a successful build, Nix will create a `result` symlink pointing to the Nix store path of the built package.
```console
result/bin/CertiliaClient
```

#### Flakes

1. Run the application
```console
nix run git+https://git.sr.ht/~marijan/certilia-overlay#certilia
```
or
```console
nix run github:marijanp/certilia-overlay#certilia
```

#### NixOS

Add the overlay as a Flake input, enable the smart card daemon (pcscd), install the package, and optionally register the PKCS#11 module in Firefox so you can log in to [gov.hr](https://gov.hr):

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    certilia.url = "github:marijanp/certilia-overlay";
    certilia.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, certilia, ... }: {
    nixosConfigurations.myhostname = nixpkgs.lib.nixosSystem {
      modules = [
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ certilia.overlays.default ];

          # Smart card daemon required for the ID card reader
          services.pcscd.enable = true;

          # Install the client (or add to home.packages via home-manager)
          environment.systemPackages = [ pkgs.certilia ];

          # Register the PKCS#11 module in Firefox for gov.hr login
          programs.firefox = {
            enable = true;
            policies.SecurityDevices."CertiliaMiddleware" =
              "${pkgs.certilia}/lib/pkcs11/libCertiliaPkcs11.so";
        })
      ];
    };
  };
}
```

### License

Copyright (c) 2025 Marijan Petričević

This project is licensed under the Mozilla Public License 2.0. See the LICENSE file for details.

## Hrvatski

Ovaj repozitorij sadrži Nix recept za paket [Certilia Middleware](https://www.certilia.com/preuzimanja/). Certilia Middleware je softverski klijent koji omogućuje prijavu na e-Građani portal ([https://gov.hr/](https://gov.hr/)) putem osobne iskaznice.

### Korištenje

#### Standard Nix

1. Kloniraj ovaj repozitorij
```console
git clone https://git.sr.ht/~marijan/certilia-overlay
```
ili
```console
git clone https://github.com/marijanp/certilia-overlay.git
```

2. Buildaj paket
```console
nix-build
```

3. Pokreni aplikaciju: Nakon uspješne izgradnje, Nix će kreirati simbolički link `result` koji pokazuje na izgrađeni paket u Nix storeu.
```console
result/bin/CertiliaClient
```

#### Flakes

1. Pokreni aplikaciju
```console
nix run git+https://git.sr.ht/~marijan/certilia-overlay#certilia
```
ili
```console
nix run github:marijanp/certilia-overlay#certilia
```

#### NixOS

Dodaj overlay kao Flake input, omogući daemon (pcscd) za pametne kartice, instaliraj paket i po želji registriraj PKCS#11 modul u Firefoxu za prijavu na [gov.hr](https://gov.hr):

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    certilia.url = "github:marijanp/certilia-overlay";
    certilia.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, certilia, ... }: {
    nixosConfigurations.myhostname = nixpkgs.lib.nixosSystem {
      modules = [
        ({ pkgs, ... }: {
          nixpkgs.overlays = [ certilia.overlays.default ];

          # Daemon za čitač pametnih kartica
          services.pcscd.enable = true;

          # Instaliraj klijent (ili dodaj u home.packages putem home-managera)
          environment.systemPackages = [ pkgs.certilia ];

          # Registriraj PKCS#11 modul u Firefoxu za prijavu na gov.hr
          programs.firefox = {
            enable = true;
            policies.SecurityDevices."CertiliaMiddleware" =
              "${pkgs.certilia}/lib/pkcs11/libCertiliaPkcs11.so";
          };
        })
      ];
    };
  };
}
```

### Licenca

Copyright (c) 2025 Marijan Petričević

Ovaj projekt je licenciran pod Mozilla Public License 2.0. Pogledaj datoteku LICENSE za detalje.

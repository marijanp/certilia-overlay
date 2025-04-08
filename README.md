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
result/bin/Client
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

### License

Copyright (c) 2025 Marijan Petričević

This project is licensed under the Mozilla Public License 2.0. See the LICENSE file for details.

## Hrvatski

Ovaj repozitorij sadrži Nix recept za paket [Certilia Middleware](https://www.certilia.com/preuzimanja/). Certilia Middleware sadrži softverski klijent koji omogućava građanima prijavu na web stranici e-Građani ([https://gov.hr/](https://gov.hr/)) koristeći osobne iskaznice.

### Upotreba

#### Standard Nix

1. Klonirajte ovaj repozitorij
```console
git clone https://git.sr.ht/~marijan/certilia-overlay
```
ili
```console
git clone https://github.com/marijanp/certilia-overlay.git
```

2. Izgradite paket
```console
nix-build
```

3. Pokrenite aplikaciju: Nakon uspješne izgradnje, Nix će stvoriti simbolički link `result` koji pokazuje na lokaciju u Nix store izgrađenog paketa.
```console
result/bin/Client
```

#### Flakes

1. Pokrenite aplikaciju
```console
nix run git+https://git.sr.ht/~marijan/certilia-overlay#certilia
```
ili
```console
nix run github:marijanp/certilia-overlay#certilia
```

### Licenca

Copyright (c) 2025 Marijan Petričević

Ovaj projekt je licenciran pod Mozilla Public License 2.0. Pogledajte datoteku LICENSE za detalje.

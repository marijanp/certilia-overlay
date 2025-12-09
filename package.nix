{ lib
, stdenvNoCC
, fetchurl
, dpkg
, autoPatchelfHook
, qt6
, pcsclite
, libjpeg8
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "certiliamiddleware";
  version = "3.9.8";

  src = fetchurl {
    url = "https://repo.certilia.com/repository/debian/pool/c/${finalAttrs.pname}/${finalAttrs.pname}_${finalAttrs.version}-1_amd64.deb";
    hash = "sha256-ovnYKU6yvw3akdlljLG97IPjQqhCKvKIGp9u6fE4mXM=";
  };

  unpackCmd = "dpkg -x $curSrc source";

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    pcsclite
    libjpeg8
  ];

  dontConfigure = true;
  dontBuild = true;

  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/lib
    mkdir -p $out/share

    cp -r etc $out/
    cp -r opt/certiliamiddleware/* $out/lib/
    cp -r usr/share/applications $out/share/applications
    cp -r usr/share/pixmaps $out/share/pixmaps

    mv $out/lib/CertiliaClient $out/bin/
    mv $out/lib/CertiliaSigner $out/bin/

    runHook postInstall
  '';

  meta = {
    description = "A client that allows citizens to sign in to the website of the Croatian e-government using their ID";
    longDescription = ''
      This repository contains the Nix package recipe for [Certilia Middleware](https://www.certilia.com/preuzimanja/).
      It's a software client that allows citizens to sign in to the website of the Croatian e-government ([https://gov.hr/](https://gov.hr/)) using their ID.
    '';
    homepage = "https://www.certilia.com/";
    downloadPage = "https://www.certilia.com/preuzimanja/";
    license = with lib.licenses; [ unfree ];
    maintainers = with lib.maintainers; [ marijanp ];
    platforms = lib.platforms.linux;
    mainProgram = "CertiliaClient";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})

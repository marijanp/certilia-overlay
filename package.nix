{ lib
, stdenvNoCC
, fetchurl
, dpkg
, autoPatchelfHook
, qt5
, pcsclite
, cups
, xkeyboard_config
,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "certiliamiddleware";
  version = "3.7.8.1";

  src = fetchurl {
    url = "https://www.certilia.com/update/${finalAttrs.pname}_v${finalAttrs.version}_amd64.deb";
    hash = "sha256-7WMjazcZ3h+wW4HXlYHj5UmNG+K6MNfkH2sSXB7InZA=";
  };

  unpackCmd = "dpkg -x $curSrc source";

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    qt5.qtbase
    pcsclite
    cups
  ];

  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/lib

    cp -r etc $out/
    cp -r usr/lib/akd/certiliamiddleware $out/lib/
    cp -r usr/share $out/

    makeWrapper $out/lib/certiliamiddleware/Client $out/bin/Client \
      --set QT_XKB_CONFIG_ROOT "${xkeyboard_config}/share/X11/xkb" \
      --prefix QT_PLUGIN_PATH : "$out/usr/lib/certiliamiddleware/plugins:${qt5.qtbase}/lib/qt-${qt5.qtbase.version}/plugins" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"

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
    mainProgram = "Client";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})

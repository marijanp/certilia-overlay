{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  cups,
  fontconfig,
  freetype,
  glib,
  libGL,
  libxkbcommon,
  openssl,
  wayland,
  pcsclite,
  libjpeg8,
  # xorg
  libx11,
  libxcb,
  libxcb-cursor,
  libxcb-image,
  libxcb-keysyms,
  libxcb-render-util,
  libxcb-wm,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "certiliamiddleware";
  version = "3.9.8";

  src = fetchurl {
    url = "https://repo.certilia.com/repository/debian/pool/c/${finalAttrs.pname}/${finalAttrs.pname}_${finalAttrs.version}-2_amd64.deb";
    hash = "sha256-0EMRfjx7vTxRxPtCTN9ehTq3LDJXAFBJQEuqBx/keqI=";
  };

  unpackCmd = "dpkg -x $curSrc source";

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    cups
    fontconfig
    freetype
    glib
    libGL
    libxkbcommon
    openssl
    wayland
    pcsclite
    libjpeg8
    libx11
    libxcb
    libxcb-cursor
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-wm
  ];

  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib $out/share

    cp -r etc $out/

    # Certilia vendors Qt 6.10.0. We intentionally do not use
    # nixpkgs Qt here because there is no ABI guarantee across Qt builds even
    # at the same source version.
    # autoPatchelfHook resolves Qt symbols from the vendored libs in $out/lib/
    # and the runtime dependencies from the buildInputs.
    # This copies the vendored Qt libs into $out/lib/
    cp -r opt/certiliamiddleware/lib/. $out/lib/

    cp -r opt/certiliamiddleware/plugins $out/lib/
    cp -r opt/certiliamiddleware/pkcs11 $out/lib/
    cp -r opt/certiliamiddleware/certificates $out/lib/
    cp -r opt/certiliamiddleware/licenses $out/lib/

    cp -r usr/share/applications $out/share/
    cp -r usr/share/pixmaps $out/share/

    install -m755 opt/certiliamiddleware/CertiliaClient $out/bin/
    install -m755 opt/certiliamiddleware/CertiliaSigner $out/bin/

    runHook postInstall
  '';

  preFixup = ''
    # Force xcb so the app runs via XWayland on Wayland sessions,
    # because the vendored Qt only ships libqxcb.so.
    for bin in CertiliaClient CertiliaSigner; do
      wrapProgram $out/bin/$bin \
        --prefix QT_PLUGIN_PATH : "$out/lib/plugins" \
        --set QT_QPA_PLATFORM xcb
    done
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

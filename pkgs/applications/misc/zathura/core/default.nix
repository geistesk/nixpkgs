{ stdenv, fetchurl, meson, ninja, makeWrapper, pkgconfig
, appstream-glib, desktop-file-utils, python3
, gtk, girara, gettext, libxml2
, sqlite, glib, texlive, libintl, libseccomp
, gtk-mac-integration, synctexSupport ? true
}:

assert synctexSupport -> texlive != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "zathura-core-${version}";
  version = "0.4.3";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura/download/zathura-${version}.tar.xz";
    sha256 = "0hgx5x09i6d0z45llzdmh4l348fxh1y102sb1w76f2fp4r21j4ky";
  };

  outputs = [ "bin" "man" "dev" "out" ];

  mesonFlags = [ "-Dmanpages=enabled" ];

  nativeBuildInputs = [
    meson ninja pkgconfig appstream-glib desktop-file-utils python3.pkgs.sphinx
    gettext makeWrapper libxml2
  ];

  buildInputs = [
    gtk girara libintl libseccomp
    sqlite glib
  ] ++ optional synctexSupport texlive.bin.core
    ++ optional stdenv.isDarwin [ gtk-mac-integration ];

  meta = {
    homepage = https://pwmt.org/projects/zathura/;
    description = "A core component for zathura PDF viewer";
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ garbas ];
  };
}

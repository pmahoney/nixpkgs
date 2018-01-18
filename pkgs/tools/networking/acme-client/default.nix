{ stdenv
, cacert
, defaultCaFile ? "${cacert}/etc/ssl/certs/ca-bundle.crt"
, fetchurl
, libbsd
, libressl
, pkgconfig
}:

stdenv.mkDerivation rec {
  name = "acme-client-${version}";
  version = "0.1.16";

  src = fetchurl {
    url = "https://kristaps.bsd.lv/acme-client/snapshots/acme-client-portable-${version}.tgz";
    sha512 = "730c20bdf9d72b24e66c54b009a282e04da3ea8ce3b9eb053750672c53c9586b2879d87a565ddbab033d7ba6a577dd6399313b20cf654b185905db4de988b6b7";
  };

  buildInputs = [ libbsd libressl pkgconfig ];

  CFLAGS = "-DDEFAULT_CA_FILE='\"${defaultCaFile}\"'";

  preConfigure = ''
    export PREFIX="$out"
  '';

  meta = {
    homepage = https://kristaps.bsd.lv/acme-client/;
    description = "Secure acme/Let's Encrypt client";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ pmahoney ];
  };
}

# Builder for 'faust2appl' scripts, such as faust2alsa. These scripts
# run faust to generate cpp code, then invoke the compiler to build
# the code. This builder wraps these scripts in parts of the stdenv.

{ stdenv
, faust
, makeWrapper
, pkgconfig }:

{ appl
, propagatedBuildInputs ? [ ]
}:

stdenv.mkDerivation {

  name = "${appl}-${faust.version}";

  phases = [ "installPhase" "fixupPhase" ];

  buildInputs = [ makeWrapper pkgconfig ];

  propagatedBuildInputs = [ faust ] ++ propagatedBuildInputs;

  installPhase = ''
    # This exports parts of the stdenv, including gcc-wrapper, so that
    # faust2${appl} will build things correctly. For example, rpath is
    # set so that compiled binaries link to the libs inside the nix
    # store (run 'ldd' on the compilation result)
    makeWrapper "${faust}/${faust.appls}/${appl}" "$out/bin/${appl}" \
      --prefix PATH : "$PATH" \
      --prefix PKG_CONFIG_PATH : "$PKG_CONFIG_PATH" \
      --set NIX_CFLAGS_COMPILE "\"$NIX_CFLAGS_COMPILE\"" \
      --set NIX_LDFLAGS "\"$NIX_LDFLAGS\""
  '';

}

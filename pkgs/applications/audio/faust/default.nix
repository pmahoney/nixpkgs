{ stdenv
, coreutils
, fetchgit
}:

let

  version = "8-1-2015";

  appls = "lib/faust/faust2appls";

in stdenv.mkDerivation rec {

  name = "faust-${version}";

  src = fetchgit {
    url = git://git.code.sf.net/p/faudiostream/code;
    rev = "4db76fdc02b6aec8d15a5af77fcd5283abe963ce";
    sha256 = "f1ac92092ee173e4bcf6b2cb1ac385a7c390fb362a578a403b2b6edd5dc7d5d0";
  };

  passthru = {
    inherit appls version;
  };

  preConfigure = ''
    makeFlags="$makeFlags prefix=$out"

    # faust makefiles use 'system ?= $(shell uname -s)' but nix
    # defines 'system' env var
    unset system
  '';

  # move all faust2* scripts into 'lib/faust/faust2appls' since they
  # won't run properly without additional paths setup
  postInstall = ''
    mkdir "$out/${appls}"
    mv "$out"/bin/faust2* "$out/${appls}"
  '';

  # change to absolute paths so 'faustpath' needn't be on PATH
  postFixup = ''
    for prog in "$out/${appls}"/*; do
      substituteInPlace "$prog" \
        --replace ". faustpath" ". '$out/bin/faustpath'" \
        --replace ". faustoptflags" ". '$out/bin/faustoptflags'"
    done

    substituteInPlace "$out"/bin/faustpath \
      --replace "/usr/local /usr /opt /opt/local" "$out"

    # can't use makeWrapper because this file is 'source'd into other
    # faust scripts
    substituteInPlace "$out"/bin/faustoptflags \
      --replace uname "${coreutils}/bin/uname"
  '';

  meta = with stdenv.lib; {
    description = "A functional programming language for realtime audio signal processing";
    longDescription = ''
      FAUST (Functional Audio Stream) is a functional programming
      language specifically designed for real-time signal processing
      and synthesis. FAUST targets high-performance signal processing
      applications and audio plug-ins for a variety of platforms and
      standards.
      The Faust compiler translates DSP specifications into very
      efficient C++ code. Thanks to the notion of architecture,
      FAUST programs can be easily deployed on a large variety of
      audio platforms and plugin formats (jack, alsa, ladspa, maxmsp,
      puredata, csound, supercollider, pure, vst, coreaudio) without
      any change to the FAUST code.
      This package has just the compiler. Install faust for the full
      set of faust2somethingElse tools.
    '';
    homepage = http://faust.grame.fr/;
    downloadPage = http://sourceforge.net/projects/faudiostream/files/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };

}

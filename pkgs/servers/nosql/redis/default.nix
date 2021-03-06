{ stdenv, fetchurl, lua }:

stdenv.mkDerivation rec {
  version = "4.0.6";
  name = "redis-${version}";

  src = fetchurl {
    url = "http://download.redis.io/releases/${name}.tar.gz";
    sha256 = "1ypnwmxwm49l0b8i9swcbjdxnc6f0r9zyqm2h423wz13xilmv6vn";
  };

  buildInputs = [ lua ];
  makeFlags = "PREFIX=$(out)";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://redis.io;
    description = "An open source, advanced key-value store";
    license = stdenv.lib.licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.berdario ];
  };
}

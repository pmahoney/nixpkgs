{ makeFaust2Appl
, alsaLib
, atk
, cairo
, fontconfig
, freetype
, gdk_pixbuf
, glib
, gtk
, pango
}:

makeFaust2Appl {

  appl = "faust2alsa";

  propagatedBuildInputs = [
    alsaLib
    atk
    cairo
    fontconfig
    freetype
    gdk_pixbuf
    glib
    gtk
    pango
  ];

}

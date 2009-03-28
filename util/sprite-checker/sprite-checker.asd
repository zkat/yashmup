(asdf:defsystem sprite-checker
  :version "0.0.1"
  :description "A simple SDL utility that animates sprite sheets"
  :maintainer "Kat <kzm@sykosomatic.org>"
  :author "Kat <kzm@sykosomatic.org>"
  :licence "MIT"
  :depends-on (lispbuilder-sdl lispbuilder-sdl-image)
  :serial t
  :components
  ((:file "sprite-checker.lisp")))

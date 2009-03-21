(asdf:defsystem yashmup
  :version "0"
  :description "A standard, basic shmup"
  :maintainer "Kat <kzm@sykosomatic.org>"
  :author "Kat <kzm@sykosomatic.org>"
  :licence "MIT"
  :depends-on (lispbuilder-sdl lispbuilder-sdl-image lispbuilder-sdl-mixer)
  :serial t
  :components
  ((:file "packages")
   (:file "config")
   (:file "key-events")
   (:file "resources")
   (:file "sprite")
   (:file "background")
   (:file "ships")
   (:file "projectile")
   (:file "main")))
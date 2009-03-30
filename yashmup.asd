(asdf:defsystem yashmup
  :version "0"
  :description "A standard, basic shmup"
  :maintainer "Kat <kzm@sykosomatic.org>"
  :author "Kat <kzm@sykosomatic.org>"
  :licence "MIT"
  :depends-on (lispbuilder-sdl lispbuilder-sdl-image lispbuilder-sdl-mixer)
  :serial t
  :components
  ((:module src
	    :serial t
	    :components
	    ((:file "packages")
	     (:module util
		      :serial t
		      :components 
		      ((:file "utils")
		       (:file "priority-queue")))
	     (:file "config")
	     (:file "thegame")
	     (:file "level")
	     (:file "event")
	     (:file "resources")
	     (:module game-objects
		      :serial t
		      :components
		      (
		       (:file "game-object")
		       (:file "sprite")
		       (:file "background")
		       (:file "ships")
		       (:file "player")
		       (:file "enemy")
		       (:file "projectile")))
	     (:file "scripting")
	     (:file "main")))))
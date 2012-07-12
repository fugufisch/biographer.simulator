#  Makefile
#  
#  Copyright 2012 Chaitanya Talnikar <chaitukca@gmail.com>
#  
#  This file contains the necessary targets for building the simulator 
#  for production.

JSFILES = main/js/*
LINT = jshint

all: libs lint doc

libs: libdir bui d3 libSBGN.js

libdir: 
	#create the lib directory
	rm -rf main/lib
	mkdir -p main/lib

bui:
	#fetch biographer-ui, install it's compilation dependencies for ubuntu and build it
	hg clone https://code.google.com/p/biographer.visualization/ UI
	cd UI
	python src/build/python/manage.py clean build test compress createDistribution
	cd ..
	cp -R UI/target/distribution/css/. main/css
	cp -R UI/target/distribution/js/. main/lib
	rm -rf UI
 
d3:
	#fetch d3.js min library 
	wget http://d3js.org/d3.v2.min.js
	mv d3.v2.min.js main/lib
	
libSBGN.js: 
	#fetch libSBGN.js, install ant and build it
	git clone git://github.com/chemhack/libSBGN.js.git
	cd libSBGN.js
	git submodule init
	git submodule update
	ant compile
	cp build/compiled-advanced.js main/lib/libSBGN.min.js
	cd ..
	rm -rf libSBGN.js

lint: 
	$(LINT) $(JSFILES)
	
doc: 
	rm -rf jsdoc
	jsdoc -d=jsdoc $(JSFILES)
	
deps: 
	#dependencies required for the simulator: building libs, checking code
	sudo apt-get install nodejs npm node-uglify  ant git-core mercurial jsdoc-toolkit
	sudo npm install -g $(LINT)

.PHONY: doc
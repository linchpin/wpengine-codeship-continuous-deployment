#!/bin/bash
# If any commands fail (exit code other than 0) entire script exits
set -e

# See if our project has a gulpfile either in the root directory if it's a theme
# or in the assets/ folder if it is a plugin

composer_path="./composer.json"
package_path="./package.json"
build_file_path="./gulpfile.js"
bower_file_path="./bower.json"
build_type=none

# Begin from the ~/clone directory
# this directory is the default your git project is checked out into by Codeship.
cd ~/clone

# If we have composer dependencies make sure they are installed
if [ -f "$composer_path" ]
then
	echo "Composer File found. Starting composer install."
	composer install
fi

if [ -f "$build_file_path" ]
then
	echo "Gulpfile found. Starting build process"
	build_type=gulp
else
	build_file_path="./gulpfile.babel.js"
	if [ -f "$build_file_path" ]
	then
		echo "Gulpfile w/ Babel found. Starting build process"
		build_type=gulp_yarn
	fi
fi

if [ "$build_type" == "none" ]
then
	echo "Gulpfile not found. Searching for Gruntfile instead."
	build_file_path="./Gruntfile.js"
    if [ -f "$build_file_path" ]
    then
        echo "Gruntfile found."
        build_type=grunt	
    else
        echo "No build file found. No build needed."
    fi
fi

# check to see our build type and if so build using either gulp or grunt
if [ "$build_type" != "none" ]
then
	if [ "$build_type" == "gulp_yarn" ]
	then
		# Only build if the build:production task exists in the build path
		if [ grep -Fxq "build:production" "$build_file_path" ]
		then
			echo "Yarn Install"
			yarn install

			echo "Building project using gulp"
			gulp build:production
		fi
	else
	    echo "Initiating NPM Install"
	    npm install

	    # Only install and fire bower if we have a bower.json
	    if [ -f "$bower_file_path" ]
	    then
		    if [ grep -Fxq "build:production" "$bower_file_path" ]
			then
			echo "Initiating Bower Install"

			npm install -g bower
			bower install
		    fi
	    fi

	    if [ $build_type = "gulp" ]
	    then
		    if [ grep -Fxq "build:production" "$build_file_path" ]
			then
			echo "Building project using gulp"
			gulp build:production
		    fi
	    else
	    	    # Make sure we have a build command within our grunt file
		    if [ grep -Fxq "build" "$build_file_path" ]
			then
			echo "Building project using grunt"
			grunt build
		    fi
	    fi
	fi
fi

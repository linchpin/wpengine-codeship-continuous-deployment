#!/bin/bash
# If any commands fail (exit code other than 0) entire script exits
set -e

# See if our project has a gulpfile either in the root directory if it's a theme
# or in the assets/ folder if it is a plugin

package_path="./package.json"
build_file_path="./gulpfile.js"
build_type=none

# Begin from the ~/clone directory
# this directory is the default your git project is checked out into by Codeship.
cd ~/clone

if [ -f "$build_file_path" ]
then
	echo "Gulpfile found. Starting build process"
	build_type=gulp
else
	echo "Gulpfile not found. Searching for Gruntfile instead."

	build_file_path="./Gruntfile.js"

    if [ -f "$build_file_path" ]
    then
        echo "Gruntfile found."
        build_type=grunt
    else
        echo "No Grunt file found. No build needed."
    fi
fi

echo $build_type

# check to see our build type and if so build using either gulp or grunt
if [ "$build_type" != "none" ]; then
    npm install
    npm install -g bower
    bower install

    if [ $build_type = "gulp" ]
    then
        echo "Building project using gulp"
        gulp build:production
    else
        echo "Building project using grunt"
        grunt build:production
    fi
fi
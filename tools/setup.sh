#!/bin/bash

VERSION=0.5.0
set -e

# Functions
function npm_error(){
    echo 'You need to install Node before we can continue (http://nodejs.org/)'
    exit 1
}

# Let's go
echo $'\n'cracklistr $VERSION
echo ================

if [[
    -d 'node_modules/apache-server-configs/dist' &&
    -d 'node_modules/bootlint' &&
    -d 'node_modules/bootstrap' &&
    -d 'node_modules/bootswatch' &&
    -d 'node_modules/font-awesome' &&
    -d 'node_modules/highlight.js' &&
    -d 'node_modules/jquery' &&
    -d 'node_modules/jquery-searcher' &&
    -d 'node_modules/jquery-stupid-table' &&
    -d 'node_modules/m8tro-bootstrap'
   ]]
then
    echo "Node modules found"
else
    echo 'Installing missing Node modules'
    npm install --silent || npm_error
fi

if [ ! -f 'node_modules/highlight.js/build/highlight.pack.js' ]
then
    echo $'Building highlight.js'
    gulp build_hjs --silent
fi

if [ -f 'dist/config.json' ]
then
    # upgrade codebase only
    echo $'Updating codebase'
    gulp upgrade --silent
else
    # clean up dist-folder, copy files
    echo $'Initializing application'
    gulp init --silent
fi

# set dependencies source
gulp setup --silent

gulp merge --silent

echo $'\nGame over!'

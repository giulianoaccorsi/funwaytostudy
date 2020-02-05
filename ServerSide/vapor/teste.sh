#!/bin/bash
echo Project name?
read project
vapor new $project
cd $project
rm -r -f .git
vapor build
vapor xcode -y
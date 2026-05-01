#!/bin/bash


echo "it makes file or directory to be executable "

read -p " select the filename with extension: " name

chmod +x $name

echo "##################"

echo "---changed-------"

echo "##################"

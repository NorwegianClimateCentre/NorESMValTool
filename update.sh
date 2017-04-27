#!/bin/sh -e

if [ ! -e $HOME/NorESMValTool ] 
then 
  echo "$HOME/NorESMValTool does not exist." 
  echo 
  echo "Please run instead /projects/NS2345K/NorESMValTool/install.sh"
  exit
fi

for ITEM in scripts mods tools 
do
  rsync -urv /projects/NS2345K/NorESMValTool/$ITEM $HOME/NorESMValTool
done


#!/bin/sh -e

echo "create NorESMValTool folder in home directory and copy content"
ESMVAL_REPO=`dirname \`readlink -f $0\`` 
ESMVAL_HOME=$HOME/NorESMValTool 
mkdir -p $ESMVAL_HOME
cp -rp $ESMVAL_REPO/tools $ESMVAL_HOME
cp -rp $ESMVAL_REPO/scripts $ESMVAL_HOME
cp -rp $ESMVAL_REPO/namelists $ESMVAL_HOME
cd $ESMVAL_HOME 
ln -s $ESMVAL_REPO/data . 
echo "  new home of NorESMValTool is $ESMVAL_HOME"

echo "customize config_private.xml"
# define paths and create directories
ESMVAL_SCRATCH=/scratch/$USER/NorESMValTool
ESMVAL_PLOTPATH=$ESMVAL_HOME/plots
ESMVAL_OBSPATH=$ESMVAL_HOME/data/obs
ESMVAL_RAWOBSPATH=$ESMVAL_HOME/data/rawobs
ESMVAL_MODELPATH=$ESMVAL_HOME/data/model
ESMVAL_WORKPATH=$ESMVAL_SCRATCH/work
ESMVAL_REGRPATH=$ESMVAL_SCRATCH/regr 
ESMVAL_CLIMOPATH=$ESMVAL_SCRATCH/climo
ESMVAL_CONF=$ESMVAL_HOME/tools/ESMValTool/config_private.xml
mkdir -p $ESMVAL_HOME/plots $ESMVAL_SCRATCH/work $ESMVAL_SCRATCH/regr $ESMVAL_SCRATCH/climo 
# make sure that xml command line editor is available
if [ `command -v xml` -eq 0 ]
then
  if [ `uname -n | grep norstore | wc -w` -eq 0 ]
  then
    echo 'Error: cannot find xml command line editor. please install xmlstarlet.' 
    exit
  else
    . /usr/share/Modules/init/sh
    load module xmlstarlet
  fi
fi  
# copy factory config_private.xml and apply customizations 
cp -f $ESMVAL_CONF config_private.xml 
xml ed -u "/settings/pathCollection/usrpath[@id='WORKPATH']/path" -v $ESMVAL_WORKPATH config_private.xml > updated.xml 
mv updated.xml config_private.xml
xml ed -u "/settings/pathCollection/usrpath[@id='OBSPATH']/path" -v $ESMVAL_OBSPATH config_private.xml > updated.xml
mv updated.xml config_private.xml
xml ed -u "/settings/pathCollection/usrpath[@id='OBSPATH2']/path" -v $ESMVAL_OBSPATH config_private.xml > updated.xml
mv updated.xml config_private.xml
xml ed -u "/settings/pathCollection/usrpath[@id='RAWOBSPATH']/path" -v $ESMVAL_RAWOBSPATH config_private.xml > updated.xml
mv updated.xml config_private.xml
xml ed -u "/settings/pathCollection/usrpath[@id='MODELPATH']/path" -v $ESMVAL_MODELPATH config_private.xml > updated.xml
mv updated.xml config_private.xml
xml ed -u "/settings/pathCollection/usrpath[@id='REGRPATH']/path" -v $ESMVAL_REGRPATH config_private.xml > updated.xml
mv updated.xml config_private.xml
xml ed -u "/settings/pathCollection/usrpath[@id='PLOTPATH']/path" -v $ESMVAL_PLOTPATH config_private.xml > updated.xml
mv updated.xml config_private.xml
xml ed -u "/settings/pathCollection/usrpath[@id='CLIMOPATH']/path" -v $ESMVAL_CLIMOPATH config_private.xml > $ESMVAL_CONF



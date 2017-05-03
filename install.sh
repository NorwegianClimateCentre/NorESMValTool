#!/bin/sh -e

echo "installing NorESMValTool folder in home directory"
echo
ESMVAL_REPO=`dirname \`readlink -f $0\`` 
ESMVAL_HOME=$HOME/NorESMValTool 
mkdir -p $ESMVAL_HOME
cp -rp $ESMVAL_REPO/scripts $ESMVAL_HOME
cp -rp $ESMVAL_REPO/mods $ESMVAL_HOME
cd $ESMVAL_HOME 
ln -s $ESMVAL_REPO/data . 

echo "donwload latest version of ESMValTool" 
echo
mkdir -p $ESMVAL_HOME/tools
cd $ESMVAL_HOME/tools
git clone https://github.com/ESMValGroup/ESMValTool.git

echo "donwload and build latest version of noresm2cmor" 
echo
git clone https://github.com/NorwegianClimateCentre/noresm2cmor.git
cd $ESMVAL_HOME/tools/noresm2cmor/build 
if [ `uname -n | grep norstore | wc -l` -gt 0 ] 
then 
  . /usr/share/Modules/init/sh
  module unload gcc netcdf netcdf.gnu hdf5.gnu 
  module load gcc/4.7.2
fi
make -f Makefile.norstore_default
mkdir -p $ESMVAL_HOME/tools/noresm2cmor/data
cd $ESMVAL_HOME/tools/noresm2cmor/data 
ln -sf /projects/NS2345K/noresm/cmorout cmorout
ln -sf /projects/NS2345K/www/cmor/griddata griddata
ln -sf /projects/NS2345K/www/cmor/sampledata sampledata

echo "customize ESMValTool"
echo
ESMVAL_CONF=$ESMVAL_HOME/tools/ESMValTool/config_private.xml
echo "  namelist with ESMValTool settings stored at ${ESMVAL_CONF}"
ESMVAL_SCRATCH=/scratch/$USER/NorESMValTool
ESMVAL_PLOTPATH=$ESMVAL_HOME/plots
ESMVAL_OBSPATH=$ESMVAL_HOME/data/obs
ESMVAL_RAWOBSPATH=$ESMVAL_HOME/data/rawobs
ESMVAL_MODELPATH=$ESMVAL_HOME/data/model
ESMVAL_WORKPATH=$ESMVAL_SCRATCH/work
ESMVAL_REGRPATH=$ESMVAL_SCRATCH/regrid
ESMVAL_CLIMOPATH=$ESMVAL_SCRATCH/climo
sed -i "s%/path/to/work%${ESMVAL_WORKPATH}%" $ESMVAL_CONF
echo "  ESMValTool work path set to ${ESMVAL_WORKPATH}"
sed -i "s%/path/to/plots%${ESMVAL_PLOTPATH}%" $ESMVAL_CONF
echo "  ESMValTool plot path set to ${ESMVAL_PLOTPATH}"
sed -i "s%/path/to/climo%${ESMVAL_CLIMOPATH}%" $ESMVAL_CONF
echo "  ESMValTool climatology path set to ${ESMVAL_CLIMOPATH}"
sed -i "s%/path/to/regridding%${ESMVAL_REGRPATH}%" $ESMVAL_CONF
echo "  ESMValTool regridding path set to ${ESMVAL_REGRPATH}"
sed -i "s%/path/to/modeldata%${ESMVAL_MODELPATH}%" $ESMVAL_CONF
echo "  ESMValTool model data path set to ${ESMVAL_MODELPATH}"
sed -i "s%/path/to/data/obsdata2%${ESMVAL_OBSPATH}%" $ESMVAL_CONF
echo "  ESMValTool alternative obs data path set to ${ESMVAL_OBSPATH}"
sed -i "s%/path/to/data/obsdata%${ESMVAL_OBSPATH}%" $ESMVAL_CONF
echo "  ESMValTool obs data path set to ${ESMVAL_OBSPATH}"
sed -i "s%/path/to/data/rawobsdata%${ESMVAL_RAWOBSPATH}%" $ESMVAL_CONF
echo "  ESMValTool rawobs data path set to ${ESMVAL_RAWOBSPATH}"
mkdir -p $ESMVAL_HOME/plots $ESMVAL_SCRATCH/work $ESMVAL_SCRATCH/regrid $ESMVAL_SCRATCH/climo 
 

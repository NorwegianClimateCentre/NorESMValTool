#!/bin/sh -e

echo "installing NorESMValTool folder in home directory"
echo
ESMVAL_REPO=`dirname \`readlink -f $0\`` 
ESMVAL_HOME=$HOME/NorESMValTool 
mkdir -p $ESMVAL_HOME
cp -rp $ESMVAL_REPO/scripts $ESMVAL_HOME
cp -rp $ESMVAL_REPO/mods $ESMVAL_HOME
cd $ESMVAL_HOME 
ln -sf $ESMVAL_REPO/data . 

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
  module unload gcc pgi netcdf hdf5 netcdf.gnu hdf5.gnu
  module load netcdf.intel/4.4.0 udunits/2.2.17 uuid/1.5.1
  make -f Makefile_cmor2.norstore_intel
elif [ `uname -n | grep tos | wc -l` -gt 0 ]
then
  source /opt/intel/compilers_and_libraries/linux/bin/compilervars.sh -arch intel64 -platform linux
  make -f Makefile_cmor2.nird_intel
fi
mkdir -p $ESMVAL_HOME/tools/noresm2cmor/data
cd $ESMVAL_HOME/tools/noresm2cmor/data 
ln -sf $ESMVAL_REPO/data/cmor cmorout
ln -sf /projects/NS2345K/www/cmor/griddata griddata
ln -sf /projects/NS2345K/www/cmor/sampledata sampledata
cd $ESMVAL_HOME/scripts 
ln -sf ../tools/noresm2cmor/scripts/cmorize_generic_intel.sh cmorize

echo "customize ESMValTool"
echo
ESMVAL_CONF=$ESMVAL_HOME/tools/ESMValTool/config_private.xml
echo "  namelist with ESMValTool settings stored at ${ESMVAL_CONF}"
ESMVAL_PLOTPATH=$ESMVAL_HOME/plots
ESMVAL_OBSPATH=$ESMVAL_HOME/data/obs
ESMVAL_RAWOBSPATH=$ESMVAL_HOME/data/rawobs
ESMVAL_MODELPATH=$ESMVAL_HOME/data/model
ESMVAL_WORKPATH=$ESMVAL_HOME/data/work
ESMVAL_REGRPATH=$ESMVAL_HOME/data/regrid
ESMVAL_CLIMOPATH=$ESMVAL_HOME/data/clim
ESMVAL_CMORPATH=$ESMVAL_HOME/data/cmor
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
echo "  ESMValTool cmor data path set to ${ESMVAL_CMORPATH}"
mkdir -p $ESMVAL_HOME/plots
 

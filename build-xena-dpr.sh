#!/bin/bash

DATE=`date +%y%m%d%H%M`
BUILDLOC=~/Desktop
SCRIPTLOC=~/code/naa/

# Directory structure
mkdir $BUILDLOC &>/dev/null
cd $BUILDLOC
mkdir source-$DATE
cd source-$DATE

# Check out Xena
echo "Checking out Xena from *urgh* CVS *urgh*.."
cvs -z3 -d:extssh:csmart@xena.cvs.sourceforge.net:/cvsroot/xena co -P archive audio basic csv dataset email example_plugin html image multipage naa office pdf plaintext plugin_howto postscript project psd website xena xml &>/dev/null

# Check out DPR
echo "Checking out DPR from *urgh* CVS *urgh*.."
cvs -z3 -d:extssh:csmart@dpr.cvs.sourceforge.net:/cvsroot/dpr co -P dpr fake-bridge manifest RollingChecker &>/dev/null
#To get the testing branch, uncomment the following
#cvs -z3 -d:extssh:csmart@dpr.cvs.sourceforge.net:/cvsroot/dpr co -r testing -P dpr fake-bridge &>/dev/null


#Bypass up MANIFEST.MF issue
#cp -iv $SCRIPTLOC/ReprocessingJobImporter.java $BUILDLOC/source-$DATE/dpr/src/au/gov/naa/digipres/dpr/core/importexport/ReprocessingJobImporter.java

# Build Xena
echo "Building Xena.."
cd xena
#ant &>/dev/null
#ant -f build_plugins.xml &>/dev/null
ant
ant -f build_plugins.xml

echo ""
echo "Complete. Hit enter to continue."
read

# Build DPR
echo "Building DPR.."
cd ../dpr
#ant init &>/dev/null
#ant dist &>/dev/null
ant init
ant dist

echo ""
echo "Complete. Hit enter to continue."
read

#Building fake-bridge
cd ../fake-bridge
ant
#ant &>/dev/null

#Building checksum-checker
cd ../RollingChecker
ant
#ant &>/dev/null

echo ""
echo "Complete. Hit enter to continue."
read

# Compile dist
echo "Gathering binaries.."
cd $BUILDLOC
cp -a source-$DATE/dpr/dist ./dist-$DATE
cp -a source-$DATE/fake-bridge/dist/* ./dist-$DATE
cp -a source-$DATE/xena/dist/* ./dist-$DATE
chmod a+x dist-$DATE/*sh

#Cleanup CVS junk
rm -Rf `find $BUILDLOC/dist-$DATE -name CVS*`
rm -Rf `find $BUILDLOC/dist-$DATE -name .cvs*`

# Echo out result
echo ""
echo "OK, Xena and DPR have been built in $BUILDLOC/dist-$DATE"
echo "Don't forget to commit the new build number."



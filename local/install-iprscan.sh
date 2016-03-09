#!/bin/bash

# Automation of steps documented at https://github.com/ebi-pf-team/interproscan/wiki/HowToDownload

IPRSCAN_VERSION="5.16-55.0"
PANTHER_VERSION="10.0"

OWNER="vaughn"
GROUP="G-800657"
IPRSCANBASE="/scratch/projects/tacc/bio/interproscan"
FNAME="interproscan-${IPRSCAN_VERSION}"

if [ -f "$IPRSCANBASE/interproscan-${IPRSCAN_VERSION}.OK" ];
then
    echo "InterProScan ${IPRSCAN_VERSION} appears to be installed already."
    exit 1
fi

mkdir -p "${IPRSCANBASE}"
cd "${IPRSCANBASE}"
if [ ! -f "interproscan-${IPRSCAN_VERSION}-64-bit.tar.gz" ];
then
    echo "Downloading..."
    wget "ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/${IPRSCAN_VERSION}/interproscan-${IPRSCAN_VERSION}-64-bit.tar.gz"
    wget "ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/${IPRSCAN_VERSION}/interproscan-${IPRSCAN_VERSION}-64-bit.tar.gz.md5"
    echo "Done"
else
    echo "It looks like interproscan-${IPRSCAN_VERSION}-64-bit.tar.gz has already been downloaded."
fi

if [ ! -f "interproscan-${IPRSCAN_VERSION}-64-bit.tar.gz.md5.OK" ];
then
    echo "Verifying..."
    MD5CHECK=$(md5sum -c interproscan-${IPRSCAN_VERSION}-64-bit.tar.gz.md5 | egrep -o "OK" )
    if [ "$MD5CHECK" = "OK" ];
    then
        echo "OK"
        touch "interproscan-${IPRSCAN_VERSION}-64-bit.tar.gz.md5.OK"
    else
        echo "Failed to pass md5sum"
        exit 1
    fi
fi

# Unpack
if [ ! -d "interproscan-${IPRSCAN_VERSION}" ];
then
    echo "Unpacking..."
    tar -pxvzf "interproscan-${IPRSCAN_VERSION}-64-bit.tar.gz"
    echo "Done"
else
    echo "It looks like interproscan-${IPRSCAN_VERSION} has already been unpacked."
fi

echo "Installing PANTHER models..."
cd "interproscan-${IPRSCAN_VERSION}/data/"

if [ ! -f "panther-data-10.0.tar.gz" ];
then
    echo "Downloading PANTHER data..."
    wget "ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/data/panther-data-${PANTHER_VERSION}.tar.gz"
    wget "ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/data/panther-data-${PANTHER_VERSION}.tar.gz.md5"
    echo "Done"
else
    echo "It looks like panther-data-${PANTHER_VERSION}.tar.gz has already been downloaded."
fi

if [ ! -f "panther-data-${PANTHER_VERSION}.tar.gz.md5.OK" ];
then
    echo "Verifying..."
    MD5CHECK=$(md5sum -c "panther-data-${PANTHER_VERSION}.tar.gz" | egrep -o "OK" )
    if [ "$MD5CHECK" = "OK" ];
    then
        echo "OK"
        touch "panther-data-${PANTHER_VERSION}.tar.gz.md5.OK"
    else
        echo "Failed to pass md5sum"
        #exit 1
    fi
fi

if [ ! -d "panther-data-${PANTHER_VERSION}" ];
then
    echo "Unpacking..."
    tar -pxvzf "panther-data-${PANTHER_VERSION}.tar.gz"
    echo "Done"
else
    echo "It looks like panther-data-${PANTHER_VERSION} has already been unpacked."
fi

echo "Updating ownership..."
cd "$IPRSCANBASE"
find interproscan-5.16-55.0 -print0 | xargs -P 8 -0 chown ${OWNER}:${GROUP}
chown -R ${OWNER}:${GROUP} "interproscan-${IPRSCAN_VERSION}"
echo "Done"

# Need to design a script that will automatically set up the interproscan.properties file
# to support our "licensed" binaries and the Stampede-optimized -cpu options

touch "$IPRSCANBASE/interproscan-${IPRSCAN_VERSION}.OK"
echo "InterProScan ${IPRSCAN_VERSION} and PANTHER ${PANTHER_VERSION} are installed at"
echo "$IPRSCANBASE/interproscan-${IPRSCAN_VERSION}"
exit 0


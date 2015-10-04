#!/bin/sh

SYNO=syno-i686-bootstrap_1.2-7_i686.xsh
URL=http://ipkg.nslu2-linux.org/feeds/optware/syno-i686/cross/unstable/${SYNO}

(
	echo "# will go HOME=${HOME}, make tmp"
	cd ${HOME}
	mkdir -p tmp && cd tmp
	
	echo "# will fetch ${URL} now"
	wget $URL

	echo "# will run ${SYNO} now"
	chmod 755 $SYNO
	./$SYNO

	echo "# will add PATH to your ${HOME}/.profile"
	echo 'export PATH=/opt/bin:/opt/sbin:$PATH' >> $HOME/.profile
)

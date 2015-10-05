#!/bin/sh

SYNO=syno-i686-bootstrap_1.2-7_i686.xsh
URL=http://ipkg.nslu2-linux.org/feeds/optware/syno-i686/cross/unstable/${SYNO}
R=/volume1/@appstore/debian-chroot/var/chroottarget/

echo "# Running ipkg / Debian chroot bootstrap"

echo "# Do you want to install ipkg now? [y/n]"
read A
if [ "$A" = "y" ]; then
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
else
	echo "Skipping!"
fi

P=`readlink ${HOME}/.profile`
if [ "$P" = ".profile" ]; then
	echo "# ${HOME}/.profile already installed! Will skip"
else
	if [ -f ~/.profile ]; then
		CMD="mv ~/.profile ~/.profile.`date +'%Y%m%d-%s'`"
		echo $CMD
		sh -c "$CMD"
	fi
	echo "# Installing symlink from ~/.profile -> .profile"
	ln -s `pwd`/.profile ${HOME}/.profile
fi

S=/var/packages/debian-chroot/scripts/start-stop-status
echo "# will backup to ./ and replace $S with ./start-stop-status"
cp $S start-stop-status.bak
cp start-stop-status $S

# Based on http://www.hang321.net/en/2015/06/09/debian-chroot-on-dsm-5-2/
sed -i 's/fr.debian.org/us.debian.org/g' $R/etc/apt/sources.list
cat > $R/setup.sh <<EOF
apt-get update
apt-get upgrade -y
apt-get install -y locales
dpkg-reconfigure locales
dpkg-reconfigure tzdata
apt-get install -y less vim curl rsync screen openssh-server bash-completion
EOF
chroot $R sh /setup.sh

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
		CMD="cp -H ~/.profile ~/.profile.`date +'%Y%m%d-%s'`"
		echo $CMD
		sh -c "$CMD"
	fi
	echo "# Installing symlink from ~/.profile -> .profile"
	ln -s `pwd`/.profile ${HOME}/.profile
fi

mkdir -p $HOME/keys
if [ ! -f $HOME/keys/nas ]; then
	echo "# will generate SSH keys now in $HOME/keys"
	ssh-keygen -f $HOME/keys/nas -b 4096 -t rsa
else
	echo "# $HOME/keys exists. Skipping SSH key generation!"
fi

echo "# About to enable proper GitHub configuration entry for SSH"
mkdir -p ~/.ssh
grep github.com ~/.ssh/config >/dev/null 2>/dev/null
if [ $? -eq 0 ]; then
	echo "# ...$HOME/config has github.com entry already. Skipping!"
else
	touch ~/.ssh/config
	(
		echo "Host github.com"
		echo "	IdentityFile /root/keys/nas"
		echo "	User	git"
		echo "	HostName github.com"
	) >> ~/.ssh/config
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

cat<<EOF
---------------------- Synology bootstrap complete ------------------
SSH keys are in: $HOME/keys/

I encourage you to fork and extend this repo. Before doing so, install
and configure git:

ipkg install git
git config --global user.name "John Doe"
git config --global user.email johndoe@example.com
git config --global push.default simple

If you forked to myuser/synology, then take $HOME/keys/nas.pub and stick
it in GitHub -> myuser/synology -> Settings -> Deploy keys. Mark the key
read/write to be able to push to the repository.

Enjoy! Comments and feedback: Wojciech A. Koszek, wojciech@koszek.com
---------------------------------------------------------------------
EOF

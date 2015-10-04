#!/usr/bin

echo "# Running ipkg / Debian chroot bootstrap"

echo "# Do you want to install ipkg now? [y/n]"
read A
if [ "$A" = "y" ]; then
	./install_ipkg.sh
else
	echo "Skipping!"
fi

# Install .profile will come here...

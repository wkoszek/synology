# Making Synology NAS command line usable
**My Synology automation scripts**

[![Build Status](https://travis-ci.org/wkoszek/synology.svg?branch=master)](https://travis-ci.org/wkoszek/synology)

**This project should be converted to Ansible. Any volunteers?**

I have a Synology DS214play NAS box and its command line is pretty limited. Most of the
commands are trimmed down copies of their UNIX counterparts. I like my NAS
being NAS, but I also wanted to be able to do useful things with it, assuming
it's powered 24/7. To make its command line usable for myself
in a long-term, I decided to spend some time on proper configuration.
Unfortunately my NAS model isn't permitted to use Synology's Docker package, so the whole
activity included:

- `ipkg` installation: this will give you basic commands such as `vim` or
  `bash`

- Debian chroot: this will let you run a Debian userland, which gives you
  `apt-get` and the possibility of running all sorts of stuff on your
  Synology box. I found it useful when experimenting with command-line
  backup solutions such as `zbackup`, which don't exist in `ipkg`
  repository.

I stole some ideas from:

http://www.hang321.net/en/2015/06/09/debian-chroot-on-dsm-5-2/

# How to use

1. Enable SSH on your Synology http://forum.synology.com/wiki/index.php/Enabling_the_Command_Line_Interface
2. Go to [https://synocommunity.com/](https://synocommunity.com/) and add the Community Packages to Synology software sources.
3. From the community packages tab, install Python.
4. From the community packages tab, install Debian chroot.
5. Upon installing, start Debian chroot.

SSH to your NAS:

	ssh root@nas_ip

Get the simple Python script which imitates `wget`, but unlike Synology's
`wget(1)` has HTTPS support (http://www.koszek.com/blog/2015/10/04/wget-in-9-lines-of-python-for-hostile-environments/):

	wget -O - 'http://pastebin.com/raw.php?i=PcbNtyh9' | tr '\r' ' ' > wget2
	chmod 755 wget2
	./wget2 https://github.com/wkoszek/synology/archive/0.1.1.tar.gz
	gunzip 0.1.1.tar.gz
	tar xf 0.1.1.tar
	cd synology-0.1.1
	./bootstrap.sh

(you may want to pick the latest `synology-x.x.x` release).

This should initiate the bootstrap procedure.

# What bootstrap does for you

Upon running `bootstrap.sh` following things will happen:

1. `ipkg` will be fetched and installed.
2. ASH config will be updated to add `ipkg` to `PATH`
3. `.profile` will be updated with some usable aliases and mandatory settings
4. SSH keys will be generated.
5. SSH configuration will be installed for GitHub.com in case you want to push from your NAS
6. Updated start script for Debian chroot will be installed. It basically
mounts home directories in the chroot directory, and also adds USB-mounted
volumes there.
7. Debian's chroot environment will be started and updated.
8. Informational message will be printed.

# Author

- Wojciech Adam Koszek, [wojciech@koszek.com](mailto:wojciech@koszek.com)
- [http://www.koszek.com](http://www.koszek.com)

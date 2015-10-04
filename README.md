# My Synology automation scripts

I have a Synology box and to make its command line usable, one needs 2
things:

- `ipkg` installation: this will give you basic commands such as `vim` or
  `bash`

- Debian chroot: this will let you run a Debian chroot, which gives you
  `apt-get` and the possibility of running all sorts of stuff on your
  Synology box. I found it useful when experimenting with command-line
  backup solutions such as `zbackup`, which don't exist in `ipkg`
  repository.

I stole some ideas from:

http://www.hang321.net/en/2015/06/09/debian-chroot-on-dsm-5-2/

# How to use



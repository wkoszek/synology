umask 022

PATH=/opt/bin:/opt/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/syno/sbin:/usr/syno/bin:/usr/local/sbin:/usr/local/bin
export PATH

#This fixes the backspace when telnetting in.
#if [ "$TERM" != "linux" ]; then
#        stty erase
#fi

HOME=/root
export HOME

TERM=${TERM:-cons25}
export TERM

PAGER=more
export PAGER

PS1="`hostname`> "

# ---------------------------------------------------------------------------

export GIT_SSH='/usr/bin/ssh'
export SYNOREL=https://github.com/wkoszek/synology/archive/

alias dir="ls -al"
alias ll="ls -la"
alias la="ls -la"

alias debian="/var/packages/debian-chroot/scripts/start-stop-status chroot"
alias screen="env TERM=xterm screen"
alias wget="/root/synology/wget2"

#!/bin/sh
#
# Add local 'user' from USERID if passed in, or a fallback value.
# Use CHDIR from calling env, or use the HOME directory
#
# Uses chroot, but could use setpriv, su-exec, gosu

: "${CHDIR:=}"
: "${USERID:=9001}"

USERNAME=user

export HOME="/home/$USERNAME"
export SHELL="/bin/bash"

[ "$#" -gt 0 ] || set -- "$SHELL" -i

/usr/sbin/useradd --shell "$SHELL" \
    -o -m -u "$USERID" -g users "$USERNAME"

if :
then
    cat << SUDOERS >> /etc/sudoers
# ---------------
# Allow entrypoint user to sudo back to root.
# Not secure, but people could also just bypass entrypoint as well
$USERNAME ALL=(ALL) NOPASSWD:ALL

# ---------------
SUDOERS
fi

# echo "Starting with user='$USERNAME' ($USERID)" 1>&2

unset chdir
if [ -n "$CHDIR" ]
then
    if [ -d "$CHDIR" ]
    then
        cd "$CHDIR" && chdir=true
    fi
    [ -n "$chdir" ] || echo "No directory: $CHDIR" 1>&2
fi
if [ -z "$chdir" ]
then
    if cd "$HOME"
    then
        chdir=true
    else
        echo "No home directory: $HOME" 1>&2
    fi
fi


# Preload some commands via the bash history
if :
then
    cat << COMMANDS > "$HOME/.bash_history"
id
COMMANDS
fi


# Ensure that user can write into home
for i in "$HOME" "$HOME/.bash_history"
do
    [ -e "$i" ] && /usr/bin/chown user:users "$i" 2>/dev/null
done


# ------------------------------
# Final prelaunch, for simpleide

# Native graphics or death
export QT_GRAPHICSSYSTEM=native

# Full write permission for all users (ie, us)
for i in /dev/ttyUSB*
do
    if [ -e "$i" ]
    then
        chmod o+rw "$i"
    fi
done
# ------------------------------


chroot=/usr/bin/chroot
[ -x /usr/sbin/chroot ] && chroot=/usr/sbin/chroot

# Ugly
# (centos/RedHat < 8) does not have --skip-chdir
# so avoid that, and add 'cd ...' into the history for some convenience
if [ -f /etc/redhat-release ] \
&& grep -q 'VERSION_ID="7"' /etc/os-release 2>/dev/null
then
    [ "$chdir" = true ] && echo "cd $PWD" >> "$HOME/.bash_history"

    exec "$chroot" --userspec=user:users / "$@"
else
    exec "$chroot" --userspec=user:users --skip-chdir / "$@"
fi

# ----------------------------------------------------------------------------

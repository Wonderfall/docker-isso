#!/bin/sh
chown -R $UID:$GID /db /config
CONFIGFILE=/config/isso.conf
if test -f "$CONFIGFILE"; then
    exec su-exec $UID:$GID /sbin/tini -- isso -c $CONFIGFILE run
else
    echo "The configuration file $CONFIGFILE was not found."
    exit
fi

#!/bin/bash -x

# Bash options for strict error checking
set -o errexit -o errtrace -o pipefail -o nounset

# Trace all commands
set -o xtrace

set -e

ADM_SCRIPTS_PATH="/adm-scripts"

if [[ -d "$ADM_SCRIPTS_PATH/.git" ]]; then
    echo "Kurento 'adm-scripts' found in $ADM_SCRIPTS_PATH"
else
    echo "Kurento 'adm-scripts' not found in $ADM_SCRIPTS_PATH"
    echo "Clone 'adm-scripts' from Git repo..."
    git clone https://github.com/Kurento/adm-scripts.git "$ADM_SCRIPTS_PATH"
fi

if [ -n "$KMS_TURN_URL" ]; then
  echo "turnURL=$KMS_TURN_URL" > /etc/kurento/modules/kurento/WebRtcEndpoint.conf.ini
fi

if [ -n "$KMS_STUN_IP" -a -n "$KMS_STUN_PORT" ]; then
  # Generate WebRtcEndpoint configuration
  echo "stunServerAddress=$KMS_STUN_IP" > /etc/kurento/modules/kurento/WebRtcEndpoint.conf.ini
  echo "stunServerPort=$KMS_STUN_PORT" >> /etc/kurento/modules/kurento/WebRtcEndpoint.conf.ini
fi

# görmezse coturn için /etc/turnserver.conf a

echo "listening-port=$LISTENING_PORT" > /usr/local/etc/turnserver.conf
echo "tls-listening-port=$TLS_LISTENING_PORT" >> /usr/local/etc/turnserver.conf
echo "alt-listening-port=$ALT_LISTENING_PORT" >> /usr/local/etc/turnserver.conf
echo "listening-ip=$ip_addr" >> /usr/local/etc/turnserver.conf
echo "aux-server=$AUX" >> /usr/local/etc/turnserver.conf
echo "relay-ip=$ip_addr" >> /usr/local/etc/turnserver.conf
echo "user=$TURN_USERNAME:$TURN_PASSWORD" >> /usr/local/etc/turnserver.conf
echo "userdb=$USER_DB" >>/usr/local/etc/turnserver.conf
echo "realm=$REALM" >> /usr/local/etc/turnserver.conf
echo 'log-file stdout' >> /usr/local/etc/turnserver.conf
echo "cert=$CERT" >> /usr/local/etc/turnserver.conf
echo "min-port=$MIN_PORT" >> /usr/local/etc/turnserver.conf
echo "max-port=$MAX_PORT" >> /usr/local/etc/turnserver.conf
echo "pkey=$PKEY" >> /usr/local/etc/turnserver.conf
echo "pidfile=$PID_FILE" >> /usr/local/etc/turnserver.conf
echo "cli-ip=127.0.0.1" >> /usr/local/etc/turnserver.conf
echo "cli-password=CHANGE_ME" >> /usr/local/etc/turnserver.conf
echo "Verbose fingerprint lt-cred-mech no-cli secure-stun simple-log" >>/usr/local/etc/turnserver.conf
echo "TURNSERVER_ENABLED=1" >> /etc/default/coturn

BASENAME="$(basename "$0")"  # Complete file name
echo "[$BASENAME] Debian packages:"
find . -maxdepth 1 -type f -name '*.*deb'

# Get results out from the Docker container
if [[ -d /hostdir ]]; then
    mv ./*.*deb /hostdir/ 2>/dev/null || true
else
    echo "WARNING: No host dir where to put built packages"
fi

# Remove ipv6 local loop until ipv6 is supported
cat /etc/hosts | sed '/::1/d' | tee /etc/hosts > /dev/null

exec /usr/bin/kurento-media-server "$@"

# Adding first user
turnadmin -a -b /usr/local/var/db/turndb -u $TURN_USERNAME -r $REALM -p $TURN_PASSWORD

# Starting coturn
/turnserver-4.5.1.1/bin/turnserver --no-cli >>/var/log/turnserver.log 2>&1


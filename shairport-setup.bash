# Install dependencies
echo "Installing dependencies…"

apt install --no-install-recommends build-essential git xmltoman autoconf automake libtool \
    libpopt-dev libconfig-dev libasound2-dev avahi-daemon libavahi-client-dev libssl-dev libsoxr-dev libglib2.0-dev \
    libplist-dev libsodium-dev libavutil-dev libavcodec-dev libavformat-dev uuid-dev libgcrypt-dev

# Install nqptp
echo "Installing nqptp…"

git clone https://github.com/mikebrady/nqptp.git
cd nqptp
autoreconf -fi
./configure
make
make install

# Start nqptp daemon
echo "Starting nqptp…"

systemctl enable nqptp
systemctl start nqptp

# Install shairport-sync
echo "Installing shairport-sync…"

git clone https://github.com/mikebrady/shairport-sync.git
cd shairport-sync
git checkout development
autoreconf -fi
./configure --sysconfdir=/etc --with-alsa \
    --with-soxr --with-avahi --with-ssl=openssl --with-systemd --with-dbus-interface --with-airplay-2
make -j
make install

# Start shairport-sync
echo "Starting shairpot-sync…"

systemctl enable shairport-sync
systemctl start shairport-sync
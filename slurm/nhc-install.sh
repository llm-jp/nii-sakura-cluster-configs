mkdir -p /opt/nhc
VER=1.4.3
wget https://github.com/mej/nhc/releases/download/$VER/lbnl-nhc-$VER.tar.xz -O /opt/nhc/lbnl-nhc.tar.xz
cd /opt/nhc
tar -xvf lbnl-nhc.tar.xz
cd lbnl-nhc-$VER
./configure --prefix=/opt/nhc --sysconfdir=/etc --libexecdir=/usr/libexec
make test
make install

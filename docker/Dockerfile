FROM rockylinux/rockylinux:9

#
# cb base
#
RUN dnf install -y sudo git

RUN dnf install -y apr-devel bison bzip2-devel cmake3 diffutils flex gcc gcc-c++ glibc-langpack-en glibc-locale-source iproute krb5-devel libcurl-devel libevent-devel libxml2-devel libuuid-devel libzstd-devel lz4-devel net-tools openldap-devel openssl-devel openssh-server pam-devel perl perl-ExtUtils-Embed perl-Test-Simple perl-Env python3-devel python3-pip readline-devel rsync wget which zlib-devel

RUN dnf install -y --enablerepo=crb libuv-devel libyaml-devel perl-IPC-Run protobuf-devel

RUN useradd -U -m -s /bin/bash gpadmin

RUN echo 'gpadmin ALL=(ALL) NOPASSWD:ALL' | tee /etc/sudoers.d/90-gpadmin

RUN echo "compile and install xerces-c" && \ 
  XERCES_LATEST_RELEASE=3.3.0 && \
  XERCES_INSTALL_PREFIX="/usr/local/xerces-c" && \
  wget -nv "https://dlcdn.apache.org//xerces/c/3/sources/xerces-c-${XERCES_LATEST_RELEASE}.tar.gz" && \
  echo "$(curl -sL https://dlcdn.apache.org//xerces/c/3/sources/xerces-c-${XERCES_LATEST_RELEASE}.tar.gz.sha256)" | sha256sum -c - && \
  tar xf "xerces-c-${XERCES_LATEST_RELEASE}.tar.gz" && \
  rm "xerces-c-${XERCES_LATEST_RELEASE}.tar.gz" && \
  cd xerces-c-${XERCES_LATEST_RELEASE} && \
  ./configure --prefix="${XERCES_INSTALL_PREFIX}-${XERCES_LATEST_RELEASE}" && \
  make -j$(nproc) && \
  make check && \
  make install && \
  ln -s ${XERCES_INSTALL_PREFIX}-${XERCES_LATEST_RELEASE} ${XERCES_INSTALL_PREFIX}

USER gpadmin
RUN echo "Download Source Code (2.x branch)" && \
  git clone https://github.com/apache/cloudberry.git ~/cloudberry && \
  cd ~/cloudberry && \
  git fetch --tags && \
  git checkout tags/2.0.0-incubating && \
  git submodule update --init --recursive

RUN echo "Prepare the build environment for Apache Cloudberry" && \
  sudo rm -rf /usr/local/cloudberry-db && \
  sudo chmod a+w /usr/local && \
  mkdir -p /usr/local/cloudberry-db/lib && \
  sudo cp -v /usr/local/xerces-c/lib/libxerces-c.so /usr/local/xerces-c/lib/libxerces-c-3.*.so /usr/local/cloudberry-db/lib && \
  sudo chown -R gpadmin:gpadmin /usr/local/cloudberry-db

RUN echo "Run configure" && \
  cd ~/cloudberry && \
  export LD_LIBRARY_PATH=/usr/local/cloudberry-db/lib:LD_LIBRARY_PATH && \
  ./configure --prefix=/usr/local/cloudberry-db \
            --disable-external-fts \
            --enable-debug \
            --enable-cassert \
            --enable-debug-extensions \
            --enable-gpcloud \
            --enable-ic-proxy \
            --enable-mapreduce \
            --enable-orafce \
            --enable-orca \
            --enable-pax \
            --enable-pxf \
            --enable-tap-tests \
            --with-gssapi \
            --with-ldap \
            --with-libxml \
            --with-lz4 \
            --with-pam \
            --with-perl \
            --with-pgport=5432 \
            --with-python \
            --with-pythonsrc-ext \
            --with-ssl=openssl \
            --with-uuid=e2fs \
            --with-includes=/usr/local/xerces-c/include \
            --with-libraries=/usr/local/cloudberry-db/lib

RUN echo "Build and install Cloudberry and its contrib modules" && \
  make -j$(nproc) -C ~/cloudberry && \
  make -j$(nproc) -C ~/cloudberry/contrib && \
  make install -C ~/cloudberry && \
  make install -C ~/cloudberry/contrib


#
# gis base
#
#FROM rockylinux9-cb:base

RUN sudo dnf install -y epel-release 
  
RUN sudo dnf install -y libtool boost-devel gmp-devel mpfr-devel \
      pcre-devel  protobuf-c bzip2 gcc make subversion gcc-c++ \
      sqlite-devel libxml2-devel  expat-devel libcurl-devel \
      json-c python3-devel 

RUN sudo dnf install -y --enablerepo=crb protobuf protobuf-devel protobuf-c-devel swig 

RUN sudo dnf install -y --enablerepo=epel proj-devel

#
# gis gdal
#
#FROM rockylinux9-gis:base 

RUN cd ~/ && git clone https://github.com/OSGeo/gdal.git

RUN echo "build and install gdal" && \ 
  cd ~/gdal && \
  mkdir build && \
  cd build && \
  cmake --install-prefix /usr/local/gdal .. && \
  cmake --build . && \
  cmake --build . --target install

#
# gis cgal
#
#FROM rockylinux9-gis:gdal 

RUN cd ~/ && git clone https://github.com/CGAL/cgal.git

RUN echo "build and install cgal" && \ 
  cd ~/cgal && \
  mkdir build && \
  cd build && \
  cmake --install-prefix /usr/local/cgal .. && \
  cmake --build . && \
  cmake --build . --target install

#
# gis sfcgal
#
#FROM rockylinux9-gis:cgal 

RUN cd ~/ && git clone https://gitlab.com/sfcgal/SFCGAL.git 

RUN echo "build and install sfcgal" && \ 
  cd ~/SFCGAL && \
  mkdir build && \
  cd build && \
  cmake --install-prefix /usr/local/sfcgal .. && \
  cmake --build . && \
  cmake --build . --target install

#
# gis geos
#
#FROM rockylinux9-gis:sfcgal 

RUN cd ~/ && git clone https://github.com/libgeos/geos.git 

RUN echo "build and install geos" && \ 
  cd ~/geos && \
  mkdir build && \
  cd build && \
  cmake --install-prefix /usr/local/geos .. && \
  cmake --build . && \
  cmake --build . --target install

#
# gis postgis
#
#FROM rockylinux9-gis:geos 

RUN cd ~/ && git clone https://gitea.osgeo.org/postgis/postgis.git

RUN cat << EOF | sudo tee -a /etc/ld.so.conf
/usr/lib/
/usr/lib64/
/usr/local/sfcgal/lib64/
/usr/local/gdal/lib/
/usr/local/geos/lib64/
EOF

RUN sudo ldconfig

RUN echo "build and install postgis" && \
  cd ~/postgis && \
  ./autogen.sh && \
  ./configure --with-pgconfig="${GPHOME}"/usr/local/cloudberry-db/bin/pg_config \
    --with-raster --without-topology \
    --with-gdalconfig=/usr/local/gdal/bin/gdal-config \
    --with-sfcgal=/usr/local/sfcgal/bin/sfcgal-config \
    --with-geosconfig=/usr/local/geos/bin/geos-config && \
  make -j$(nproc) && sudo make -j$(nproc) install

#
# setup gpadmin
#
#FROM rockylinux9-gis:postgis

RUN cd ~/ && rm -fr SFCGAL cgal cloudberry gdal geos postgis

RUN cat << EOF >> /home/gpadmin/.bashrc 
# Add Cloudberry entries
if [ -f /usr/local/cloudberry-db/greenplum_path.sh ]; then
  source /usr/local/cloudberry-db/greenplum_path.sh
fi
## US English with UTF-8 character encoding
export LANG=en_US.UTF-8
EOF

RUN echo "Set up SSH for passwordless access" && \
  mkdir -p /home/gpadmin/.ssh && \
  ssh-keygen -t rsa -b 2048 -C 'apache-cloudberry-dev' -f /home/gpadmin/.ssh/id_rsa -N "" && \
  cat /home/gpadmin/.ssh/id_rsa.pub >> /home/gpadmin/.ssh/authorized_keys && \
  chmod 700 /home/gpadmin/.ssh && \
  chmod 600 /home/gpadmin/.ssh/authorized_keys && \
  chmod 644 /home/gpadmin/.ssh/id_rsa.pub

RUN sudo yum clean all \
    && sudo rm -rf /var/cache/yum


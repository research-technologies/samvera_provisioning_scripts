#!/bin/bash

##################
# Install ffmpeg #
##################
echo 'installing ffmpeg'
echo 'this is going to take a while, hang tight!'
# Via https://trac.ffmpeg.org/wiki/CompilationGuide/Centos

# These are required for compiling, but you can remove them when you are done if you prefer (except make; it should be installed by default and many things depend on it).
yes | yum install -y autoconf automake bzip2 cmake freetype-devel gcc gcc-c++ git libtool make mercurial pkgconfig zlib-devel

mkdir /usr/local/ffmpeg
mkdir /usr/local/ffmpeg/ffmpeg_sources

# NASM

cd /usr/local/ffmpeg/ffmpeg_sources
curl -O -L http://www.nasm.us/pub/nasm/releasebuilds/2.13.02/nasm-2.13.02.tar.bz2
tar xjvf nasm-2.13.02.tar.bz2
cd nasm-2.13.02
./autogen.sh
./configure --prefix="/usr/local/ffmpeg/ffmpeg_build" --bindir="/usr/local/ffmpeg/bin"
make
make install

# YASM
cd /usr/local/ffmpeg/ffmpeg_sources
curl -O -L http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz
tar xzvf yasm-1.3.0.tar.gz
cd yasm-1.3.0
./configure --prefix="/usr/local/ffmpeg/ffmpeg_build" --bindir="/usr/local/ffmpeg/bin"
make
make install

sudo ln -s /usr/local/ffmpeg/bin/nasm /usr/bin/nasm
sudo ln -s /usr/local/ffmpeg/bin/ndisasm /usr/bin/ndisasm
sudo ln -s /usr/local/ffmpeg/bin/ytasm /usr/bin/ytasm
sudo ln -s /usr/local/ffmpeg/bin/vsyasm /usr/bin/vsyasm
sudo ln -s /usr/local/ffmpeg/bin/yasm /usr/bin/yasm

# libx264 
# Requires ffmpeg to be configured with --enable-gpl --enable-libx264
cd /usr/local/ffmpeg/ffmpeg_sources
git clone --depth 1 http://git.videolan.org/git/x264
cd x264
PKG_CONFIG_PATH="/usr/local/ffmpeg/ffmpeg_build/lib/pkgconfig" ./configure --prefix="/usr/local/ffmpeg/ffmpeg_build" --bindir="/usr/local/ffmpeg/bin" --enable-static
make
make install

sudo ln -s /usr/local/ffmpeg/bin/x264 /usr/bin/x264

# libx265
# Requires ffmpeg to be configured with --enable-gpl --enable-libx265.
cd /usr/local/ffmpeg/ffmpeg_sources
hg clone https://bitbucket.org/multicoreware/x265
cd /usr/local/ffmpeg/ffmpeg_sources/x265/build/linux
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="/usr/local/ffmpeg/ffmpeg_build" -DENABLE_SHARED:bool=off ../../source
make
make install

# libfdk_aac
# Requires ffmpeg to be configured with --enable-libfdk_aac (and --enable-nonfree if you also included --enable-gpl). 

cd /usr/local/ffmpeg/ffmpeg_sources
git clone --depth 1 https://github.com/mstorsjo/fdk-aac
cd fdk-aac
autoreconf -fiv
./configure --prefix="/usr/local/ffmpeg/ffmpeg_build" --disable-shared
make
make install

# libmp3lame
# Requires ffmpeg to be configured with --enable-libmp3lame. 

cd /usr/local/ffmpeg/ffmpeg_sources
curl -O -L http://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
tar xzvf lame-3.100.tar.gz
cd lame-3.100
./configure --prefix="/usr/local/ffmpeg/ffmpeg_build" --bindir="/usr/local/ffmpeg/bin" --disable-shared --enable-nasm
make
make install

sudo ln -s /usr/local/ffmpeg/bin/lame /usr/bin/lame

# libopus
# Requires ffmpeg to be configured with --enable-libopus. 

cd /usr/local/ffmpeg/ffmpeg_sources
curl -O -L https://archive.mozilla.org/pub/opus/opus-1.2.1.tar.gz
tar xzvf opus-1.2.1.tar.gz
cd opus-1.2.1
./configure --prefix="/usr/local/ffmpeg/ffmpeg_build" --disable-shared
make
make install

# libogg

cd /usr/local/ffmpeg/ffmpeg_sources
curl -O -L http://downloads.xiph.org/releases/ogg/libogg-1.3.3.tar.gz
tar xzvf libogg-1.3.3.tar.gz
cd libogg-1.3.3
./configure --prefix="/usr/local/ffmpeg/ffmpeg_build" --disable-shared
make
make install

# libvorbis 

cd /usr/local/ffmpeg/ffmpeg_sources
curl -O -L http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.gz
tar xzvf libvorbis-1.3.5.tar.gz
cd libvorbis-1.3.5
./configure --prefix="/usr/local/ffmpeg/ffmpeg_build" --with-ogg="/usr/local/ffmpeg/ffmpeg_build" --disable-shared
make
make install

# libtheora 
# Requires ffmpeg to be configured with --enable-libtheora. 

d /usr/local/ffmpeg/ffmpeg_sources
curl -O -L https://ftp.osuosl.org/pub/xiph/releases/theora/libtheora-1.1.1.tar.gz
tar xzvf libtheora-1.1.1.tar.gz
cd libtheora-1.1.1
./configure --prefix="/usr/local/ffmpeg/ffmpeg_build" --with-ogg="/usr/local/ffmpeg/ffmpeg_build" --disable-shared
make
make install

# libvpx 
# Requires ffmpeg to be configured with --enable-libvpx.

cd /usr/local/ffmpeg/ffmpeg_sources
git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git
cd libvpx
./configure --prefix="/usr/local/ffmpeg/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm
make
make install

# FFMPEG

cd /usr/local/ffmpeg/ffmpeg_sources
curl -O -L https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
tar xjvf ffmpeg-snapshot.tar.bz2
cd ffmpeg
PATH="/usr/local/ffmpeg/bin:$PATH" PKG_CONFIG_PATH="/usr/local/ffmpeg/ffmpeg_build/lib/pkgconfig" ./configure \
  --prefix="/usr/local/ffmpeg/ffmpeg_build" \
  --pkg-config-flags="--static" \
  --extra-cflags="-I/usr/local/ffmpeg/ffmpeg_build/include" \
  --extra-ldflags="-L/usr/local/ffmpeg/ffmpeg_build/lib" \
  --extra-libs=-lpthread \
  --extra-libs=-lm \
  --bindir="/usr/local/ffmpeg/bin" \
  --enable-gpl \
  --enable-libfdk_aac \
  --enable-libfreetype \
  --enable-libmp3lame \
  --enable-libopus \
  --enable-libvorbis \
  --enable-libtheora \
  --enable-libvpx \
  --enable-libx264 \
  --enable-libx265 \
  --enable-nonfree
 
make
make install
hash -r

sudo chmod 755 /usr/local/ffmpeg

sudo ln -s /usr/local/ffmpeg/bin/ffmpeg /usr/bin/ffprobe
sudo ln -s /usr/local/ffmpeg/bin/ffmpeg /usr/bin/ffmpeg



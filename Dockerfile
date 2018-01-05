FROM debian:stretch

RUN dpkg --add-architecture i386 \
	&& apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y --no-install-recommends \
		ca-certificates \
		wget \
		g++-multilib \
		make \
		git \
		unzip \
		vim \
		less \
		man \
		libssl-dev:i386 \
		libmariadb-dev:i386

WORKDIR /root

RUN mkdir /root/downloads \
	# install new CMake
	&& cd /root/downloads \
	&& wget https://cmake.org/files/v3.9/cmake-3.9.1-Linux-x86_64.sh \
	&& chmod +x cmake-3.9.1-Linux-x86_64.sh \
	&& ./cmake-3.9.1-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir \
	# Boost
	&& wget https://dl.bintray.com/boostorg/release/1.65.1/source/boost_1_65_1.tar.gz \
	&& tar xfz boost_1_65_1.tar.gz \
	&& cd boost_1_65_1 \
	&& ./bootstrap.sh --prefix=/usr/local --with-libraries=system,chrono,thread,regex,date_time,atomic \
	&& ./b2 variant=release link=static threading=multi address-model=32 runtime-link=shared -j2 install \
	# SA-MP server + includes
	&& wget http://files.sa-mp.com/samp037svr_R2-1.tar.gz \
	&& tar xfz samp037svr_R2-1.tar.gz \
	&& wget http://files.sa-mp.com/samp037_svr_R2-1-1_win32.zip \
	&& unzip samp037_svr_R2-1-1_win32.zip pawno/include/* \
	&& mv pawno/ samp03/ \
	&& mv samp03/ /root \
	# PAWN compiler
	&& PAWN_COMPILER_VERSION=3.10.2 \
	&& wget https://github.com/Southclaws/pawn/releases/download/v${PAWN_COMPILER_VERSION}/pawnc-${PAWN_COMPILER_VERSION}-linux.tar.gz \
	&& tar xfz pawnc-${PAWN_COMPILER_VERSION}-linux.tar.gz \
	&& mv pawnc-${PAWN_COMPILER_VERSION}-linux/bin/* /usr/local/bin \
	&& mv pawnc-${PAWN_COMPILER_VERSION}-linux/lib/* /usr/local/lib \
	&& ldconfig \
	# delete download folder
	&& cd /root \
	&& rm -rf /root/downloads

COPY .bashrc /root

CMD ["/bin/bash"]

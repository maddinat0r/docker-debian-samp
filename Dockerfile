FROM debian:jessie

RUN dpkg --add-architecture i386 \
	&& apt update \
	&& apt install -y --no-install-recommends \
		ca-certificates \
		wget \
		g++-multilib \
		make \
		git \
		libssl-dev:i386 \
		unzip \
		vim \
		less \
		man \
		libmysqlclient-dev:i386 \
	# other things
	&& mkdir /root/downloads \
	# install new CMake
	&& cd /root/downloads \
	&& wget https://cmake.org/files/v3.9/cmake-3.9.1-Linux-x86_64.sh \
	&& chmod +x cmake-3.9.1-Linux-x86_64.sh \
	&& ./cmake-3.9.1-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir \
	# Boost
	&& wget https://dl.bintray.com/boostorg/release/1.65.0/source/boost_1_65_0.tar.gz \
	&& tar xfz boost_1_65_0.tar.gz \
	&& cd boost_1_65_0 \
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
	&& wget https://github.com/Zeex/pawn/releases/download/v3.10.2/pawnc-3.10.2-linux.tar.gz \
	&& tar xfz pawnc-3.10.2-linux.tar.gz \
	&& mv pawnc-3.10.2-linux/bin/* /usr/local/bin \
	&& mv pawnc-3.10.2-linux/lib/* /usr/local/lib \
	&& ldconfig \
	# delete download folder
	&& cd /root \
	&& rm -rf /root/downloads \
	# create output folder for volume mounting
	&& mkdir /opt/output

VOLUME /opt/output
COPY .bashrc /root

CMD ["/bin/bash"]

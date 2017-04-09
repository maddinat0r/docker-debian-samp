FROM debian:jessie

RUN dpkg --add-architecture i386 \
	&& apt update \
	&& apt install -y --no-install-recommends \
		ca-certificates \
		wget \
		g++-multilib \
		make \
		git \
		libssl-dev:i386

WORKDIR /root/downloads
RUN wget https://cmake.org/files/v3.7/cmake-3.7.2-Linux-x86_64.sh \
	&& chmod +x cmake-3.7.2-Linux-x86_64.sh \
	&& ./cmake-3.7.2-Linux-x86_64.sh --prefix=/usr/local --exclude-subdir \
	&& rm -rf /root/downloads

WORKDIR /root/downloads
RUN wget https://sourceforge.net/projects/boost/files/boost/1.63.0/boost_1_63_0.tar.gz \
	&& tar xfz boost_1_63_0.tar.gz \
	&& cd boost_1_63_0 \
	&& ./bootstrap.sh --prefix=/usr/local --with-libraries=system,chrono,thread,regex,date_time,atomic \
	&& ./b2 variant=release link=static threading=multi address-model=32 runtime-link=shared -j2 install \
	&& rm -rf /root/downloads

RUN mkdir /opt/output
VOLUME /opt/output
COPY .bashrc /root

CMD ["/bin/bash"]

# hashcat: World's fastest and most advanced password recovery utility
# https://hashcat.net/hashcat/
# hashcat is licensed under the MIT license.

# docker build -t hashcat .
# docker run --runtime=nvidia --init -ti --rm hashcat

FROM nvidia/opencl:devel-ubuntu16.04

RUN  sed -i "/^# deb.*multiverse/ s/^# //" /etc/apt/sources.list  && \
	apt-get update && apt-get install -y --no-install-recommends \
    	ca-certificates \
    	git \
    	p7zip-rar \
    	p7zip-full \
    	unrar \
    	plzip \
    	wget \
    	cron \
    	unison \
    	ssh \
	build-essential && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root/hashcat

RUN git clone https://github.com/hashcat/hashcat.git . && \
    git submodule update --init && \
    make install

RUN  wget "https://labor-backup.fra1.digitaloceanspaces.com/Super-WPA.txt.lz?AWSAccessKeyId=T2BTXTL2OD6KYF5FJVMB&Expires=1565464944&Signature=klqXgaFUezOct3VvPHDxq4p0rec%3D" -O Super-WPA.txt.lz
RUN  wget "https://labor-backup.fra1.digitaloceanspaces.com/Custom-WPA.txt.lz?AWSAccessKeyId=T2BTXTL2OD6KYF5FJVMB&Expires=1565464964&Signature=oITrHLrlt5szUu7LGF9I1M9fSaY%3D" -O Custom-WPA.txt.lz
RUN  wget "https://labor-backup.fra1.digitaloceanspaces.com/premium_gigant.txt.lz?AWSAccessKeyId=T2BTXTL2OD6KYF5FJVMB&Expires=1565464984&Signature=uEe1XwyDUqYFK2sZfhmxcwuWbNA%3D" -O premium_gigant.txt.lz
#RUN  plzip  -d -v  Super-WPA.txt.lz

run echo '* * * * * /usr/bin/unison hashcat &> /dev/null' | crontab

ADD hashcat.prf /root/.unison/
ADD id_rsa /root/.ssh/

CMD tail -F /var/log/dmesg

# ENTRYPOINT ["hashcat"]

# CMD ["--benchmark", "--benchmark-all", "--optimized-kernel-enable"]

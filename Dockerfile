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

#RUN  wget "https://labor-backup.fra1.digitaloceanspaces.com/Super-WPA.txt.lz?AWSAccessKeyId=T2BTXTL2OD6KYF5FJVMB&Expires=1565736220&Signature=jUfbWSFp0aaf7i%2FcJc7fVXFqAVs%3D" -O Super-WPA.txt.lz
#RUN  wget "https://labor-backup.fra1.digitaloceanspaces.com/Custom-WPA.txt.lz?AWSAccessKeyId=T2BTXTL2OD6KYF5FJVMB&Expires=1565736237&Signature=2OMB2KWaK2RC4CbyMVQVLli%2B2vA%3D" -O Custom-WPA.txt.lz
#RUN  wget "https://labor-backup.fra1.digitaloceanspaces.com/premium_gigant.txt.lz?AWSAccessKeyId=T2BTXTL2OD6KYF5FJVMB&Expires=1565736254&Signature=%2Bd%2Bc7h8oYhMUQgxgZ0CiwxP4v60%3D" -O premium_gigant.txt.lz
#RUN wget "https://labor-backup.fra1.digitaloceanspaces.com/Top1pt8Billion-WPA-probable-v2.txt.lz?AWSAccessKeyId=T2BTXTL2OD6KYF5FJVMB&Expires=1565736305&Signature=aQPBmXcCGoeshiBer3eB3q0Dp9Y%3D" -O Top1pt8Billion-WPA-probable-v2.txt.lz
#RUN  plzip  -d -v  Super-WPA.txt.lz

run echo '* * * * * /usr/bin/unison hashcat &> /dev/null' | crontab

ADD hashcat.prf /root/.unison/
ADD id_rsa /root/.ssh/

CMD tail -F /var/log/dmesg

# ENTRYPOINT ["hashcat"]

# CMD ["--benchmark", "--benchmark-all", "--optimized-kernel-enable"]

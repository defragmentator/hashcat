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
    	p7zip \
    	unrar \
    	wget \
	build-essential && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root/hashcat

RUN git clone https://github.com/hashcat/hashcat.git . && \
    git submodule update --init && \
    make install

RUN wget "https://fra1.digitaloceanspaces.com/labor-backup/WPA-PSK%20WORDLIST%203%20Final%20%2813%20GB%29.rar"    
#RUN  wget "https://labor-backup.fra1.digitaloceanspaces.com/polish.txt?AWSAccessKeyId=T2BTXTL2OD6KYF5FJVMB&Expires=1564697273&Signature=FJ37kPPTB%2FLAyDGrNm%2BmAKham10%3D" -O polish.txt
#    wget https://fra1.digitaloceanspaces.com/labor-backup/WPA-PSK%20WORDLIST%203%20Final%20%2813%20GB%29.rar

CMD ["/bin/tailf","/var/log/dmesg"]

# ENTRYPOINT ["hashcat"]

# CMD ["--benchmark", "--benchmark-all", "--optimized-kernel-enable"]

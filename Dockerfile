# hashcat: World's fastest and most advanced password recovery utility
# https://hashcat.net/hashcat/
# hashcat is licensed under the MIT license.

# docker build -t hashcat .
# docker run --runtime=nvidia --init -ti --rm hashcat

FROM nvidia/opencl:devel-ubuntu16.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    	ca-certificates \
    	git \
	build-essential && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root/hashcat

RUN git clone https://github.com/hashcat/hashcat.git . && \
    git submodule update --init && \
    make install

RUN wget https://fra1.digitaloceanspaces.com/labor-backup/WPA-PSK%20WORDLIST%203%20Final%20%2813%20GB%29.rar

CMD ["/bin/tailf","/var/log/dmesg"]

# ENTRYPOINT ["hashcat"]

# CMD ["--benchmark", "--benchmark-all", "--optimized-kernel-enable"]

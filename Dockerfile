FROM lazynode/lazyneo:v3.4.0

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | /bin/bash 
RUN git clone https://github.com/neoburger/statistics-plugin.git --depth=1 -b main --single-branch /tmp/statistics && cd /tmp/statistics && dotnet build -c Release -o /neo/Plugins/statistics && rm -rf /tmp/* && apt-get clean

COPY sync.sh /sync.sh
WORKDIR /app
CMD /bin/bash /sync.sh

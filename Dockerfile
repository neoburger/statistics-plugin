# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:6.0-jammy

# git clone && publish
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install --assume-yes apt-utils
RUN apt-get install -y libleveldb-dev sqlite3 libsqlite3-dev libunwind8-dev
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | /bin/bash

RUN git clone https://github.com/neo-project/neo-node.git --depth=1 -b v3.4.0 --single-branch .node
RUN git clone https://github.com/neo-project/neo-modules.git --depth=1 -b v3.4.0 --single-branch .modules
RUN git clone https://github.com/neoburger/statistics-plugin.git --depth=1 -b main --single-branch .statistics
RUN cd .node/neo-cli && dotnet restore && cd ../..
RUN cd .modules/src/LevelDBStore && dotnet restore && cd ../../..
RUN cd .statistics && dotnet restore && cd ..
RUN cd .node/neo-cli && dotnet publish -c Release && cd ../..
RUN cd .modules/src/LevelDBStore && dotnet publish -c Release && cd ../../..
RUN cd .statistics && dotnet publish -c Release && cd ..

# copy pulgin
RUN mkdir -p .node/neo-cli/bin/Release/net6.0/Plugins/LevelDBStore
RUN mkdir -p .node/neo-cli/bin/Release/net6.0/Plugins/statistics
RUN cp .modules/src/LevelDBStore/bin/Release/net6.0/LevelDBStore.dll .node/neo-cli/bin/Release/net6.0/Plugins/LevelDBStore/
RUN cp .statistics/bin/Release/net6.0/statistics.dll .node/neo-cli/bin/Release/net6.0/Plugins/statistics/

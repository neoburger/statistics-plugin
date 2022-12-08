FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

RUN git clone https://github.com/neoburger/statistics-plugin.git --depth=1 -b main --single-branch /tmp/statistics
RUN cd /tmp/statistics && dotnet build -c Release -o /neo/Plugins/statistics
RUN dotnet build -c Release -o /statistics

FROM lazynode/lazyneo:v3.5.0

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | /bin/bash

COPY --from=build /statistics /neo/Plugins/statistics
COPY sync.sh /sync.sh

WORKDIR /app
CMD /bin/bash /sync.sh

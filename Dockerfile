# Copyright (c) 2024 RFull Development
# This source code is managed under the MIT license. See LICENSE in the project root.
FROM hello-world:latest

# Install dependencies
RUN apt update && \
    apt install -y sudo git gnupg2 vim curl lsb-release

# Install development tools for root
ARG USER_NAME=developer
COPY ./shells/root/ ./shells/
RUN cd ./shells && \
    chmod +x *.sh && \
    ./create_user.sh ${USER_NAME}  && \
    ./install.sh && \
    cd ..
RUN rm -rf ./shells

# Switch to the non-root user
USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

# Install development tools for non-root
COPY --chown=${USER_NAME}:${USER_NAME} ./shells/user/ ./shells/
RUN cd ./shells && \
    chmod +x *.sh && \
    ./install.sh && \
    cd ..
RUN rm -rf ./shells

USER root

# Clean up
RUN apt clean && \
    rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/* && \
    rm -rf /var/tmp/*

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}

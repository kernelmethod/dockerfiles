# Builds a container image for C and C++ development.
#
# The build can go down one of two paths, based on the value of the CC argument.
# If CC=gcc, then gcc/g++ will be installed as the C / C++ compiler for the
# container. Otherwise, if CC=llvm, then LLVM will be installed.
FROM debian:buster

### General build arguments
ARG CC=llvm
ARG CC_USER=cc

### GCC build arguments

### LLVM build arguments
ARG LLVM_URL="http://apt.llvm.org/buster/"
ARG LLVM_REPOSITORY="llvm-toolchain-buster-9"
ARG INSTALL_CLANG=1
ARG INSTALL_LIBFUZZER=1
ARG INSTALL_LLDB=0
ARG INSTALL_LLD=1
ARG INSTALL_LIBCPP=1
ARG INSTALL_OPENMP=1

###############################
ADD build-scripts/ /tmp
RUN \
# Installs + upgrades that will be useful regardless of the value of CC.
    apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        cmake \
        less \
        man \
        man-db \
        sudo \
        vim \
#
# If CC=gcc, we execute the build-gcc.sh script. If CC=llvm, we execute
# build-llvm.sh. If CC doesn't match either of those, we error out.
    && \
        if [ "$CC" = "gcc" ]; then \
            echo "" > /dev/stderr; \
            echo "----------------------------------------------" > /dev/stderr; \
            echo "CC=gcc selected." > /dev/stderr; \
            echo "Building container image off of gcc." > /dev/stderr; \
            echo "----------------------------------------------" > /dev/stderr; \
            echo "" > /dev/stderr; \
            /tmp/build-gcc.sh; \
        elif [ "$CC" = "llvm" ]; then \
            echo "" > /dev/stderr; \
            echo "----------------------------------------------" > /dev/stderr; \
            echo "CC=llvm selected." > /dev/stderr; \
            echo "Building container image off of llvm." > /dev/stderr; \
            echo "----------------------------------------------" > /dev/stderr; \
            echo "" > /dev/stderr; \
            /tmp/build-llvm.sh; \
        else \
            echo "ERROR: build failed." \
                > /dev/stderr; \
            echo "CC=${CC} is invalid. You must specify either CC=gcc or CC=llvm." \
                > /dev/stderr; \
            exit 1; \
        fi \
#
# Cleanup steps common to both build scripts
    && apt-get autoremove -y \
    && apt-get purge \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*
###############################

# From here, the build finishes the same regardless of the value of CC
# Add a non-root user to write and compile code
RUN useradd \
        --shell /bin/shell \
        --home-dir /home/${CC_USER} \
        --create-home \
        --password "0" \
        --groups sudo \
        ${CC_USER}
COPY sudoers /etc/sudoers

USER ${CC_USER}
WORKDIR /home/${CC_USER}
RUN mkdir /home/${CC_USER}/work

# Specify additional environmental variables
ENV TERM=xterm-256color

CMD [ "/bin/bash" ]

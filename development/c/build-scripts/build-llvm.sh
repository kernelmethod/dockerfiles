#!/bin/sh

###
### Installs LLVM when the build argument CC=llvm is passed.
###
apt-get install -y gnupg wget

#
# Add the LLVM stable branch repository
wget \
    -O /tmp/llvm-snapshot.gpg.key \
    https://apt.llvm.org/llvm-snapshot.gpg.key
apt-key add /tmp/llvm-snapshot.gpg.key
echo "deb ${LLVM_URL} ${LLVM_REPOSITORY} main" \
    >> /etc/apt/sources.list

#
# Install packages for LLVM
apt-get update

LLVM=$(
echo "\
    libllvm-9-ocaml-dev \
    libllvm9 \
    llvm-9 \
    llvm-9-dev \
    llvm-9-doc \
    llvm-9-examples \
    llvm-9-runtime";
)

CLANG=$(
if [ $INSTALL_CLANG -eq 1 ]
then echo "\
    clang-9 \
    clang-tools-9 \
    clang-9-doc \
    libclang-common-9-dev \
    libclang-9-dev \
    libclang1-9 \
    clang-format-9 \
    python-clang-9 \
    clangd-9";
fi)

LIBFUZZER=$(
if [ $INSTALL_LIBFUZZER -eq 1 ]
then echo "\
    libfuzzer-9-dev"; \
fi)

LLDB=$(if [ $INSTALL_LLDB -eq 1 ]
then echo "\
    lldb-9";
fi)

LLD=$(if [ $INSTALL_LLD -eq 1 ]
then echo "\
    lld-9";
fi)

LIBCPP=$(
if [ $INSTALL_LIBCPP -eq 1 ]
then echo "\
    libc++-9-dev \
    libc++abi-9-dev";
fi)

OPENMP=$(if [ $INSTALL_OPENMP -eq 1 ]
then echo "\
    libomp-9-dev";
fi)

apt-get install -y \
    $LLVM \
    $CLANG \
    $LIBFUZZER \
    $LLDB \
    $LLD \
    $LIBCPP \
    $OPENMP

# Add some symlinks to make life easier
ln -s \
    $(which clang-9) \
    $(dirname $(which clang-9))/clang
ln -s \
    $(which clang++-9) \
    $(dirname $(which clang-9))/clang++

# Cleanup
apt-get remove -y wget gnupg

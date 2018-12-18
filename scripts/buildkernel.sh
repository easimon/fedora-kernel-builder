#!/bin/bash

set -eu

pushd $HOME/rpmbuild/SRPMS \
  && dnf download --source kernel \
  && rpm -i kernel*rpm ; popd

cp $HOME/rpmbuild/PATCHES/*.diff $HOME/rpmbuild/SOURCES/

pushd $HOME/rpmbuild/SPECS \
  && patch -p1 < ../PATCHES/kernel.spec.patch \
  && time rpmbuild -bb --with verbose --without debuginfo --without debug --target=$(uname -m) kernel.spec ; popd

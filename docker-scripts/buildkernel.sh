#!/bin/bash

set -eu

df -h

pushd $HOME/rpmbuild/SRPMS \
  && dnf download --source kernel \
  && rpm -i kernel*rpm ; popd

cp $HOME/rpmbuild/PATCHES/*.patch $HOME/rpmbuild/SOURCES/

pushd $HOME/rpmbuild/SPECS \
  && patch -p1 < ../PATCHES/kernel.spec.diff \
  && time rpmbuild -bb --without verbose --without debuginfo --without debug --target=$(uname -m) kernel.spec ; popd

#pushd $HOME/rpmbuild/SPECS \
#  && time rpmbuild -bb --without verbose --without debuginfo --without debug --target=$(uname -m) kernel.spec ; popd

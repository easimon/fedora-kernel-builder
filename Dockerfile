FROM fedora:28

ARG DOCKERUSERUID=1000
ARG DOCKERUSERGID=1000
ARG DOCKERUSER=builder
ARG USERHOME=/home/${DOCKERUSER}

RUN dnf update -y && dnf install -y \
  fedpkg \
  fedora-packager \
  rpmdevtools \
  ncurses-devel \
  pesign \
  bison \
  elfutils-devel \
  flex \
  openssl-devel \
  perl-devel \
  perl-generators \
  bc \
  gcc \
  git \ 
  hmaccalc \
  hostname \
  kmod \
  make \
  net-tools

RUN groupadd -g 1000 -r ${DOCKERUSER} \
  && useradd -g 1000 -r -u 1000 -m ${DOCKERUSER}

USER ${DOCKERUSER}
WORKDIR ${USERHOME}

RUN rpmdev-setuptree

COPY ./scripts/buildkernel.sh /usr/local/bin/

VOLUME [ "${USERHOME}/rpmbuild/BUILD" ] 
VOLUME [ "${USERHOME}/rpmbuild/PATCHES" ]
VOLUME [ "${USERHOME}/rpmbuild/RPMS" ]

ENTRYPOINT [ "/usr/local/bin/buildkernel.sh" ]

FROM fedora:37
LABEL maintainer=woodwardsh

ENV HOME=/home/app
ENV MODELDIR=/home/app/trunk/LMDZ.COMMON
# ENV OMPI_ALLOW_RUN_AS_ROOT=1
# ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
WORKDIR ${HOME}

# --- Install dependencies (layer shared with rocke3d image) ---
RUN dnf install -y gcc gcc-gfortran git nano wget which xz netcdf.x86_64 netcdf-fortran.x86_64 netcdf-devel.x86_64 netcdf-fortran-devel.x86_64 openmpi.x86_64 openmpi-devel.x86_64 'perl(File::Copy)'

# Ensure mpif90 in path
ENV PATH=$PATH:/usr/lib64/openmpi/bin

# --- Install LMD specific dependencies ---
RUN dnf install -y cmake g++ hostname ksh m4 svn task-spooler 'perl(File::Compare)' 'perl(FindBin)'

RUN svn co http://forge.ipsl.jussieu.fr/fcm/svn/PATCHED/FCM_V1.2

ENV PATH=$PATH:$HOME/FCM_V1.2/bin

# --- Download PCM ---
RUN svn co --revision HEAD http://svn.lmd.jussieu.fr/Planeto/trunk --depth empty trunk && \
    cd trunk && \
    svn update LMDZ.COMMON LMDZ.GENERIC DOC

# --- Update PCM architecture config ---
COPY src/trunk/LMDZ.COMMON/install_ioipsl_gfortran.bash /home/app/trunk/LMDZ.COMMON/ioipsl
COPY src/trunk/LMDZ.COMMON/arch-local.env /home/app/trunk/LMDZ.COMMON/arch
COPY src/trunk/LMDZ.COMMON/arch-local.path /home/app/trunk/LMDZ.COMMON/arch
COPY src/trunk/LMDZ.COMMON/arch-local.fcm /home/app/trunk/LMDZ.COMMON/arch

# --- Install IOIPSL ---
RUN cd /home/app/trunk/LMDZ.COMMON/ioipsl && \
    bash install_ioipsl_gfortran.bash

# --- Copy files + dirs ---
COPY src/runs /home/app/runs
COPY src/rootdatadir /home/app/rootdatadir
COPY src/startfiles/ /home/app/startfiles
COPY src/test-earth-aqua.sh .
COPY src/test-mars.sh .

FROM centos:6.9

# Declare build-time environment

# Miniconda
ARG MC_VERSION=4.3.21
ARG MC_PLATFORM=Linux
ARG MC_ARCH=x86_64
ARG MC_URL=https://repo.continuum.io/miniconda

# Conda root
ARG CONDA_VERSION=4.3.25
ARG CONDA_BUILD_VERSION=3.0.14
ARG CONDA_PACKAGES

# Declare environment
ENV OPT=/opt \
    HOME=/home/jenkins

ENV MC_VERSION=${MC_VERSION} \
    MC_PLATFORM=${MC_PLATFORM} \
    MC_ARCH=${MC_ARCH} \
    MC_URL=${MC_URL} \
    MC_INSTALLER=Miniconda3-${MC_VERSION}-${MC_PLATFORM}-${MC_ARCH}.sh \
    MC_PATH=${OPT}/conda \
    CONDA_VERSION=${CONDA_VERSION} \
    CONDA_BUILD_VERSION=${CONDA_BUILD_VERSION} \
    CONDA_PACKAGES=${CONDA_PACKAGES}

# Toolchain
RUN yum install -y \
        openssh-server \
        curl \
        wget \
        git \
        subversion \
        hg \
        java-1.8.0-openjdk-devel \
        gcc \
        gcc-c++ \
        gcc-gfortran \
        glibc-devel \
        kernel-devel \
        bzip2-devel \
        zlib-devel \
        ncurses-devel \
        libX11-devel \
        mesa-libGL \
        mesa-libGLU \
    && yum clean all

# SSH Server configuration
# Create 'jenkins' user
RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa \
    && ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa \
    && groupadd jenkins \
    && useradd -g jenkins -m -d $HOME -s /bin/bash jenkins \
    && echo "jenkins:jenkins" | chpasswd

# Install Miniconda
RUN curl -q -O ${MC_URL}/${MC_INSTALLER} \
    && bash ${MC_INSTALLER} -b -p ${MC_PATH} \
    && rm -rf ${MC_INSTALLER} \
    && echo export PATH="${MC_PATH}/bin:\${PATH}" > /etc/profile.d/conda.sh

# Configure Conda
# Reset permissions
ENV PATH "${MC_PATH}/bin:${PATH}"
RUN conda install --yes --quiet \
        conda=${CONDA_VERSION} \
        conda-build=${CONDA_BUILD_VERSION} \
        ${CONDA_PACKAGES} \
    && chown -R jenkins: ${OPT} ${HOME}

WORKDIR ${HOME}

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]


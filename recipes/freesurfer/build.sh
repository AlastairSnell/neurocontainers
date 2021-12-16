#!/usr/bin/env bash
set -e

if [ "$1" != "" ]; then
    echo "Entering Debug mode: -s=singularity; -ds=docker+singularity"
    echo $1
    export debug=$1
fi

export toolName='freesurfer'
export toolVersion=7.1.1
# Don't forget to update version change in README.md!!!!!

source ../main_setup.sh

neurodocker generate ${neurodocker_buildMode} \
   --base-image centos:8 \
   --pkg-manager yum \
   --run="printf '#!/bin/bash\nls -la' > /usr/bin/ll" \
   --run="chmod +x /usr/bin/ll" \
   --run="mkdir ${mountPointList}" \
   --run="yum upgrade -y dnf" \
   --run="yum upgrade -y rpm" \
   --install wget mesa-dri-drivers which unzip ncurses-compat-libs \
   --run="wget --quiet https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/${toolVersion}/freesurfer-CentOS8-${toolVersion}-1.x86_64.rpm" \
   --run="yum --nogpgcheck -y localinstall freesurfer-CentOS8-${toolVersion}-1.x86_64.rpm" \
   --run="ln -s /usr/local/freesurfer/${toolVersion}-1/ /opt/${toolName}-${toolVersion}" \
   --matlabmcr version=2014b install_path=/opt/MCR  \
   --run="ln -s /opt/MCR/v84/ /opt/${toolName}-${toolVersion}/MCRv84" \
   --env OS="Linux" \
   --env SUBJECTS_DIR="/opt/${toolName}-${toolVersion}/subjects" \
   --env LOCAL_DIR="/opt/${toolName}-${toolVersion}/local" \
   --env FSFAST_HOME="/opt/${toolName}-${toolVersion}/fsfast" \
   --env FMRI_ANALYSIS_DIR="/opt/${toolName}-${toolVersion}/fsfast" \
   --env FUNCTIONALS_DIR="/opt/${toolName}-${toolVersion}/sessions" \
   --env FIX_VERTEX_AREA="" \
   --env FSF_OUTPUT_FORMAT="nii.gz# mni env requirements" \
   --env MINC_BIN_DIR="/opt/${toolName}-${toolVersion}/mni/bin" \
   --env MINC_LIB_DIR="/opt/${toolName}-${toolVersion}/mni/lib" \
   --env MNI_DIR="/opt/${toolName}-${toolVersion}/mni" \
   --env MNI_DATAPATH="/opt/${toolName}-${toolVersion}/mni/data" \
   --env MNI_PERL5LIB="/opt/${toolName}-${toolVersion}/mni/share/perl5" \
   --env PERL5LIB="/opt/${toolName}-${toolVersion}/mni/share/perl5" \
   --env FREESURFER_HOME="/opt/${toolName}-${toolVersion}" \
   --env TERM=xterm \
   --env SHLVL=1 \
   --env FS_OVERRIDE=0 \
   --env PATH="/opt/${toolName}-${toolVersion}/bin:/opt/${toolName}-${toolVersion}/fsfast/bin:/opt/${toolName}-${toolVersion}/tktools:/opt/${toolName}-${toolVersion}/bin:/opt/${toolName}-${toolVersion}/fsfast/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/opt/${toolName}-${toolVersion}/mni/bin:/bin" \
   --env FREESURFER="/opt/${toolName}-${toolVersion}" \
   --env DEPLOY_PATH="/opt/${toolName}-${toolVersion}/bin/" \
   --env LD_LIBRARY_PATH="/usr/lib64/:/opt/${toolName}-${toolVersion}/MCRv84/runtime/glnxa64:/opt/${toolName}-${toolVersion}/MCRv84/bin/glnxa64:/opt/${toolName}-${toolVersion}/MCRv84/sys/os/glnxa64:/opt/${toolName}-${toolVersion}/MCRv84/sys/opengl/lib/glnxa64:/opt/${toolName}-${toolVersion}/MCRv84/extern/bin/glnxa64" \
   --run="ln -s /usr/local/freesurfer/${toolVersion}-1/* /usr/local/freesurfer/" \
   --copy README.md /README.md \
   --install java-1.8.0-openjdk xorg-x11-server-Xvfb xorg-x11-xauth \
   --copy test.sh /test.sh \
  > ${imageName}.${neurodocker_buildExt}
   # --run="fs_install_mcr R2014b" \
   # --run="segmentSubjectT1_autoEstimateAlveusML" \

if [ "$1" != "" ]; then
   ./../main_build.sh
fi

# license is not included in image!
   # --copy license.txt /opt/${toolName}-${toolVersion}/license.txt \

# debug:
# dnf install strace -y
# strace segmentSubjectT1_autoEstimateAlveusML
# this failed because java-1.8.0-openjdk wasn't installed!
# solution found here: https://github.com/baxpr/freesurfer720/blob/master/Dockerfile


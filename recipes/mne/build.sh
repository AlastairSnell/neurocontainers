#!/usr/bin/env bash
set -e

# this template file builds itksnap and is then used as a docker base image for layer caching
export toolName='mne'
export toolVersion='0.23.4'
# Don't forget to update version change in condaenv.yml AND README.md!!!!!

if [ "$1" != "" ]; then
    echo "Entering Debug mode"
    export debug="true"
fi

source ../main_setup.sh

neurodocker generate ${neurodocker_buildMode} \
   --base-image ubuntu:20.04 \
   --pkg-manager apt \
   --run="printf '#!/bin/bash\nls -la' > /usr/bin/ll" \
   --run="chmod +x /usr/bin/ll" \
   --run="mkdir ${mountPointList}" \
   --miniconda version=latest \
      conda_install="python=3 jupyter mne=${toolVersion} mne-bids mnelab nb_conda_kernels pytables h5py seaborn statsmodels pybv scikit-learn pyxdf pyEDFlib neurokit2" \
   --install wget libnss3 gnupg libxkbfile1 libsecret-1-0 libgtk-3-0 libxss1 libgbm1 \
   --run="wget -O vscode.deb 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64'" \
   --run="apt install ./vscode.deb"  \
   --run="rm -rf ./vscode.deb" \
   --install libxshmfence1 libasound2 \
   --copy README.md /README.md \
   --user neuro \
 > ${imageName}.Dockerfile

if [ "$debug" = "true" ]; then
   ./../main_build.sh
fi

# PROBLEM: VSCODE does not run in singularity container!

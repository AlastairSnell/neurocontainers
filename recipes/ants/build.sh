#!/usr/bin/env bash
set -e

export toolName='ants'
export toolVersion='2.3.5'
# Don't forget to update version change in README.md!!!!!

if [ "$1" != "" ]; then
    echo "Entering Debug mode"
    export debug="true"
fi

if [ "$1" == "dev" ]; then
    echo "Entering development mode"
    export dev="true"
fi

source ../main_setup.sh

yes | pip uninstall neurodocker
pip install --no-cache-dir https://github.com/NeuroDesk/neurodocker/tarball/fix-ants-source-install --upgrade

neurodocker generate ${neurodocker_buildMode} \
   --base-image ubuntu:18.04 \
   --pkg-manager apt \
   --run="printf '#!/bin/bash\nls -la' > /usr/bin/ll" \
   --run="chmod +x /usr/bin/ll" \
   --run="mkdir ${mountPointList}" \
   --${toolName} method=source version=${toolVersion} make_opts='-j8'\
   --run="chmod a+rx /opt/${toolName}-${toolVersion} -R" \
   --env DEPLOY_PATH=/opt/ants-${toolVersion}/bin \
   --env DEPLOY_PATH=/opt/ants-${toolVersion}/Scripts \
   --env PATH=/opt/ants-${toolVersion}/Scripts:/opt/ants-${toolVersion}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
   --copy README.md /README.md \
  > ${imageName}.${neurodocker_buildExt}

if [ "$debug" = "true" ]; then
   ./../main_build.sh
fi

export toolName='nighres'
export toolVersion='1.5.1' 

if [ "$1" != "" ]; then
    echo "Entering Debug mode"
    export debug=$1
fi
source ../main_setup.sh

neurodocker generate ${neurodocker_buildMode} \
   --base-image ubuntu:22.04 \
   --env DEBIAN_FRONTEND=noninteractive \
   --pkg-manager apt \
   --run="printf '#!/bin/bash\nls -la' > /usr/bin/ll" \
   --run="chmod +x /usr/bin/ll" \
   --run="mkdir -p ${mountPointList}" \
   --install git python-is-python3 python3-pip curl locales wget \
   --run='curl https://download.java.net/java/GA/jdk20.0.1/b4887098932d415489976708ad6d1a4b/9/GPL/openjdk-20.0.1_linux-x64_bin.tar.gz | tar -zx -C /opt --transform='s/jdk-20.0.1/jdk-temurin-20.0.1/'' \
   --env JCC_JDK=/opt/jdk-temurin-20.0.1 \
   --env JAVAHOME=/opt/jdk-temurin-20.0.1 \
   --env PATH='$PATH':$JAVAHOME/bin \
   --run="pip3 install JCC" \
   --workdir /opt \
   --run="git clone https://github.com/nighres/nighres.git \
         && cd nighres \
         && make install" \
   --env DEPLOY_PATH=/opt/${toolName}-${toolVersion}/bin/ \
   --copy README.md /README.md \
   --copy test.sh /test.sh \
   --run="bash /test.sh" \
   --copy license.txt /license.txt                          `# MANDATORY: include license file in container` \
  > ${imageName}.${neurodocker_buildExt}
  
if [ "$1" != "" ]; then
   ./../main_build.sh
fi

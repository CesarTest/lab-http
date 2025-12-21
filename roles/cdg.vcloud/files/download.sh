#!/bin/bash
##########################################
# ENVIRONMENT
##########################################
WORK_PATH=( "./centos9" \
	    "./rhel86" \
#	    "./centos9" \
#	    "./centos8" \
#            "./centos7" \
#            "./centos7" \
#            "./centos6" \
#            "./centos6" \
	  )
URL=( "https://vagrantcloud.com/generic/boxes/centos9s/versions/4.3.12/providers/virtualbox/amd64/vagrant.box" \
      "https://vagrantcloud.com/generic/boxes/rhel8/versions/3.6.10/providers/virtualbox/unknown/vagrant.box" \
#      "https://vagrantcloud.com/generic/boxes/centos9s/versions/4.3.12/providers/libvirt/amd64/vagrant.box" \
#      "https://vagrantcloud.com/generic/boxes/centos8/versions/4.3.12/providers/libvirt/amd64/vagrant.box" \
#      "https://vagrantcloud.com/generic/boxes/centos7/versions/4.3.12/providers/virtualbox/amd64/vagrant.box" \
#      "https://vagrantcloud.com/generic/boxes/centos7/versions/4.3.12/providers/libvirt/amd64/vagrant.box" \
#      "https://vagrantcloud.com/generic/boxes/centos6/versions/4.3.12/providers/virtualbox/amd64/vagrant.box" \
#      "https://vagrantcloud.com/generic/boxes/centos6/versions/4.3.12/providers/libvirt/amd64/vagrant.box" \
    )

     # "https://vagrantcloud.com/boxomatic/boxes/centos-stream-9/versions/20240419.0.1/providers/virtualbox/amd64/vagrant.box" \
    
NAME=( "virtualbox.box" \
       "virtualbox.box" \
#       "libvirt.box" \
#       "libvirt.box" \
#       "virtualbox.box" \
#       "libvirt.box" \
#       "virtualbox.box" \
#       "libvirt.box" \
     )

##########################################
# ACTIONS
##########################################
for ((idx=0; idx<${#URL[@]}; ++idx)); do

  BOX_URL="${URL[$idx]}"
  BOX_PATH="${WORK_PATH[$idx]}"
  BOX_NAME="${NAME[$idx]}"

  if [ ! -d "${BOX_PATH}" ] ; then 
     echo "mkdir -p ${BOX_PATH}"
     mkdir -p "${BOX_PATH}"
  fi
  
  echo "wget ${BOX_URL} -O ${BOX_PATH}/${BOX_NAME}"
  wget "${BOX_URL}" -O "${BOX_PATH}/${BOX_NAME}" &

done

########################################
#  END
########################################

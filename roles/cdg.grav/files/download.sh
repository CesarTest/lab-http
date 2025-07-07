#!/bin/bash
##########################################
# ENVIRONMENT
##########################################
WORK_PATH=( \
	"./install" \
	"./themes" \
	"./themes" \
	"./plugins" \
	)
URL=( \
    "https://getgrav.org/download/skeletons/learn2-with-git-sync-site/1.6.8" \
    "https://github.com/getgrav/grav-theme-learn4/archive/refs/heads/develop.zip" \
    "https://github.com/getgrav/grav-theme-quark/archive/refs/heads/develop.zip" \
    "https://github.com/trilbymedia/grav-plugin-page-toc/archive/refs/heads/master.zip"
    )
NAME=( \
     "learn2-skeleton.zip" \
     "learn4-theme.zip" \
     "quark.zip" \
     "page-toc.zip" \
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
  wget "${BOX_URL}" -O "${BOX_PATH}/${BOX_NAME}"

done

########################################
#  END
########################################

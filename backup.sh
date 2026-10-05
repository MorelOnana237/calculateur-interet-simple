#!/bin/bash

# Vérifier qu'il y a exactement 2 arguments
if [[ $# != 2 ]]
then
  echo "Usage: backup.sh target_directory_name destination_directory_name"
  exit
fi

# Vérifier que les deux chemins sont des répertoires valides
if [[ ! -d $1 ]] || [[ ! -d $2 ]]
then
  echo "Invalid directory path provided"
  exit
fi

targetDirectory=$1
destinationDirectory=$2

echo "Target directory: $targetDirectory"
echo "Destination directory: $destinationDirectory"

currentTS=$(date +%s)
backupFileName="backup-$currentTS.tar.gz"

origAbsPath=$(pwd)

cd $destinationDirectory
destAbsPath=$(pwd)

cd $origAbsPath
cd $targetDirectory

yesterdayTS=$(($currentTS - 24 * 60 * 60))

declare -a toBackup

for file in *
do
  file_ts=$(date -r $file "+%s")
  if ((file_ts > yesterdayTS))
  then
    toBackup+=($file)
  fi
done

tar -czvf $backupFileName ${toBackup[@]}
mv $backupFileName $destAbsPath
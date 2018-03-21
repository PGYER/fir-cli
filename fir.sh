#!/bin/sh
#  because fir-cli dependent ruby enviroment, this shell is dependent ruby docker
#  so xcode and gradle not use
#  this shell only use to publish apk or ipa , build is not run
#  fir publish **.apk
#  echo $(curl https://raw.githubusercontent.com/FIRHQ/fir-cli/master/fir.sh) > /usr/local/bin/fir

mountFolder=$HOME/fir-cli/data
destFolder=/fir-cli

mkdir -p $mountFolder

# find path file name
function findFileName() {
	echo ${1##*/}
}

# move file to mount folder 
tmpFiles=()
cmds=()
for i in $@; do 
	if [ -d $i ];then
	   cp -r $i $mountFolder
	elif [ -f $i ];then
	   cp $i $mountFolder
	else
		cmds+=($i)
		continue
	fi
	destFile=$destFolder/$(findFileName $i)
	cmds+=($destFile)
	tmpFiles+=($mountFolder/$(findFileName $i))
done  

# start docker to run fir cmd
docker run -v $HOME/fir-cli/data:/fir-cli  flowci/fir-cli fir ${cmds[@]}

# clean folder
for i in ${tmpFiles}; do
	if [ -d $i ];then
	   rm -rf $i
	elif [ -f $i ];then
	   rm $i
	fi
done


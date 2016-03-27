#!/usr/bin/bash
DIR=$1
#echo $DIR
if [ "${DIR}" != "" ]; then
	DIR=${DIR}/
fi
#echo ${DIR}
llMsg=`ls -l ${DIR}`
#echo "${llMsg}"
sumDir=`echo "${llMsg}" | grep ^d | wc -l`
echo "Directory Number: ${sumDir}"

llMsg=`ls ${DIR}`
sumExe=0
for file in ${llMsg}
do
	if test -x ${DIR}${file}; then
#		echo "add"
		let sumExe=${sumExe}+1
	fi
#	echo ${sumExe}
#	echo ${file}
done
echo "Executable File Number: ${sumExe}"

llMsg=`ls -l | grep ^[^d] | awk '{print $9}'`
sumNonSuffix=0
declare -A sumSuffix
for file in ${llMsg}
do
	suf=`echo ${file#*.}`
	if test ${suf} = ${file}; then
		let sumNonSuffix+=1
	else
		let sumSuffix[${suf}]+=1
	fi
done
if test ${sumNonSuffix} -gt 0; then
	echo "Files with No Suffix: ${sumNonSuffix}"
fi
#for suf in ${!sumSuffix[*]}
#do
#	echo "Files with Suffix '${suf}': ${sumSuffix[${suf}]}"
#done

for suf in `echo ${!sumSuffix[*]} | sed -e "s/ /\n/g" | sort`
do
	echo "Files with Suffix '${suf}': ${sumSuffix[${suf}]}"
done

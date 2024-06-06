#!/bin/sh

# update.sh
# Bruno LEGAY - 07/09/2015
# Copyrights A&C Consulting
# ==================================================================================================
# History 
# ----------
# v 1.0.2
# improved logs
# Bruno LEGAY - 07.09.2015
# v 1.0.2
# improved logs
# added quote to handle space in path (and tests)
# added zip archive creation with ditto -ck (commented ou for the moment)
# Bruno LEGAY - 22.04.2013
# ----------
# v 1.0.1
# Intial removed extra subdir level ( mainDir/archive  mainDir/app/myApp.4dbase => mainDir/archive  mainDir/myApp.4dbase)
# test for "logs" and "archives" dir presence (create them if necessary)
# Bruno LEGAY - 19.04.2013
# ----------
# v 1.0.0
# Intial version
# Bruno LEGAY - 11.04.2013
# ==================================================================================================
# Sample call from command line :
# ~/Documents/Projets/updater/source/updater.4dbase/Resources/update.sh \
# ~/Documents/Projets/updater/app\ test/updater_test.4dbase \
# ~/Documents/Projets/updater/update\ test/updater_test.4dbase
# ==================================================================================================

# Grab the parameter off the command line delay=1
currentPath="$1"
updatePath="$2"

usage=0;

if [ "${currentPath}" == "" ]; then
	usage=1;
	echo "CURRENTPATH is required"
fi

if [ "${updatePath}" == "" ]; then
	usage=1;
	echo "UPDATEPATH is required"
fi

if [ "${usage}" == "1" ]; then
	echo "usage: update.sh CURRENTPATH UPDATEPATH"
	echo " where"
	echo " CURRENTPATH = current path"
	echo " UPDATEPATH = update path"
	exit
fi

#===================================================================
s_now()
# Returns string (YYYYMMDDHHMMSS)
#===================================================================
{
    date +%Y%m%d%H%M%S
}

#===================================================================
s_nowDate()
# Returns string (YYYYMMDD)
#===================================================================
{
    date +%Y%m%d
}

#===================================================================
s_nowLog()
# Returns string (DD/MM/YYYY HH:MM:SS)
#===================================================================
{
    date "+%d/%m/%Y %H:%M:%S"
}

# check that the "archives" directory exists at the same level as the file given in $1
# if it does not exists, create it
if [ ! -d "${currentPath}/../archives" ]; then
  mkdir "${currentPath}/../archives"
fi

# check that the "logs" directory exists at the same level as the file given in $1
# if it does not exists, create it
if [ ! -d "${currentPath}/../logs" ]; then
  mkdir "${currentPath}/../logs"
fi

LOGFILE="${currentPath}/../logs/update_log_`s_nowDate`.txt"

# main part of the script
{
  #if [ -e "${currentPath}" ]; then  
	  if [ -e "${updatePath}" ]; then  
	
			echo "`s_nowLog` - sh - Current path : ${currentPath}"
			echo "`s_nowLog` - sh - Update path : ${updatePath}"
		
			currentDir=`dirname "${currentPath}"`
			currentFile=`basename "${currentPath}"`
			
			echo "`s_nowLog` - sh - currentDir ${currentDir}"
			echo "`s_nowLog` - sh - file : ${currentFile}"
			
			archivePath="${currentPath}/../archives/${currentFile}_`s_now`"
			echo "`s_nowLog` - sh - archive : ${archivePath}.tgz"
			
			# l'application sera archivŽe dans une archive tgz
			echo "`s_nowLog` - sh - tar -zcf \"${archivePath}.tgz\" \"${currentPath}\"..."
			tar -zcf "${archivePath}.tgz" "${currentPath}"
			echo "`s_nowLog` - sh - tar done ($?)."
			
			# l'application sera archivŽe dans une archive zip
			# echo "`s_nowLog` - sh - ditto -ck --keepParent \"${currentPath}\" \"${archivePath}.zip\""
			# ditto -ck --keepParent "${currentPath}" "${archivePath}.zip"
			# echo "`s_nowLog` - sh - ditto done ($?)."
			
			#	if [ -e "${currentPath}/../archives" ]; then
			#		echo "`s_nowLog` - sh - file : ${currentPath}/../archives exists"
			#		echo "`s_nowLog` - sh - tar -zcvf ${currentPath}/../archives/${currentFile}_`s_now`.tgz ${currentPath}..."
			#		# l'application sera archivŽe dans une archive tgz
			#		# tar -zcvf "${currentPath}/../archives/${currentFile}_`s_now`.tgz" "${currentPath}"
			#		
			#		# l'application sera archivŽe dans une archive zip
			#		echo "`s_nowLog` - sh - ditto -ck --keepParent ${currentPath} ${currentPath}/../archives/${currentFile}_`s_now`.zip""
			#		ditto -ck --keepParent "${currentPath}" "${currentPath}/../archives/${currentFile}_`s_now`.zip"
			#	else
			#		# l'application sera archivŽe dans une archive tgz
			#		# echo "`s_nowLog` - sh - tar -zcvf ${currentPath}_`s_now`.tgz ${currentPath}..."
			#		# tar -zcvf "${currentPath}_`s_now`.tgz" "${currentPath}"
			#		
			#		# l'application sera archivŽe dans une archive zip
			#		echo "`s_nowLog` - sh - ditto -ck --keepParent ${currentPath} ${currentPath}_`s_now`.zip""
			#		ditto -ck --keepParent "${currentPath}" "${currentPath}_`s_now`.zip"
			#	fi

			# read the error from tar/ditto
			ERRNO=$?
			if [ ${ERRNO} -eq 0 ]; then
			
			    if [ -e "${currentPath}" ]; then 
					echo "`s_nowLog` - sh - rm -R \"${currentPath}\""
					rm -R "${currentPath}"
					echo "`s_nowLog` - sh - rm done ($?)."
				fi
				
				echo "`s_nowLog` - sh - mv -f \"${updatePath}\" \"${currentPath}\""		
				mv -f "${updatePath}" "${currentPath}"
				echo "`s_nowLog` - sh - mv done ($?)."
				
				# keep quiet :-)
				#say "update complete"
			
				echo "`s_nowLog` - sh - --------------------------------------------------------------------------------"	
				
				# exit with 0 (no error)
				exit 0
		
			fi
		fi
	#fi
}  2>&1 >> "${LOGFILE}"

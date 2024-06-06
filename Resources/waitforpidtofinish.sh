#!/bin/sh

# waitforpidtofinish.sh
# Bruno LEGAY - 07/09/2015
# Copyrights A&C Consulting
# ==================================================================================================
# History 
# ----------
# v 1.1.0
# added a timeout parameter
# Bruno LEGAY - 07.09.2015
# ----------
# v 1.0.1
# improved with eval and space handling
# Bruno LEGAY - 22.04.2013
# ----------
# v 1.0.0
# Intial version
# Bruno LEGAY - 11.04.2013
# ==================================================================================================
# Sample call from command line :
# '/Users/ble/Documents/Projets/app test/myApp.4dbase/Components/updater.4dbase/Resources/waitforpidtofinish.sh' \
# 16649 \
# 0 \
# '/private/var/folders/oV/oVr2pPciF2eoUWyGKKIWRU+++TM/-Tmp-/Cleanup At Startup/updater4d_0x136F2367.sh'
# ==================================================================================================

#{
	# Grab the pid parameter off the command line
	pid=$1
	#shift 1
	#cmd=$*
	#$*	   # L'ensembles des paramètres sous la forme d'un seul argument
	#$@	   # L'ensemble des arguments, un argument par paramètre
	
	# Grab the timeout parameter off the command line
	timeout=$2
	shift 2
	
	set -f
	cmd=$*
	set +f
	
	echo "pid : ${pid}"
	echo "timeout : ${timeout}"
	echo "cmd : ${cmd}"
	
	usage=0;
	delay=1; # delay 1 second
	
	if [ "${pid}" == "" ]; then
		usage=1;
		echo "PID is required"
	fi
	
	if [ "${timeout}" == "" ]; then
		usage=1;
		echo "timeout is required"
	fi
	
	if [ "${cmd}" == "" ]; then
		usage=1;
		echo "COMMAND is required"
	fi
	
	if [ "$usage" == "1" ]; then
		echo "usage: waitforpid.sh PID TIMEOUT COMMAND"
		echo " where"
		echo " PID = Process id to wait for"
		echo " TIMEOUT = maximum number of seconds to wait for (0 means no timeout)"
		echo " COMMAND = Command to be executed after it completes"
		exit
	fi

	# Redirect stdout and stderr of the ps command to /dev/null
	ps -p${pid} 2>&1 > /dev/null
	 
	# Grab the status of the ps command 
	status=$?
	
	# for testing purpose
	# status=0
	
	# A value of 0 means that it was found running 
	if [ "${status}" == "0" ]; then
		
		# for testing purpose
		# status=1 
		
		loopCounter=0
		
		echo "Waiting for process ${pid} to terminate"
		while [ "${status}" == "0" ]; do
			((loopCounter+=1))
			
			# if timeout greater than 0 AND loopcount greater than timeout
			if [ "${timeout}" -gt 0 -a "${loopCounter}" -gt "${timeout}" ]; then
				# note Bruno LEGAY : requires admin rights to perform kill
				eval "kill -9 ${pid}"
			fi
			
			sleep ${delay} # sleep 1 second
			
			# read information about status. 
			# if process exists, it status will be 0,
			# if it does not exists anymore, it will return 1
			ps -p ${pid} 2>&1 > /dev/null
			status=$?
			
			echo "pid ${pid}, loopCounter ${loopCounter}, status ${status}"
		done
		
		# The process has started, do something here 

        # keep quiet :-)
		#say "running update"
		
		echo "Running : ${cmd}"
		eval "\"${cmd}\""
		#eval "${cmd}" ne marche pas avec des espaces dans le chemin
		
		# A value of non-0 means that it was NOT found running 
	else
		echo "Process with pid ${pid} is not running"
	fi
#}
#} 2>&1 >> "/Users/ble/Documents/Projets/BaseRef_v12/updater/test_target_old/update_log.txt"
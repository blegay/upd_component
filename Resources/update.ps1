# ===============================================================================
# update.ps1
# ===============================================================================
# This script is a Windows PowerShell (v2+) script
# It will wait that the 4D main application quits
# then it archives the current application ("app.4dbase" dir)
# then it replaces the current application with new version
# then it relaunches the 4D application with the 4D Link file (to open the correct structure and data)
# arguments :
#    - pid : process id (4D app) to wait for end
#	 - timeout : timeout in seconds (0 means no timeout)
#    - current : current version ("C:\Users\Bruno\Docments\company\prod\application\app.4dbase")
#    - new : new version         ("C:\Users\Bruno\Docments\company\prod\application\temp\app.4dbase")
#    - appExec : path to the exe file (e.g. "C:\Program Files (x86)\4D\4D v12.6\4D\4D.exe")
#    - linkFile : path to the link file (*.4dlink file located in system temporary directory for instance e.g "C:\Users\Bruno\AppData\Local\Temp\restart.4DLink")
#    - compressEnabled : enable/disable compression of archive (default = "true") [optional] 
# 
# Tested ok on Windows 7 SP1 64bit French
#
# Bruno LEGAY - A&C Consulting - 2025-11-12 - v4.00.01
#     - inserted optional parameter to enable/disable compression of archive (default = "true")
# Bruno LEGAY - A&C Consulting - 2015-04-23 - v1.01.00
#     - inserted timeout parameter
# Bruno LEGAY - A&C Consulting - 2015-04-23 - v1.00.00
# ===============================================================================

$nbParam = $args.count
if ($nbParam -gt 5)
{
	$targetpid=$args[0]
	$timeout=$args[1]
	$current=$args[2]
	$new=$args[3]
	$appExecPath=$args[4]
	$linkFilePath=$args[5]
	
    # Paramètre optionnel : activer la compression (true par défaut). Si passé et égal à "false" (insensible à la casse), la compression est désactivée.
    if ($nbParam -gt 6) {
    	# considérer "false" (ou "0") comme désactivation, tout le reste = true
    	$compressEnabled = -not ($args[6].ToString().ToLower() -in @("false","0"))
    } else {
	    $compressEnabled = $true
    }

	# $appExecPath="`'$appExecPath`'"
	# $linkFilePath="`'$linkFilePath`'"
	
	# $new : Chemin du dossier la nouvelle application qu'on va installer
	# e.g. "C:\Users\Bruno\Documents\Yodaforex\temp\updater.4dbase"
	
	# $current : Chemin du dossier l'application qu'on va remplacer
	# e.g. "C:\Users\Bruno\Documents\Yodaforex\updater.4dbase"
	
	# sera copi� dans 
	# e.g. "C:\Users\Bruno\Documents\Yodaforex\archive\updater.4dbase-yyyyMMdd.zip"
	
	# ===============================================================================
	# This function writes a log message into a given log file
	# ===============================================================================
	Function log ($logPath,$logMessage)
	{
		$logTimestamp = (Get-Date).ToString("dd/MM/yyyy HH:mm:ss")
		add-content -Path $logPath -Value "$logTimestamp $logMessage" -Force
	}
	
	
	# ===============================================================================
	# This function returns the path for the log file
	# ===============================================================================
	Function logFilePath ($homeDir)
	{
		$logDir = "$homeDir\logs"
		If(!(Test-Path $logDir)){
			New-Item -Path $homeDir -Name "logs" -ItemType directory | Out-Null
		}
		return "$logDir\logs_{0}.txt" -f (Get-Date).ToString("yyyyMMdd")
	}
	
	# ===============================================================================
	# This function will return the path for 7zip exe
	# ===============================================================================
	Function sevenZipPathGet ($embededPath)
	{
		$pg=(Get-Item "Env:ProgramFiles").Value
		# e.g. "C:\Program Files (x86)"
		$szPath=""
		if ($pg.EndsWith(" (x86)")) {
			$pg64=$pg.Substring(0,$pg.Length-6)
			if (test-path "$pg64\7-Zip\7z.exe") {
				# use "C:\Program Files\7-Zip\7z.exe"
				$szPath="$pg64\7-Zip\7z.exe" 
			}		 
		}

		if ($szPath.Length -eq 0) {
			if (test-path "$pg\7-Zip\7z.exe") {
				# use "C:\Program Files (x86)\7-Zip\7z.exe"
				$szPath="$pg\7-Zip\7z.exe"
			}
		}
		if ($szPath.Length -eq 0) {
			# use embeded 7za
			$szPath=$embededPath
			
		}
		return $szPath
	}

	# PowerShell v2
	$myPSScriptPath = $MyInvocation.MyCommand.Path
	# $myPSScriptPath = "C:\Users\Bruno\Documents\Yodaforex\Yodaforex.4dbase\components\updater\resources\script.ps1"
	
	$myPSScriptRoot = Split-Path $myPSScriptPath -Parent
	# "C:\Users\Bruno\Documents\Yodaforex\updater.4dbase\components\updater\resources"
	# echo "myPSScriptRoot $myPSScriptRoot"
	# PowerShell v3+
	# $myPSScriptRoot = $PSScriptRoot 
	
	# set home directory
	# $homeDir = "C:\Users\Bruno\Documents\Yodaforex"
	$homeDir = Split-Path $myPSScriptRoot -Parent | split-path -Parent | split-path -Parent | split-path -Parent
	# "C:\Users\Bruno\Documents\Yodaforex
	# echo "homeDir $homeDir"
	
	# set log dir and log file path
	# $logFilePath = logFilePath $homeDir
	$logPath = logFilePath "$homeDir"
	# echo "logPath $logPath"
	
	# set the path to 7zip executable, and an alias to the executable
	# if it is not installed, we will default to embeded 7za.exe
	$szPath = sevenZipPathGet "$myPSScriptRoot\win\7za.exe"
	Set-Alias sz "$szPath"
	
	# write to log that the parameters received by the script
	log $logPath "waiting for process $targetpid (param0) to finish, source : `"$new`" (param1), dest : `"$current`"  (param2), appExecPath : `"$appExecPath`"  (param3), linkFilePath : `"$linkFilePath`"  (param4)"
	
	log $logPath "homeDir : `"$homeDir`""
	# log $logPath "homeDirDebug : `"$homeDirDebug`""
	
	# log $logPath "pg : `"$pg`""
	log $logPath "7z path : `"$szPath`""
	
	$logString = "powershell version {0}, script root $myPSScriptRoot" -f $PSVersionTable.PSVersion
	log $logPath $logString
	
    # log de l'option compression
    log $logPath ("compression enabled : {0}" -f $compressEnabled)

	# use a mutex to avoid two scripts doing the same operation on the same process
	$mtx = New-Object System.Threading.Mutex($false, "update4dAppPid-$targetpid")
	If ($mtx.WaitOne) { 
		log $logPath "mutex start"
		# echo "mutex!"
		
		# Check that the 4D process is running...
		$ProcessActive = Get-Process -id $targetpid -ErrorAction SilentlyContinue
		if ($ProcessActive -ne $null) {
			log $logPath "process $targetpid / $ProcessActive running"
			echo "process running"
			
			
			if ($timeout -gt 0) 
			{
				try
				{
					# wait for the 4D app/process to finish/quit with a given timeout

					log $logPath "wait for proccess $targetpid to finish, timeout $timeout"
					Wait-Process -Id $targetpid -Timeout $timeout -ErrorAction Stop
					
					# write to log that the 4D app/process has finished/quit
					log $logPath "process $targetpid finished"
					echo "process finished"
				}
				catch
				{
					# the process has not finished within timeout, we'll try to force qui / kill
					log $logPath "process $targetpid timedout, attempt to kill..."
					
					Stop-Process -Id $targetpid -Force
	
					Wait-Process -Id $targetpid
					
					# write to log that the 4D app/process has finished/quit
					log $logPath "process $targetpid killed/finished"
					echo "process finished"
				}
			
			} else 
			{
				# wait for the 4D app/process to finish/quit (no timeout)
				
				log $logPath "wait for proccess $targetpid to finish, no $timeout"
				Wait-Process -Id $targetpid
				
				# write to log that the 4D app/process has finished/quit
				log $logPath "process $targetpid finished"
				echo "process finished"
			}
		
			if ($compressEnabled) {
				# creating an archive of the current version
				$archiveParentDir = Split-Path $current -Parent
				
				$archiveName = "{0}_{1}.zip" -f (Split-Path $current -Leaf), (Get-Date).ToString("yyyyMMdd-HHmmss")
				# "updater.4dbase_20150423-105806.zip"
			
				# log $logPath "archive parent dir : $archiveParentDir, archive name : $archiveName"
			
				$archiveDir = "$archiveParentDir\archives"
				# log $logPath "archive dir : $archiveDir"
				if (!(Test-Path $archiveDir)){
					New-Item -Path $archiveParentDir -Name "archives" -ItemType directory | Out-Null
					log $logPath "creating archive dir : $archiveDir"
				}
				if (Test-Path $archiveDir){
					log $logPath "archive dir : $archiveDir exists"
				}
			
				# zip the old "app.4dbase" into the archive
				$zipArchivePath="$archiveDir\$archiveName"
				log $logPath "archiving old application..."
				log $logPath "zipping `"$current`" into `"$zipArchivePath`"..."

				# & $szPath a -tzip $zipArchivePath $current;
				sz a -tzip $zipArchivePath $current
				
				# zipDirectory $zipArchivePath $current
				log $logPath "zipping `"$current`" into `"$zipArchivePath`" done."
				log $logPath "old application archived"
				echo "old application archived"
			
				<# 
				# Write-Zip not supported in PowerShell v2
				# Get-Childitem $current -Recurse | Write-Zip -IncludeEmptyDirectories -OutputPath "zipArchivePath"
				#>
			}
			
			log $logPath "installing new application..."
		
			$destParentDir = Split-Path $current -Parent
			
			# check that the new application is available
			if (test-path "$new") {
			
				log $logPath "deleting `"$current`"..."
				Remove-Item $current -recurse
				log $logPath "deleting `"$current`" done."
			
				log $logPath "Moving `"$new`" into `"$destParentDir`"..."
				Move-Item $new $destParentDir
				log $logPath "Moving `"$current`" into `"$destParentDir`" done."
			
				log $logPath "new application installed"
				echo "new application installed"
			}
			Else {
				log $logPath "new application not available in `"$new`" !!!"
				echo "new application not available in `"$new`" !!!"
			}
			
			log $logPath "launching new application..."	
			& "$appExecPath" "$linkFilePath";
			log $logPath "new application launched"
			
			echo "new application started"
		} 
		Else {
			log $logPath "process $targetpid not running !!!"
			echo "process not running !!!"
		}

		# release mutex
		$mtx.ReleaseMutex
		log $logPath "mutex end"
	} 
	Else {
		log $logPath "Timed out acquiring mutex!"
		echo "Timed out acquiring mutex!"
	}
	$mtx.Dispose
		
	log $logPath "================================================================================"
}
else 
{
	echo "expecting 5 parameters !!!"
}
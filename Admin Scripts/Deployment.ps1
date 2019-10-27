################Check if all the source Path's are correct###############

function DeployFiles() {

$Timestamp = Get-Date -format yyyyMMdd_HHmmss

$Value = Get-Content -Path $ParamFile
$ApplicationName = $Value[0].Substring(20)

$ApplicationName = $ApplicationName -replace '\s',''
$ApplicationName
#"The count of the variable is " + $ApplicationName.Length
$ApplicationName_D="$ApplicationName"
 "$($ApplicationName_D)_DEV"
$ApplicationName_DEV= "$($ApplicationName)_DEV\"
#$ApplicationName_DEV

$deployid=$Value[1].Substring(43)
$AppLogfile=$DevPath + "\" + $ApplicationName + "\Deployment\Deployment.log" 
#$AppLogfile
#$deployid

$Username = $Value[1].Substring(43)

$NoOfFiles = $Value[2].Substring(31)


"################################">> $LogFile
"################################">> $AppLogFile
$Date +":ApplicationName: $ApplicationName" >> $LogFile
$Date +":ApplicationName: $ApplicationName" >> $AppLogFile
$Date +":Username :" + $Username  >> $AppLogFile
$Date +":Username :" + $Username  >> $LogFile


$Random= get-random -maximum 9999
$BackupFileName=$BackupFilePath + "\" + $Timestamp + "_"+ $ApplicationName + "_" +$Username
md $BackupFileName


#####Taking backup files and copying#######

$Date +":Following files are deployed successfully" >> $AppLogFile
$Date +":Following files are deployed successfully" >> $LogFile
for ($i=0; $i -lt $NoOfFiles; $i++) {

	
	$FilePath = $value[3+$i].Substring(22)
#$FilePath >> $LogFile
    	$ProdSource= $ProdPath + "\" + $FilePath
$ProdSource >> $LogFile
    	$DevSource= $DevPath + "\" + $ApplicationName + "\Deployment\" + $FilePath
#$DevSource >> $LogFile
	#"The devsoucr is :" + "$(DevSource)NOSPACES"
	#"The PROD soucr is : " +$ProdSource
	
	If ( (Test-Path "$ProdSource") ){
		
		Copy-Item -path $ProdSource -destination $BackupFileName
		
		
	}
	
	If (Test-Path $DevSource ) {
		
		Copy-Item -path   $DevSource -destination $ProdSource
		#"The Devsource is :" + $DevSource
		#"The ProdSource is :" + $ProdSource
		if ($? -eq 'True')
		{
			Remove-Item –path $DevSource –recurse
		}
		#$DevSource   >> $LogFile
		$DevSource >> $AppLogFile
		
	 }
	
}

$directoryInfo = Get-ChildItem $BackupFileName | Measure-Object

If ($directoryInfo.count -eq 0 ) 

{
	Remove-Item –path $BackupFileName –recurse
}



}
Function Mailer ($container,$emailTo)
{

$msgBody = @"
Hi Team,

The deployment of following container is successfully done.

$container

For complete information please visit the below location,latest deployment details are at the end of the log file.

<Development Server Path>\CommonC\Qlikview Deployment-Inter\$container\Deployment\Deployment.log

Regards
Platform Team

 
"@

$emailFrom = "<Client Email Id>" 
$subject="***Deployment Status:Deployed to Production***"
$smtpserver="<Client SMTP Server>" 
$smtp=new-object Net.Mail.SmtpClient($smtpServer) 
$smtp.Send($emailFrom, $emailTo, $subject, $msgBody) 

}


   ###################################
#######Change this --server path for dev and PROD
#"test printscreen"

$DevPath="<Development Server Path>\Common_C\Qlikview Deployment-Inter"
$ProdPath="<Production Server Path>\QlikViewStorage\SourceDocuments"
$ScriptPath ="<Production Server Path>\QlikViewStorage\SourceDocuments\Deployment_scripts"
$emailTo = "<developers email Ids>"

#########Change this path Parameter path

$BackupFilePath = "<Production Development Path>\QlikViewStorage\SourceDocumentsBackup"
$Date = Get-Date -Format g

########Change this path
$LogFile = "<Production Development Path>\QlikViewStorage\SourceDocuments\Deployment_scripts\Deployment.log"

$Date +":Discovery to Production" >> $LogFile

$file = $ScriptPath + "\SolutionNames.txt"

$DB = Get-Content $file
foreach ($Data in $DB){
$ParamFile= $DevPath + "\" + $Data + "\Deployment\parameter.txt"
#$ParamFile

If (Test-Path $ParamFile ){

		$Data >> $LogFile
		$Value = Get-Content -Path $ParamFile
		$emailid=$Value[1].Substring(43)
		$emailid1=","+$emailid+"@<client domain>.com"
		$emailTo=$emailTo+$emailid1
		$filenames=DeployFiles
		
		#$filenames		
		$deployed = "$Data`n$($deployed )"
		
		Remove-Item –path $ParamFile
		
	}
else
{	continue }

}




if ($deployed.length -gt 2) {
   
	Mailer  $deployed $emailTo  

}

"###################################################################" >> $LogFile


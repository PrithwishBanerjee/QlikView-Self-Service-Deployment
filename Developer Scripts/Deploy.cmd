@echo off
setlocal EnableDelayedExpansion
set prodpath="<Production Server Path>"
set devpath="<Deployment Server Path>\Common_C\Qlikview Deployment-Inter"



set appname= <Container Name>


set filename=%devpath%\%appname%\Deployment\parameter.txt


set inputfilepath="%devpath%\%appname%\Deployment\%appname%"

:begin1

cls
echo Welcome to deployment of files and apps to %appname%.
echo(
echo Please note that new folders cannot be deployed through this interface,and must instead be ordered by email to Qlikview-Platform(dlQlikview-Platform@<client domain>.com).
echo(
echo All files to be deployed must be present in the correct path in the Deployment folder.
echo Only one deployment can be ongoing per container at a time, so please add all files/solution at once.
echo( 

echo Be aware that you running this deployment script takes full responsibility of all content being deployed.
echo Responsible:%username% 

echo(


choice /n /c:YN /m "Developer confirms that all files have been tested and validated in eXploration and are expected to work without any error in production:(Y/N)"%1
if errorlevel ==2 goto endoffile
if errorlevel ==1 goto next

:next

echo(
choice /n /c:YN /m "For large and complex apps the developer has done sufficient testing and takes full responsibility of the impact on the platform. If uncertain please contact *who* to help assess impact. And also, please make sure NO-JOB is running at this time (Y/N)
: "%1
if errorlevel ==2 goto endoffile
if errorlevel ==1 goto next1



:next1

cls
echo %appname%
IF exist "!filename!" (
	@echo(
	@echo Another Depolyment is already in progress. Please continue once the ongoing deployment is completed.
	goto endoffile
)


goto next3



:files
set /p howmany=How many files are included in the deployment? 


set /a num=%howmany% 2>nul



if not !num!==0  (
	if !num! LEQ 20 (
		if {!num!}=={!howmany!} (
			set /a both = 1
)))


	If !both! ==1 (
	
	rem @echo Number of files to be deployed:%howmany% >>%filename%
	goto next3
	) ELSE (
		echo Please provide a correct input ^^!^^!^^! 
		goto files )
		


:next3



pushd %inputfilepath%

set /a count=0
echo(
echo Following files will be included in the deployment:
echo(

for /r %%i in (*) do (
		
	set /a count=!count!+1
	set value=%%i
	
	
	set filenames[!count!]=%%~nxi
	set filepath[!count!]=%%i



for /f "tokens=1,2,3* delims=\" %%a in ("!%%i!") do (
				set /a count1=!count1!+1
  				set a1_=%%a
				
  				set a2_=%%b
				
				set a3_=%%c
				
				set a4_=%%d
				
				set a_value[!count1!]=%%d
				@echo !a4_!
								 
					
			)
)
			

			

goto getvalidate


:getvalidate

IF !count! ==0 (

	@echo "There are no files in deployment location"
	goto endoffile
) ELSE (


for /L %%i in (1,1,%count%) do (

For %%r in ("!a_value[%%i]!") do (
				
    				Set Folder=%%~pr
    				Set Name=%%~nxr
				for /f "tokens=1,2,3,4* delims=\" %%a in ("!Folder!") do (
  				set a1_=%%a
  				set a2_=%%b
				set a3_=%%c
				set a4_=%%d
				set a5_=%%d
				
				
				)
				)
		
		
		IF NOT EXIST "%prodpath%\!a5_!" (
			echo(			
			echo PROD folder !a4_! doesnt exist.. 
			echo We cannot continue with this deployment^^!^^!^^!Please contact Platform team to create a new folder...
			goto endoffile 
		
		) 
				
)
goto next4


)

:next4
	@echo(
	choice /n /c:YN /m "Proceed with the deployment(Y/N)"%1
	if errorlevel ==2 goto endoffile
	if errorlevel ==1 goto param

 

:param


@echo The container name: %appname%>> %filename%
 @echo The Developer who requested for deployment:%username%>> %filename%
 @echo Number of files to be deployed:%count%>>%filename%
for /L %%i in (1,1,%count%) do (
   
		@echo Enter the source file:!a_value[%%i]!>>  %filename%
 	
	
)




echo Parameter file has been created and will be deployed the next full hour, on the hour from 9.00 to 16.00.
echo(
echo If you wish to cancel the deployment, remove the "parameter.txt" file in the deployment folder before the next full hour.
echo(
echo  Email will be sent when the deployment has been conducted. Note that the corresponding reload task(s) must be triggered before any changes can be seen by the users when accessing apps through the portal.

goto endoffile
:endoffile
@echo(
pause
exit
endlocal
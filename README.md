# QlikView-Self-Service-Deployment
QlikView Self-Service Deployment using Power-Shell scripts

Description : QlikView is an in-memory, business discovery tool. Which converts data into knowledge. QlikView is a Business Intelligence                  application that helps organizations big and small in data discovery. Now the concept of QlikView Self-Service deployment is                about giving people (QlikView developers) permissions to deploy specific applications (QlikView) to specific environments                  (Dev to Prod).

Pre-requisites for the Process :
	1. Command Prompt 
	2. Windows PowerShell ISE

How to use/Operation : 
  1. 	You must create folders as per the container structure in the Production, where people (Developers) can place file and folders              accordingly.
  2. Go to the location: "\\<server-address \<Common_C>\QlikView Deployment-Inter"
        Note: Here, we are creating one folder (10.Supplying). You can create your own folders.
  3. You need to create one “Deployment” under your created folder (Here we create folder 10. Supporting).
  4. After placing the file and folders, people (developer) need to run the script named “Deploy.cmd” 
  5. As soon as people (developers) triggered the script, it will be going to ask some Boolean input i.e. Y/N. 
  6. Once all the conditions are fulfilled it will generate a “parameter.txt” file which contain all the information related to deployment      such as container name, people (developers)short id of developer, location and name of file and folders that will be deployed.
        Note: Here, people (Developers) actions end. 
  7. We have scheduled another script from server through task scheduler which runs in some period and deployed all the files and folders        placed by the people (Developer) at the development location. 
  8. You need to trigger that scripts to check whether the files are deployed into production from development shared location or not.
  9.	Rollback is possible in here, means it will take backup for any existing application.
  10.	Corresponding logs are there, so that you can check Developer and Admin logs in order to get further clarification.
        Note: In the SolutionNames.txt file, you must add your container name. Ex: we have added 30. Supporting container name in here.
  11.	Finally, you will trigger the Deployment.cmd file.
        Note: If you are not scheduling the Deployment.cmd file from server through Task Scheduler, then only trigger.

$directories = @("Desktop", "Documents", "Downloads")


function Connect-QNAP {
  param (
    [string] $qnapUsername,
    [SecureString] $qnapPassword,
    [PSCredential] $qnapCredentials,
    [string] $qnapIpaddress,
    [string] $usersPath
  )
  
  try {
        Write-Host "-------------------------"
        Write-Host "Network Drive Credential"
        Write-Host "-------------------------"
        $qnapUsername = Read-Host "Enter username"
        $qnapPassword = Read-Host "Enter password" -AsSecureString
        $qnapCredentials = New-Object System.Management.Automation.PSCredential ($qnapUsername, $qnapPassword)
        $qnapIpaddress = Read-Host "Enter network drive IP Address"
        $usersPath = "\\$qnapIpaddress\backup\Awaken\Users"

        
        
        Write-Host "Connecting...Please wait!"
        Start-Sleep -seconds 2
        #create temporary PSDrive
        #New-PSDrive -Name "TempNetworkDrive" -PSProvider FileSystem -Root $usersPath -Credential $qnapCredentials | Out-Null
        $drive = New-PSDrive -Name "TempNetworkDrive" -PSProvider FileSystem -Root $usersPath -Credential $qnapCredentials -ErrorAction Stop | Out-Null

        Write-Host "---------------------------------------------------------"
        Write-Host "Successful connected to the network drive $qnapIpaddress"
        Write-Host "---------------------------------------------------------"
        #Test access -> temporary map a network drive
        #Get-ChildItem -path "TempNetworkDrive:\" -Name

        #After connected, open the menu option
        
      }
    
    
    

      
  catch {
    write-host "Unsuccessful connecting the network drive. Try again!"

  }
}

Connect-QNAP


  

# function Backup-UserData {
#     param (
#         [string]$usersPath,
#         [PSCredential]$qnapCredentials,
#         [string]$qnapIpaddress,
#         [string[]]$directories
#     )
#     try {

#       $usernameExisted = $false
#       while(!($usernameExisted))
      
#       {   
#           #create username's folder
#         $folderName = Read-Host -Prompt "Enter folder name"
        
#         Write-Host "Checking if $folderName folder existed..."
#         Start-Sleep 1
        
#         if(!(Test-Path -Path "$usersPath\$folderName"))
#         {   
#             Write-Host "`nSuccessfully checked!"
#             Start-Sleep 1
#             Write-Host "`nCreating $folderName folder..."
#             Start-Sleep 1
#             foreach($dir in $directories)
#             {   
#                 Write-Host "`t|"
#                 Write-Host  "`t\"

#                 Write-Host "`t   Creating $dir folder..."
#                 start-sleep -second 1
#             }

#             write-host "`nSuccesfully created folders!`n"

#             New-Item -Path $usersPath -Name "$folderName" -ItemType Directory | Out-Null
            
#             #Out-Null is not showing off any information about creating directories
            
#             #create 3 folder Desktop, Documents and Downloads
#             foreach($dir in $directories)
#             {
#                 New-Item -path "$usersPath\$folderName" -Name "$dir" -ItemType Directory
#             }
#             $usernameExisted = $true

#             Write-Host "`n"
  
#           }
#           else
#           {
#               write-host "Folder existed. Try again!`n"
#           }
#       }
  
      
#       $isFolderExisted = $true #flag uf folder existed
  
#       while ($isFolderExisted) {
#           #debug 
#           $username = Read-Host "Enter the folder username in C drive"


#           #get the exact folder for the current logged in user to start the copy process
#           #$username = $env:Username
  
#           Write-Host "Checking if $username folder existed..."
#           Start-Sleep 1
  
#           if((Test-Path -Path "C:\Users\$username\"))
#           {
#               Write-Host "Successfully checked!"
#               Start-Sleep 1
#               foreach($dir in $directories)
#               {
#                   Write-Host "Copying $dir...`nPlease wait!..."
#                   Start-Sleep -seconds 1.5
  
#                   robocopy "C:\Users\$username\$dir\" "$usersPath\$folderName\$dir\" /e /r:0 /w:0 /njs /eta
#                   # /e copies subdirectories and include empty directories
#                   # /r retry times default is 1million
#                   # /w wait time after the failed to copy
#                   # /eta estimate time
#                   # /nfl no file will be listed
#                   # /ndl no directories will be listed
  
              
#               }
  
#               $isFolderExisted = $false #if folder does not exist, stop the loop


#               Write-Host "----------------------------"
#               Write-Host "Successfully backed up data!"
#               Write-Host "----------------------------"
      
              
#               Write-Host "Press any key to continue..."
#               $null = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown") #this a press any key to continue
              
#           }
#           else {
#               Write-Host "Folder <$username> does not exists. Try again!"
#           }
#     }
#   } 
    
#   catch {
#       write-host "Unsuccessful backup user's data..."
#   }
        
# }    

# function Restore-UserData {
#   param (
    
    
#     [string] $usersPath,
#     [pscredential] $qnapCredentials,
#     [string]$qnapIpaddress,
#     [string[]]$directories
    
    
#   )


  
#   $usersPath = "\\$qnapIpaddress\backup\Awaken\Users"
  

#   Write-Host "`n Starting restore data..."
#   Start-Sleep 1
  
#   $folderName = Read-Host -Prompt "Enter folder name on QNAP"
#   Write-Host "Checking if $folderName folder exists"
#   Start-Sleep 1

#   if(!(Test-Path -Pth "$usersPath\$folderName"))
#   {
#     Write-Host "`Successfully checked"
#     Start-Sleep 1

#     #debug
#     $destinationFolder = Read-Host -promt "Enter destination folder"

#     foreach ($dir in $directories)
#     {
#       Write-Host "Restoring $dir...`nPlease wait!..."
      
#       robocopy "$userPath\$folderName\$dir" "C:\Users\Desktop\Test restore\$destinationFolder\$dir\" /e /r:0 /w:0 /njs /eta
#     }
    
#   }

#   Write-Host "----------------------------"
#   Write-Host "Successfully restored data!"
#   Write-Host "----------------------------"

#   Write-Host "Press any key to continue..."
#   $null = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
    
# }
  
  


# function Open-Menu {
#     param (
#         $option
#     )

#     while ($true) {
#         Write-Host "`n----------------------"
#         Write-Host "Enter (1) to Backup"
#         Write-Host "Enter (2) to Restore"
#         Write-Host "Enter (3) to Exit"
#         Write-Host "----------------------"
    
    
#         $option = Read-Host "Enter option"
    
#         if ($option -eq "1") {
#             Backup-UserData -usersPath $usersPath -qnapCredentials $qnapCredentials -qnapIpaddress $qnapIpaddress -directories $directories
            
            
#         }
#         elseif ($option -eq "2") {
#             Restore-UserData -usersPath $usersPath -qnapCredentials $qnapCredentials -qnapIpaddress $qnapIpaddress -directories $directories
    
#         }
#         elseif ($option -eq "3") {
#             #remove temporary mapped networkdrive
#             try {
#               remove-PSDrive -Name "TempNetworkDrive"
#               break
#             }
#             catch {
#               Write-Host "Something went wrong. Unable to remove the TempNetworkDrive"
#             }
            
#         }
#         else {
#             Write-Host "Invalid. Try again!"
#         }
        
#     }
    
# }









$directories = @("Desktop", "Documents", "Downloads")
#this path is a user path on QNAP
$usersPath = "\\$qnapIpaddress\backup\Awaken\Users"



function Connect-QNAP {
    param (
        [string] $qnapUsername,
        [SecureString] $qnapPassword,
        [PSCredential] $qnapCredentials,
        [string] $qnapIpaddress,
        [string] $usersPath
    )

    $isSuccess = $true

    while (($isSuccess))
    {
        try{
            Write-Host "-------------------------"
            Write-Host "Network Drive Credential"
            Write-Host "-------------------------"
    
            
            $qnapUsername = Read-Host "Enter username"
            $qnapPassword = Read-Host "Enter password" -AsSecureString #-AsSecureSring will hidden the password when we are typing
            $qnapCredentials = New-Object System.Management.Automation.PSCredential ($qnapUsername, $qnapPassword)
            $qnapIpaddress = Read-Host "Enter network drive IP Address"
    
            Write-Host "Connecting...Please wait!"
            Start-Sleep -seconds 1
            
            #New-PSDrive -Name "TempNetworkDrive" -PSProvider FileSystem -Root $usersPath -Credential $qnapCredentials | Out-Null
            
            #create temporary PSDrive for mapping
            
            $drive = New-PSDrive -Name "TempNetworkDrive" -PSProvider FileSystem -Root $usersPath -Credential $qnapCredentials -ErrorAction Stop | Out-Null
            Write-Host $drive
            

            Write-Host "---------------------------------------------------------"
            Write-Host "Successfully connected to the network drive $qnapIpaddress"
            Write-Host "---------------------------------------------------------"
                
            $isSuccess = $false
        }
    
        catch{
            Write-Host "Unsuccessfull connect the network drive."
            Write-Host "Wrong username/password or network ip address. Try again!"
            
        }
    }
    
    
}
#call Connect-QNAP function



function Backup-UserData {
    # param (
    #     [string]$usersPath,
    #     [PSCredential]$qnapCredentials,
    #     [string]$qnapIpaddress,
    #     
    # )
    try {
        
    
        $usernameExisted = $false
        while(!($usernameExisted))
        {   
            #create username's folder on QNAP -> for debug and testing, please use the code below
            $userFolderName = Read-Host -Prompt "Enter folder name"

            #this will get the exact folder name of the current user is logging
            #$userFolderName = $env:Username

            
            Write-Host "Checking if $userFolderName folder existed..."
            Start-Sleep 1


            
            if(!(Test-Path -Path "$usersPath\$userFolderName"))
            {   
                Write-Host "`nSuccessfully checked!"
                Start-Sleep 1
                Write-Host "`nCreating $userFolderName folder..."
                Start-Sleep 1
                foreach($dir in $directories)
                {   
                    Write-Host "`t|"
                    Write-Host  "`t\"

                    Write-Host "`t   Creating $dir folder..."
                    start-sleep -second 1
                }
    
                write-host "`nSuccesfully created folders!`n"
    
                New-Item -Path $usersPath -Name "$userFolderName" -ItemType Directory | Out-Null
                
                #Out-Null is not showing off any information about creating directories
                
                #create 3 folder Desktop, Documents and Downloads
                foreach($dir in $directories)
                {
                    New-Item -path "$usersPath\$userFolderName" -Name "$dir" -ItemType Directory
                }
                $usernameExisted = $true
    
                Write-Host "`n"
    
            }
            else
            {
                write-host "Folder existed!`n"
                $newFolder = Read-Host "Enter new folder name"

                $userFolderName = $newFolder
            }
        }
    
        
        #check the folder in C drive

        $isFolderExisted = $true #flag if folder existed
    
        while ($isFolderExisted) {
            #debug -> This is just for debug to test out
            $username = Read-Host "Enter the folder username in C drive"


            #Turn off this will get the exact folder for the current logged in user to start the copy process
            #$userFolderName = $env:Username
    
            Write-Host "Checking if $username folder existed..."
            Start-Sleep 1
    
            if((Test-Path -Path "C:\Users\$username\"))
            {
                Write-Host "Successfully checked!"
                Start-Sleep 1
                foreach($dir in $directories)
                {
                    Write-Host "Copying $dir...`nPlease wait!..."
                    Start-Sleep -seconds 1.5
    
                    robocopy "C:\Users\$username\$dir\" "$usersPath\$folderName\$dir\" /e /r:0 /w:0 /njs /eta
                    # /e copies subdirectories and include empty directories
                    # /r retry times default is 1million
                    # /w wait time after the failed to copy
                    # /eta estimate time
                    # /nfl no file will be listed
                    # /ndl no directories will be listed
    
                
                }
    
                $isFolderExisted = $false #if folder does not exist, stop the loop


                Write-Host "----------------------------"
                Write-Host "Successfully backed up data!"
                Write-Host "----------------------------"
        
                
                Write-Host "Press any key to continue..."
                $null = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown") #this a press any key to continue
                
            }
            else {
                Write-Host "Folder <$username> does not exists. Try again!"
            }
        }
        
        
    }
    catch {
        #try to access the network folder just entered the IP address here. If success write-host successful else unsucessful
        write-host "Unsuccessful backup the data. Try again!"
    }
}


function Restore-UserData {
    # param (
    #     OptionalParameters
    # )

    try {

    
        Write-Host "`nStarting restore data..."
        Start-Sleep 1
        
        #this is for debug and testing
        $userFolderName = Read-Host "Enter name of the folder on QNAP"
        Write-Host "Checking if $userFolderName existed"
        Start-Sleep 1

        if (!(Test-Path -path "$usersPath\$userFolderName"))
        {
            Write-Host "`nSuccessfully checked"
            Start-Sleep 1
        }

        #this is for debug and testing
        $destinationFolder = Read-Host "Enter name of folder destination"

        foreach ($dir in $directories)
        {
            Write-Host "Restoring $dir...`nPlease wait!..."

            #this is for testing
            robocopy "\\11.0.0.53\Backup\Awaken\Users\$userFolderName\$dir" "C:\Users\Desktop\$destinationFolder\$dir" /e /r:0 /w:0 /njs /eta /copy:dat
        }

        Write-Host "----------------------------"
        Write-Host "Successfully restored data!"
        Write-Host "----------------------------"

        Write-Host "Press any key to continue..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
    }
    catch{
        write-host "Unsuccessful restore the data. Try again!"
    }
}


function Main {
    param (
        $option
    )

    while ($true) {
        Write-Host "`n----------------------"
        Write-Host "Enter (1) to Backup"
        Write-Host "Enter (2) to Restore"
        Write-Host "Enter (3) to Exit"
        Write-Host "----------------------"
    
    
        $option = Read-Host "Enter option"
    
        if ($option -eq "1") {
            Backup-UserData 
        }
        elseif ($option -eq "2") {
            Restore-UserData
    
        }
        elseif ($option -eq "3") {
            #remove temporary mapped networkdrive
            remove-PSDrive -Name "TempNetworkDrive" -ErrorAction Ignore
            break
        }
        else {
            Write-Host "Invalid. Try again!"
        }
        
    }
    
}

Connect-QNAP

Main
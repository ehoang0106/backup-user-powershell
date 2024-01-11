

$qnapPath = "\\11.0.0.53\backup\Awaken\Users"
$directories = @("Desktop", "Documents", "Downloads")

function Connect-QNAP {
    param (
   
        [string] $qnapPath
    )
    $isComplete = $false

    while(!($isComplete))
    {
        try {
            Write-Host "-------------------------"
            Write-Host "Network Drive Credential"
            Write-Host "-------------------------"
            $qnapUsername = Read-Host "Enter username"
            $qnapPassword = Read-Host "Enter password" -AsSecureString
            $qnapCredentials = New-Object System.Management.Automation.PSCredential ($qnapUsername, $qnapPassword)
    
            Write-Host "Connecting...Please wait!"
            Start-Sleep -seconds 2
            #create temporary PSDrive
            
            $tempDrive = New-PSDrive -Name "TempNetworkDrive" -PSProvider FileSystem -Root $qnapPath -Credential $qnapCredentials -ErrorAction Stop | Out-Null
            Write-Host $tempDrive

            Write-Host "---------------------------------------------------------"
            Write-Host "Successful connected to the network drive"
            Write-Host "---------------------------------------------------------"
            
            
    
            $isComplete = $true
            
        }
        
        catch {
        write-host "Unsuccessful connecting the network drive. Try again!"
    
      }
    }
}
    

function Backup-UserData {
    param (
        [string]$qnapPath,
        [string[]]$directories
    )
    try {
        $usernameExisted = $false
        while(!($usernameExisted))
        {   
            #this will get the exact folder name of the current user is logging
            $userFolderName = (Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty username).split('\') | Select-Object -Last 1


            Write-Host "Checking if $userFolderName folder existed..."
            Start-Sleep 1
            
            if(!(Test-Path -Path "$qnapPath\$userFolderName"))
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
    
                New-Item -Path $qnapPath -Name "$userFolderName" -ItemType Directory | Out-Null
                
                #Out-Null is not showing off any information about creating directories
                
                #create 3 folder Desktop, Documents and Downloads
                foreach($dir in $directories)
                {
                    New-Item -path "$qnapPath\$userFolderName" -Name "$dir" -ItemType Directory
                }
                $usernameExisted = $true
    
                Write-Host "`n"
            }
            else
            {
                
                write-host "Folder existed!`n"
                $userFolderName = Read-Host "Enter different folder name"
                if(!(Test-Path -Path "$qnapPath\$userFolderName"))
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
        
                    New-Item -Path $qnapPath -Name "$userFolderName" -ItemType Directory | Out-Null
                    
                    #Out-Null is not showing off any information about creating directories
                    
                    #create 3 folder Desktop, Documents and Downloads
                    foreach($dir in $directories)
                    {
                        New-Item -path "$qnapPath\$userFolderName" -Name "$dir" -ItemType Directory
                    }
                    $usernameExisted = $true
        
                    Write-Host "`n"
                }
                
            }
        }
    
        

        $isFolderExisted = $true #flag if folder existed
    
        while ($isFolderExisted) {
            
            $userFolderName = (Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty username).split('\') | Select-Object -Last 1
    
            Write-Host "Checking if $userFolderName folder existed..."
            Start-Sleep 1
    
            if((Test-Path -Path "C:\Users\$userFolderName\"))
            {
                Write-Host "Successfully checked!"
                Start-Sleep 1
                foreach($dir in $directories)
                {
                    Write-Host "Copying $dir...`nPlease wait!..."
                    Start-Sleep -seconds 1.5 
                    robocopy "C:\Users\$userFolderName\$dir\" "$qnapPath\$userFolderName\$dir\" /e /r:0 /w:0 /njs /eta
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
                Write-Host "Folder <$userFolderName> does not exists."
            

            }
        }
    }
    catch {
        #try to access the network folder just entered the IP address here. If success write-host successful else unsucessful
        write-host "Unsuccessful backup the data. Try again!"
    }
}



function Restore-UserData {
    param (
        [string] $qnapPath,
        [string[]]$directories
    )

    try {
        Write-Host "`nStarting restore data..."
        Start-Sleep 1
        
        $usernameExisted = $false
        
        

        while (!($usernameExisted)) {
            $userFolderName = Read-Host "Enter name of the folder will be restored on QNAP"
            Write-Host "Checking if $userFolderName existed"
            Start-Sleep 1

            if ((Test-Path -path "$qnapPath\$userFolderName"))
            {
                Write-Host "`nSuccessfully checked. Folder $userFolderName exists."
                Write-Host
                Start-Sleep 1

                #get current user's folder logging
                $destinationFolder = (Get-WmiObject -Class Win32_ComputerSystem | Select-Object -ExpandProperty username).split('\') | Select-Object -Last 1

            
                foreach ($dir in $directories)
                {
                    Write-Host "Restoring $dir...`nPlease wait!..."
                    Start-Sleep 2
                    robocopy "$qnapPath\$userFolderName\$dir" "C:\Users\$destinationFolder\$dir" /e /r:0 /w:0 /njs /eta /copy:dat
                }
                $usernameExisted = $true

                Write-Host "----------------------------"
                Write-Host "Successfully restored data!"
                Write-Host "----------------------------"
                Write-Host "Press any key to continue..."
                $null = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
            }
            else {
                write-host "Folder does not exist!`n"
                
            }    
            
            
        }
        
    }
    catch{
        write-host "Unsuccessful restore the data. Try again!"
    }
}



function Backup-Menu {

    while($true){
        Write-Host "`n----------------------"
        Write-Host "Enter (1) to Backup"
        Write-Host "Enter (2) to Restore"
        Write-Host "Enter (3) to Exit"
        Write-Host "----------------------"

        $option = Read-Host "Enter option"


        if ($option -eq "1"){
            Backup-UserData -qnapPath $qnapPath -directories $directories
        }
        elseif ($option -eq "2"){
            Restore-UserData -qnapPath $qnapPath -directories $directories
        }
        elseif ($option -eq "3") {
            Remove-PSDrive -Name "TempNetworkDrive" -ErrorAction Ignore
            break
        }
        else {
            Write-Host "Invalid input. Try again!"
        }
    }
    

}



Connect-QNAP -qnapPath $qnapPath


Backup-Menu
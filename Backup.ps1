Write-Host "----------------"
Write-Host "Network Drive Credential"
Write-Host "----------------"
$qnapUsername = Read-Host "Enter username"
$qnapPassword = Read-Host "Enter password" -AsSecureString
$qnapCredentials = New-Object System.Management.Automation.PSCredential ($qnapUsername, $qnapPassword)
$qnapIpaddress = Read-Host "Enter network drive IP Address"
$usersPath = "\\$qnapIpaddress\backup\Awaken\Users"


$directories = 'Desktop', 'Documents', 'Downloads'


#try to access the network folder just entered the IP address here. If success write-host successful else unsucessful
try {
    Write-Host "Connecting...Please wait!"
    Start-Sleep -seconds 2
    #create temporary PSDrive
    New-PSDrive -Name "TempNetworkDrive" -PSProvider FileSystem -Root $usersPath -Credential $qnapCredentials | Out-Null
    Write-Host "----------------------------------------"
    Write-Host "Successful connected to the network drive $qnapIpaddress"
    Write-Host "----------------------------------------"
    #Test access -> temporary map a network drive
    #Get-ChildItem -path "TempNetworkDrive:\" -Name

    #Remove the network drive after done
    remove-PSDrive -Name "TempNetworkDrive"



    $usernameExisted = $false
    while(!($usernameExisted))
    {   
        #create username's folder
        $folderName = Read-Host -Prompt "Enter folder name"
        Write-Host "Creating $folderName folder..."
        Start-Sleep 2
        foreach($dir in $directories)
        {
            Write-Host "Creating $dir folder..."
            start-sleep -second 1.5
        }

        if(!(Test-Path -Path "$usersPath\$folderName"))
        {
            
            New-Item -Path $usersPath -Name "$folderName" -ItemType Directory | Out-Null
            
            
            #create 3 folder Desktop, Documents and Downloads
            foreach($dir in $directories)
            {
                New-Item -path "$usersPath\$folderName" -Name "$dir" -ItemType Directory
            }
            $usernameExisted = $true

            write-host "Succesfully created folders!"
        }
        else
        {
            write-host "Username existed. Try again!"
        }
    }

    #copy folder from "C:\Users\<Username>, but only copy 3 main folders which is Desktop, Downloads, and Documents"
    $folderExisted = $false

    while (!($folderExisted)) {
        $username = Read-Host "Enter the folder username in C drive"


        if((Test-Path -Path "C:\Users\$username\"))
        {
            foreach($dir in $directories)
            {
                Copy-Item "C:\Users\$username\$dir\*" -Destination "$usersPath\$folderName\$dir\" -Recurse 
                Write-Host "Copying $dir..."
                Start-Sleep -seconds 1.5

            }
            $folderExisted = $true
            Write-Host "----------------------------"
            Write-Host "Successfully backed up data!"
            Write-Host "----------------------------"

            Write-Host "Press any key to exit..."
            $null = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
            
        }
        else {
            Write-Host "Folder <$username> does not exists. Try again!"
        }
    }
    
    
}
catch {
    write-host "Unsuccessful connecting the network drive. Try again!"
}













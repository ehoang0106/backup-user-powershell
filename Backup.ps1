$qnap_username = Read-Host "Enter username: "
$qnap_password = Read-Host "Enter password: " -AsSecureString
$qnap_credentials = New-Object System.Management.Automation.PSCredential ($qnap_username, $qnap_password)
$qnap_ipaddress = Read-Host "Enter network IP Address: "
$users_path = "\\$qnap_ipaddress\backup\Awaken\Users"

#try to access the network folder just entered the IP address here. If success write-host successful else unsucessful
try {
    #create temporary PSDrive
    New-PSDrive -Name "TempNetworkDrive" -PSProvider FileSystem -Root $users_path -Credential $qnap_credentials
    Write-Host "Successful connected to the network drive"
    Write-Host "----------------------------------------"
    #Test access
    Get-ChildItem -path "TempNetworkDrive:\" -Name

    $username_existed = $false
    while(!($username_existed))
    {   
        #create username's folder
        $username = Read-Host -Prompt "Enter username folder: "
        if(!(Test-Path -Path $users_path))
        {
            
            New-Item -Path $users_path -Name "$username" -ItemType Directory
            
            
            #create 3 folder Desktop, Documents and Downloads
            $directories = 'Desktop', 'Documents', 'Downloads'
            foreach($dir in $directories)
            {
                New-Item -path $users_path -Name "$dir" -ItemType Directory
            }
            $username_existed = $true
        }
        else
        {
            write-host "Username existed. Try again!"
        }
    }



    remove-PSDrive -Name "TempNetworkDrive"
}
catch {
    write-host "Unsuccessful connecting the network drive. Try again!"
}













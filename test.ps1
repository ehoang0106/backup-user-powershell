Write-Host "----------------"
Write-Host "Network Drive Credential"
Write-Host "----------------"

function verifyCredential {
    param (
       [string] $qUsername, [SecureString] $qPassword 
    )

    # $qUsername = Read-Host "Username"
    # $qPassword = Read-Host "Password"

    $qCredentials = New-Object System.Management.Automation.PSCredential ($qUsername, $qPassword)

    return $qCredentials
}

function qnapPath {
    param (
        [int] $qIpaddress
    )

    return $qIpaddress
}

function userPath {
    param (
        [int] $qIpaddress
    )
    
    return $usersPath = "\\$qIpaddress\backup\Awaken\Users" 
}

try {
    


    $username = Read-Host "Username"
    $password = Read-Host "Password"
    $qCredentials = verifyCredential($username, $qPassword)
    $ipaddress = qnapPath(Read-Host "IP Address")
    $user_path = userPath($ipaddress)
    


    Write-Host "Connecting...Please wait!"
    Start-Sleep -seconds 2



    New-PSDrive -Name "TempNetworkDrive" -PSProvider FileSystem -Root $users_path -Credential $qCredential | Out-Null
    Write-Host "----------------------------------------"
    Write-Host "Successful connected to the network drive $ipaddress"
    Write-Host "----------------------------------------"
}
catch {
    write-host "Unsuccessful connecting the network drive. Try again!"
}













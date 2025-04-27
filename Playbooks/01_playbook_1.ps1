<#
    1. Connects to a server and reboot it
    2. Wait for the server to be back up
    3. Check the service if it is running
    4. Emails if something failed
    5. Checkin to WSUS
#>

# Define server and email details
[CMDLetBinding()]
param(
    $serviceName,
    $server,
    $emailFrom = "notifier@theitrx.com",
    $emailTo = "jocel@theitrx.com",
    $smtpServer = "smtp.theitrx.local"
)

# Function to send email
function Send-Email {
    param (
        [string]$subject,
        [string]$body
    )
    $message = New-Object system.net.mail.mailmessage
    $message.from = $emailFrom
    $message.To.add($emailTo)
    $message.Subject = $subject
    $message.Body = $body
    $smtp = New-Object Net.Mail.SmtpClient($smtpServer)
    $smtp.Send($message)
}

# Connect to the server and reboot it
Restart-Computer -ComputerName $server -Force -Wait -Timeout 300

# Wait for the server to be back up
while (!(Test-Connection -ComputerName $server -Count 4 -Quiet)) {
    Start-Sleep -Seconds 10
}

# Check if the service is running and ensure its startup type is automatic

$service = Get-Service -ComputerName $server -Name $serviceName
if ($service.StartType -ne 'Automatic') {
    Set-Service -ComputerName $server -Name $serviceName -StartupType Automatic
    Write-Output "The $serviceName service startup type was set to Automatic on $server."
}

if ($service.Status -ne 'Running') {
    Start-Service -InputObject $service
    $service = Get-Service -ComputerName $server -Name $serviceName # Refresh service status
    if ($service.Status -ne 'Running') {
        Send-Email -subject "Service Start Failed" -body "Failed to start the $serviceName service on $server."
    } else {
        Write-Output "The $serviceName service was successfully started on $server."
    }
} else {
    Write-Output "The $serviceName service is already running on $server."
}


# Checkin to WSUS

# WIndows Server 2016 VErsion
[version]$ws2016Vers = '10.0.0.0'

get-service wuauserv | restart-service
$updateSession = new-object -com "Microsoft.Update.Session";
$updates=$updateSession.CreateupdateSearcher().Search("IsHidden=0 and IsInstalled=0").Updates

# if Windows Server 2016 or below
if([environment]::OSVersion.Version -lt $ws2016Vers){
    wuauclt /detectnow /resetauthorization /reportnow

}
# Server 2016 and above
else{
    wuauclt /detectnow /resetauthorization /reportnow
    (New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()  
    c:\windows\system32\UsoClient.exe startscan
}



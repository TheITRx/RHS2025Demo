

#Requires -Module Ansible.ModuleUtils.Legacy
#AnsibleRequires -CSharpUtil Ansible.Basic


#AnsibleRequires -PowerShell ansible_collections.mynamespace.windows.plugins.module_utils.helpers
#AnsibleRequires -PowerShell ansible_collections.mynamespace.windows.plugins.module_utils.specs

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

#merge specs specific to this function and the base specs in the module_utils

$module = [Ansible.Basic.AnsibleModule]::Create($args,@{})
$module.result.values = @{}

try{
    # WIndows Server 2016 VErsion
    [version]$ws2016Vers = '10.0.0.0'

    get-service wuauserv | restart-service
    
    $updateSession = new-object -com "Microsoft.Update.Session";
    $updates=$updateSession.CreateupdateSearcher().Search("IsHidden=0 and IsInstalled=0").Updates

    # if Windows Server 2016 or below
    if([environment]::OSVersion.Version -lt $ws2016Vers){
        wuauclt /detectnow /resetauthorization /reportnow
        $checkin_metchod = 'legacy'

    }

    else{
        wuauclt /detectnow /resetauthorization /reportnow
        (New-Object -ComObject Microsoft.Update.AutoUpdate).DetectNow()  
        c:\windows\system32\UsoClient.exe startscan
        $checkin_metchod = 'modern'
    }

    $module.result.values = @{
        "result_message" = "Checkin initiated"
        "result_method" = $checkin_metchod
        "result_code" = 0
        
    }
    $module.exitjson()
}

catch{

    $module.failjson("Error executing the main function",$_);
}
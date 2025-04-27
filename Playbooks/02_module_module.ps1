

#Requires -Module Ansible.ModuleUtils.Legacy
#AnsibleRequires -CSharpUtil Ansible.Basic


#AnsibleRequires -PowerShell ansible_collections.guggenheim.wsusserver.plugins.module_utils.helpers
#AnsibleRequires -PowerShell ansible_collections.guggenheim.wsusserver.plugins.module_utils.specs

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

#merge specs specific to this function and the base specs in the module_utils

$argspec = @{
    options = @{
        name       = @{ type = "str"; required = $true }
        gender     = @{ type = "str"; required = $true }
        email      = @{ type = "str"; required = $true }
        status = @{ type = "str"; required = $true }
    }
}

$module = [Ansible.Basic.AnsibleModule]::Create($args, $argspec)
$module.result.user_created = @{}

# Input Variables

$name = $module.params.name
$gender = $module.params.gender
$email = $module.params.email
$status = $module.params.status

# Define the URL and headers
$url = "https://gorest.co.in/public/v2/users"
$headers = @{
    "Accept"        = "application/json"
    "Content-Type"  = "application/json"
    "Authorization" = "Bearer 32646123a8dce5a1c59f4db3beb5bba928b0b92676d57ff7bf1c449d6a693cb6"
}

# Define the JSON payload
$body = @{
    "name"   = $name
    "gender" = $gender
    "email"  = $email
    "status" = $status
} | ConvertTo-Json

# Make the POST request

$response = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $body
if($response){
    $module.result.user_created['user'] = $response 
    $module.result.user_created['result_code'] = 0
    $module.result.user_created['result_message'] = "User Created Successfully"
    $module.result.user_created['status'] = "success"
}

$module.exitjson()
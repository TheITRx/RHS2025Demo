#Requires -Module Ansible.ModuleUtils.Legacy
#AnsibleRequires -CSharpUtil Ansible.Basic


#AnsibleRequires -PowerShell ansible_collections.guggenheim.sccm.plugins.module_utils.helpers
#AnsibleRequires -PowerShell ansible_collections.guggenheim.sccm.plugins.module_utils.specs

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

#merge specs specific to this function and the base specs in the module_utils

$params = @{}
$module = [Ansible.Basic.AnsibleModule]::Create($args,$(Get-GuggenheimSCCMDeviceCollectionDirectMembershipRule))
$module.result.result = @{}

# Input Variables
$computername = $module.params.computername
$CollectionName = $module.params.CollectionName
$State = $module.params.state

# Don't touch beyond this point


Invoke-SCCMGetDevice

try{
    if($State -eq 'absent'){

        if($exist_check){
            $result = Get-CMDeviceCollection -name $CollectionName | Remove-CMDeviceCollectionDirectMembershipRule -ResourceId $cm_device.ResourceID -Force
            $module.result.changed = $true
            $module.result.result['command_output'] = 'Removed Successfully'

        }
        else{
            $module.result.changed = $false
            $module.result.result['command_output'] = 'Not present in the current device collection.'
        }
    }

    if($State -eq 'present'){

        if($exist_check){
            $module.result.changed = $false
            $module.result.result['command_output'] = 'Already existing in the device collection.'
            $module.result.result['membership_rule_name'] = $exist_check.RuleName
        }
        else{

            while(
                $null -eq (Get-CMDeviceCollectionDirectMembershipRule -Name $CollectionName | ? {$_.rulename -eq $computername })
            ){
                $result = Get-CMDeviceCollection -name $CollectionName | Add-CMDeviceCollectionDirectMembershipRule -ResourceId $cm_device.ResourceID -Force
            }

            $module.result.changed = $true
            $module.result.result['command_output'] = 'Added Successfully.'
            $module.result.result['result_code'] = 0
        }
        
    }

    $module.exitjson()
}
catch{
    $module.failjson("Error sending the SCCM command")
}
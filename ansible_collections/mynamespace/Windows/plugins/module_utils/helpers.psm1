Function Invoke-SCCMGetDevice {
    try {
    $SiteCode = "GP1" # Site code 
    $ProviderMachineName = "IL1SCCM01.domain.local" # SMS Provider machine name

    $initParams = @{}

    if((Get-Module ConfigurationManager) -eq $null) {
    Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams 
    }

    # Connect to the site's drive if it is not already present
    if((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) {
    New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
    }

    # Set the current location to be the site code.
    Set-Location "$($SiteCode):\" @initParams
    }
    catch  {
        $module.failjson("Error initiating SCCM Powershell module.")
    }

    # Check if device exist
    $cm_device = Get-CMDevice -Name $computername

    if(!$cm_device){
        $module.failjson("Failure! Computer not found.")
    }
    else{
        $module.result.result['computer_resource_id'] = $cm_device.ResourceID
    }

    # get if collection exist

    $coll_obj = Get-CMDeviceCollection -name $CollectionName 

    if(!$coll_obj){
        $module.failjson("Failure! Device Collection not found.")
    }
    else{
        $module.result.result['collection_id'] = $coll_obj.CollectionID
    }

    $exist_check = Get-CMDeviceCollectionDirectMembershipRule -Name $CollectionName | ? {$_.rulename -eq $computername }

}
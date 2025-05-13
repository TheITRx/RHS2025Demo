Function Get-GuggenheimSCCMDeviceCollectionDirectMembershipRule {
    @{
        options = @{
            computername = @{ type = "str"; required = $true}
            CollectionName = @{ type = "str"; required = $true}
            State = @{ type = "str"; choices = 'absent', 'present'}
        }
    }
}



$exportMembers = @{
    Function = @(
        "Get-GuggenheimSCCMDeviceCollectionDirectMembershipRule"
            ) 
}
Export-ModuleMember @exportMembers
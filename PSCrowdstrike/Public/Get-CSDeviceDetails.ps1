function Get-CSDeviceDetails {
    <#
    .SYNOPSIS
        Function to retrieve host info from Crowdstrike via /devices/queries/devices/v1 and
        /devices/entities/devices/v1 endpoint.
    .DESCRIPTION
        This function provides a way to retrieve using common parameters required by PSCrowdstrike.
    .EXAMPLE
        PS C:\> Get-CSDeviceDetails -Computername "DC1"
        Retrieves host information (OS, OU, Domain, etc) for DC1 from Crowdstrike API.
    .INPUTS
        None
    .PARAMETER Hostname
        The hostname you would like to query.
    .OUTPUTS
        None
    .NOTES
        None
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $HostName
    )

    begin {
        $DeviceEndpoint = "/devices/queries/devices/v1?filter=hostname%3A'{0}'" -f $HostName
    }

    process {
        $AgentID = Invoke-CSRestMethod -Endpoint $DeviceEndpoint -Method "GET" | Select-Object -ExpandProperty Resources

        $EntityEndpoint = "/devices/entities/devices/v1?ids=$AgentID"

        $Output = Invoke-CSRestMethod -Endpoint $EntityEndpoint -Method "GET" | Select-Object -ExpandProperty Resources
    }

    end {
        $Output
    }
}

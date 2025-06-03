function Get-CWSCSessionsByName {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name
    )

    $Endpoint = 'GetSessionsByName'

    Invoke-CWSCSearchMaster -Arguments $PsBoundParameters -Endpoint $Endpoint
}
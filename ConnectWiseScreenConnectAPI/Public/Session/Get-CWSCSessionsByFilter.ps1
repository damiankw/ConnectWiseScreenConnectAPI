function Get-CWSCSessionsByFilter {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Filter
    )

    $Endpoint = 'GetSessionsByFilter'

    Invoke-CWSCSearchMaster -Arguments $PsBoundParameters -Endpoint $Endpoint
}
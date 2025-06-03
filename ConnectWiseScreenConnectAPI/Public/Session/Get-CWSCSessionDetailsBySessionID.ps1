function Get-CWSCSessionDetailsBySessionID {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$SessionID
    )

    $Endpoint = 'GetSessionDetailsBySessionID'

    Invoke-CWSCSearchMaster -Arguments $PsBoundParameters -Endpoint $Endpoint
}
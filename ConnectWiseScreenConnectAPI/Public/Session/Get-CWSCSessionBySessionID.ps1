function Get-CWSCSessionBySessionID {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$SessionID
    )

    $Endpoint = 'GetSessionBySessionID'

    Invoke-CWSCSearchMaster -Arguments $PsBoundParameters -Endpoint $Endpoint
}
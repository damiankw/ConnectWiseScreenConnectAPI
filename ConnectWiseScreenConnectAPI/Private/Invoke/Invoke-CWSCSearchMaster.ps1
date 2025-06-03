function Invoke-CWSCSearchMaster {
    [CmdletBinding()]
    param (
        $Arguments,
        [string]$Endpoint
    )

    $Body = @{}
    switch ($Arguments.Keys) {
        'name' { $Body = @($Arguments['name']) }
        'sessionid' { $Body = @($Arguments['sessionid']) }
        'filter' { $Body = @($Arguments['filter']) }
    }
    $Body = ConvertTo-Json $Body -Depth 100

    $Uri = New-CWSCUrl -Endpoint $Endpoint

    $WebRequestArguments = @{
        Uri    = $Uri
        Method      = 'POST'
        ContentType = 'application/json; charset=utf-8' #needed for accented chars
        Body        = $Body
        Headers     = $script:CWSCServerConnection.Headers
    }

    $Result = Invoke-CWSCWebRequest -Arguments $WebRequestArguments
    if ($Result.content) {
        $Result = $Result.content | ConvertFrom-Json
    }

    $Result | Write-Output
}
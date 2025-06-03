function Invoke-CWSCWebRequest {
    [CmdletBinding()]
    param(
        $Arguments,
        [int]$MaxRetry = 5
    )

    # Check that we have cached connection info
    if (!$script:CWSCServerConnection) {
        $ErrorMessage = @()
        $ErrorMessage += 'Not connected to a Manage server.'
        $ErrorMessage += '--> $CWSCServerConnection variable not found.'
        $ErrorMessage += "----> Run 'Connect-CWSC' to initialize the connection before issuing other CWSC cmdlets."
        return Write-Error ($ErrorMessage | Out-String)
    }

    # Check URI format
    if ($Arguments.URI -notlike '*`?*' -and $Arguments.URI -like '*`&*') {
        $Arguments.URI = $Arguments.URI -replace '(.*?)&(.*)', '$1?$2'
    }

    # Issue request
    try {
        Write-Debug "Arguments: $($Arguments | ConvertTo-Json)"
        $prevProgressPreference = $global:ProgressPreference
        $global:ProgressPreference = 'SilentlyContinue'

        $Result = Invoke-WebRequest @Arguments -UseBasicParsing -AllowInsecureRedirect

        $global:ProgressPreference = $prevProgressPreference
    }
    catch {
        $global:ProgressPreference = $prevProgressPreference

        # Start error message
        $ErrorMessage = @()

        if ($_.Exception.Response) {
            try {
                # Read exception response
                #this can fail with some type of exceptions
                $ErrorStream = $_.Exception.Response.GetResponseStream()
                $Reader = New-Object System.IO.StreamReader($ErrorStream)
                $script:ErrBody = $Reader.ReadToEnd() | ConvertFrom-Json
            }
            catch {
                $script:ErrBody = $_.Exception.Response.Content
            }
            $ErrBody = $script:ErrBody
            if ($ErrBody.code) {
                $ErrorMessage += 'An exception code has been thrown.'
                $ErrorMessage += "--> $($ErrBody.code)"
                if ($ErrBody.code -eq 'Unauthorized') {
                    $ErrorMessage += "-----> $($ErrBody.message)"
                    $ErrorMessage += "-----> Use 'Disconnect-CWSC' or 'Connect-CWSC -Force' to set new authentication."
                }
                elseif ($ErrBody.code -eq 'ConnectWiseApi') {
                    switch ($ErrBody.message) {
                        'UserNotAuthenticated' {
                            $ErrorMessage += "-----> $($ErrBody.message)"
                            $ErrorMessage += '-----> Check your connection parameters and/or user permissions.'
                        }
                        Default {
                            $ErrorMessage += "-----> $($ErrBody.message)"
                            $ErrorMessage += '-----> ^ Error has not been documented please report. ^'
                        }
                    }
                }
                else {
                    $ErrorMessage += "-----> $($ErrBody.message)"
                    $ErrorMessage += '-----> ^ Error has not been documented please report. ^'
                }
            }
            elseif ($_.Exception.message) {
                $ErrorMessage += 'An exception has been thrown.'
                $ErrorMessage += "--> $($_.Exception.message)"
            }
        }

        if ($_.ErrorDetails) {
            $ErrorMessage += 'An error has been thrown.'
            $script:ErrDetails = $_.ErrorDetails
            $ErrorMessage += "--> $($ErrDetails.code)"
            $ErrorMessage += "--> $($ErrDetails.message)"
            if ($ErrDetails.errors.message) {
                $ErrorMessage += "-----> $($ErrDetails.errors.message)"
            }
        }

        if ($ErrorMessage.Length -lt 1) { $ErrorMessage = $_ }
        else { $ErrorMessage += $_.ScriptStackTrace }

        return Write-Error ($ErrorMessage | Out-String)
    }

    # Not sure this will be hit with current iwr error handling
    # May need to move to catch block need to find test
    # TODO Find test for retry
    # Retry the request
    $Retry = 0
    while ($Retry -lt $MaxRetry -and $Result.StatusCode -ge 500) {
        $Retry++
        # ConnectWise Manage recommended wait time
        $Wait = $([math]::pow( 2, $Retry))
        Write-Warning "Issue with request, status: $($Result.StatusCode) $($Result.StatusDescription)"
        Write-Warning "$($Retry)/$($MaxRetry) retries, waiting $($Wait)ms."
        Start-Sleep -Milliseconds $Wait
        $Result = Invoke-WebRequest @Arguments -UseBasicParsing -AllowInsecureRedirect
    }
    if ($Retry -ge $MaxRetry) {
        return Write-Error "Max retries hit. Status: $($Result.StatusCode) $($Result.StatusDescription)"
    }

    $Result
}
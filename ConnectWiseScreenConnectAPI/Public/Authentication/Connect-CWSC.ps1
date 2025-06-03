function Connect-CWSC {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Server,
        [Parameter(Mandatory = $true)]
        [string]$Secret,
        [string]$Origin,
        [switch]$Force
    )

    # Use cached Authentication if existing server connection is valid
    if ($script:CWSCServerConnection -and !$Force) {
        Write-Verbose 'Using cached Authentication information.'
        return
    }

    # Validate the server URL 
    $Server = ($Server -replace ('http.*:\/\/', '') -split '/')[0]

    Try {
        $Response = Invoke-RestMethod "https://$($Server)/App_Extensions/2d558935-686a-4bd0-9991-07539f5fe749/Service.ashx/GetSessionsByFilter" -ErrorAction Stop
    } Catch {
        If ($_.ErrorDetails.Message.Trim() -like '*No such host is known*') {
            Write-Error "Server $($Server) not found. Please check the Server Name." -ErrorAction Stop
            return

        } ElseIf ($_.ErrorDetails.Message.Trim() -like '*The resource cannot be found*') {
            Write-Error "Server $($Server) doesn't seem to have the RESTful API Manager Extension installed." -ErrorAction Stop
            return

        }
    }

    # Build out the headers
    $Headers = @{
        CTRLAuthHeader  = $Secret
        Origin          = $Origin
        'Cache-Control' = 'no-cache'
    }

    $script:CWSCServerConnection = @{
        Server  = $Server
        Headers = $Headers
        Response = $Response
    }

    # Connect and authenticate
    Try {
        Invoke-RestMethod "https://$($Server)/App_Extensions/2d558935-686a-4bd0-9991-07539f5fe749/Service.ashx/GetSessionsByFilter" -Method 'GET' -Headers $Headers -Body $(ConvertTo-Json @("Name Like 'TestForCWSC'"))
    } Catch {
        write-error "Server $($Server) returned an error while trying to connect. Please check the Secret." -ErrorAction Stop
        return
    }

    Write-Verbose 'Connection successful.'
    Write-Verbose '$CWSCServerConnection, variable initialized.'
}

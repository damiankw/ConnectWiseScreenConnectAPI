function Disconnect-CWSC {
    [CmdletBinding()]
    param()
    try {
        $null = Remove-Variable -Name CWSCServerConnection -Scope script -Force -Confirm:$false -ErrorAction Stop
        if ($CWSCServerConnection -or $script:CWSCServerConnection) {
            Write-Error 'There was an error clearing connection information.'
        }
        else {
            Write-Verbose '$CWSCServerConnection, variable removed.'
        }
    }
    catch {
        Write-Error "There was an error clearing connection information.`n$($_)"
    }
}
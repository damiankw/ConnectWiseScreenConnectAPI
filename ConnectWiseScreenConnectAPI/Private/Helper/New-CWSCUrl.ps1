function New-CWSCUrl {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'No creation impact.')]
    param(
        [string]$Endpoint,
        [string]$URLParameters
    )

    if(!$script:CWSCServerConnection){ return }

    $URL = "https://$($script:CWSCServerConnection.Server)/App_Extensions/2d558935-686a-4bd0-9991-07539f5fe749/Service.ashx/$($Endpoint)"
    $URL
}
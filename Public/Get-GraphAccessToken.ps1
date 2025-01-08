Function Get-GraphAccessToken {
    <#
        .DESCRIPTION
        Gets an access token for the Microsoft Graph API

        .SYNOPSIS
        Gets an access token for the Microsoft Graph API

        .PARAMETER ClientId
        The client ID of the application

        .PARAMETER ClientSecret
        The client secret of the application

        .PARAMETER TenantId
        The tenant ID of the application

        .PARAMETER AsPlainText
        Return the access token as a plain text string

        .EXAMPLE
        Get-GraphAccessToken -ClientId "00000000-0000-0000-0000-000000000000" -ClientSecret "00000000-0000-0000-0000-000000000000" -TenantId "00000000-0000-0000-0000-000000000000"

        .EXAMPLE
        Get-GraphAccessToken -ClientId "00000000-0000-0000-0000-000000000000" -ClientSecret "00000000-0000-0000-0000-000000000000" -TenantId "00000000-0000-0000-0000-000000000000" -AsPlainText

        .INPUTS
        System.String

        .OUTPUTS
        System.Security.SecureString

        .LINK
        https://docs.microsoft.com/en-us/graph/auth-v2-service?context=graph%2Fapi%2F1.0&view=graph-rest-1.0
         
    #>
    [CmdletBinding()]
    [OutputType([system.string])]
    param ( 
        [Parameter(Mandatory=$true)] 
        [string]$ClientId,
        [Parameter(Mandatory=$true)]
        [Alias("Secret")]
        [SecureStringDecoder()]
        [object]$ClientSecret,
        [Parameter(Mandatory=$true)] 
        [string]$TenantId,
        [Parameter(Mandatory=$false)]
        [switch]$AsPlainText 

    )
    Begin {   
        # Create the body of the request
        $body = @{}
        $body["grant_type"] = "client_credentials"
        $body["resource"] = "https://graph.microsoft.com"
        $body["client_id"] = $clientId
        $body["client_secret"] = $clientSecret

        # Invoke-RestMethod parameters
        $invoke_rest_params = @{}
        $invoke_rest_params["Method"] = "Post"
        $invoke_rest_params["Uri"] = "https://login.microsoftonline.com/$($tenantId)/oauth2/token?api-version=1.0"
        $invoke_rest_params["Body"] = $body
        $invoke_rest_params["UseBasicParsing"] = $true

    } Process {
        # Invoke the request and get the access token
        $access_token = (Invoke-RestMethod @invoke_rest_params).access_token

    } End {
        # Return the access token as a secure string if the -AsPlainText switch is not used
        If ($asPlainText) {
            $access_token
        
        } Else {
            $access_token | ConvertTo-SecureString -AsPlainText -Force
        
        }
    }
}
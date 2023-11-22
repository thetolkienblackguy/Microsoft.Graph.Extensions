Function Get-GraphApplicationCredentialStatus {
    <#
        .DESCRIPTION
        This function gets the expiration date for the secrets and certificates for an Entra ID application. 
        The function can be used to get the expiration date for all applications, a specific application, or only secrets or certificates.

        .SYNOPSIS
        This function gets the expiration date for the secrets and certificates for an Entra ID application.

        .PARAMETER ApplicationId
        The application id of the application to get the expiration date for.

        .PARAMETER SecretsOnly
        If this switch is specified, only secrets will be returned

        .PARAMETER CertificatesOnly
        If this switch is specified, only certificates will be returned

        .PARAMETER All
        If this switch is specified, all applications will be returned

        .PARAMETER ExpiresInDays
        The number of days until expiration to return. The default value is 30 days

        .EXAMPLE
        Get-GraphApplicationCredentialStatus -ApplicationId "00000000-0000-0000-0000-000000000000" -SecretsOnly

        .EXAMPLE
        Get-GraphApplicationCredentialStatus -ApplicationId "00000000-0000-0000-0000-000000000000" -CertificatesOnly

        .EXAMPLE
        Get-GraphApplicationCredentialStatus -ApplicationId "00000000-0000-0000-0000-000000000000" -ExpiresInDays 60

        .EXAMPLE
        Get-GraphApplicationCredentialStatus -ApplicationId "00000000-0000-0000-0000-000000000000" -All

        .INPUTS
        System.String
        System.Management.Automation.SwitchParameter
        System.Int32

        .OUTPUTS
        System.Collections.Generic.List[pscustomobject]

        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 11/16/2023
        Version: 0.0.1
        Name: Get-GraphApplicationCredentialStatus

        Version History:
        0.0.1 - Alpha Release - 11/16/2023 - Gabe Delaney

    #>
    [CmdletBinding(DefaultParameterSetName="AppId")]
    [OutputType([System.Collections.Generic.List[PSCustomObject]])]
    Param (
        [Parameter(
            Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,
            ParameterSetName="AppId"
                    
        )]
        [Alias("AppId")]
        [string[]]$ApplicationId,
        [Parameter(Mandatory=$false,ParameterSetName="SecretsOnly")]
        [switch]$SecretsOnly,
        [Parameter(Mandatory=$false,ParameterSetName="CertificatesOnly")]
        [switch]$CertificatesOnly,
        [Parameter(Mandatory=$false,ParameterSetName="All")]
        [switch]$All,
        [Parameter(Mandatory=$false,ParameterSetName="All")]
        [Parameter(Mandatory=$false,ParameterSetName="SecretsOnly")]
        [Parameter(Mandatory=$false,ParameterSetName="CertificatesOnly")]
        [int]$ExpiresInDays = 30
        
    )
    
    Begin {
        # Set the error action preference to stop
        $ErrorActionPreference = "Stop"
        # Properties to get from Get-MgApplication 
        $properties = @(
            "AppId", "DisplayName", "KeyCredentials", "PasswordCredentials", "Id"
        
        )

        # Calculate the expiration date
        $expiration_date = (Get-Date).AddDays($expiresInDays).ToUniversalTime()

        # Create an empty array to hold the output objects
        $output_obj = [System.Collections.Generic.List[pscustomobject]]@()
    } Process {
        Try {
            # Get the applications based on the parameter set
            $apps = If ($PSCmdlet.ParameterSetName -eq "AppId") {
                # Loop through the application ids
                Foreach ($app in $applicationId) {
                    Get-MgApplication -Filter "appId eq '$app'" | Select-Object -Property $properties

                }
            } Else {
                # Get-MgApplication parameters
                # Get all applications if the All switch is specified
                $get_application_params = @{}
                $get_application_params["All"] = $true
                $get_application_params["Property"] = $properties
                Get-MgApplication @get_application_params | Select-Object -Property $properties

            }

            # Filter the applications based on the parameters if certificates or secrets are specified
            If ($PSBoundParameters.ContainsKey("CertificatesOnly")) {
                $app_list = $apps | Where-Object {$_.KeyCredentials}
            
            } ElseIf ($PSBoundParameters.ContainsKey("SecretsOnly")) {
                $app_list = $apps | Where-Object {$_.PasswordCredentials}
            
            } Else {
                $app_list = $apps 

            }
            Foreach ($app in $app_list) {
                # Get the credentials
                $key = $app.KeyCredentials
                $secret = $app.PasswordCredentials

                # Iterate through the credentials and create an object for each
                Foreach ($credential in @($key + $secret)) {
                    $end_date = $credential.EndDateTime
                    $key_id = $credential.CustomKeyIdentifier
                    If ($end_date -le $expiration_date -and $end_date -or $PSCmdlet.ParameterSetName -eq "AppId" -or $PSCmdlet.ParameterSetName -eq "All") {
                        $days_until_expiration = (($end_date) - (Get-Date) | Select-Object -ExpandProperty TotalDays) -as [int]
                        If ($days_until_expiration -le 0) {
                            $expired = $true
                        
                        } Else {
                            $expired = $false
                            
                        }
                        # If the credential is a certificate, get the thumbprint
                        If ($key_id) {
                            $key_type = "Certificate"
                            $thumb_print = [System.Convert]::ToBase64String($key_id)

                        # If the credential is a secret, set the thumbprint to N/A
                        } Else {
                            $key_type = "ClientSecret"
                            $thumb_print = "N/A "
                        
                        }
                        # Create the object, GraphApplicationSecretInfoObject is a custom class           
                        $obj = [GraphApplicationSecretInfoObject]::Create($app, $credential, $days_until_expiration, $expired, $thumb_print, $key_type) 
                        
                        # Add the object to the output array
                        $output_obj.Add($obj)

                    }
                }
            }
        } Catch {
            Write-Error $_ -ErrorAction Stop

        }
    } End {
        $output_obj | Sort-Object -Property DaysUntilExpiration

    }
}
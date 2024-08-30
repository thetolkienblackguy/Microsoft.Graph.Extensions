function Get-GraphApplicationCredentialExpiration {
    <#
        .DESCRIPTION
        This function retrieves the status of the application credentials for the specified application.

        .SYNOPSIS
        This function retrieves the status of the application credentials for the specified application.    

        .PARAMETER ApplicationId
        The application ID of the application whose information is to be retrieved.

        .PARAMETER Filter
        The filter query to be used to retrieve application information.

        .PARAMETER Select
        The properties to be selected for the application information. The default properties are DisplayName, AppId, Id, and SignInAudience.

        .PARAMETER All
        Retrieve all applications.

        .PARAMETER ExpirationThreshold
        The number of days before the expiration date of the application credentials that the credentials will be considered expired.
        The default value is 30.

        .EXAMPLE
        Get-GraphApplicationCredentialStatus -ApplicationId "12345678-1234-1234-1234-123456789012"

        .EXAMPLE
        Get-GraphApplication -All| Get-GraphApplicationCredentialStatus

        .INPUTS
        System.String
        System.String[]
        System.Int32
        System.Management.Automation.SwitchParameter

        .OUTPUTS
        System.Management.Automation.PSCustomObject

        .NOTES
        Author: Gabriel Delaney
        Date: 08/29/2024
        Version: 0.0.1
        Name: Get-GraphApplicationCredentialStatus

        Version History:
        0.0.1 - Alpha Release - 08/29/2024 - Gabriel Delaney

    #>
    [CmdletBinding(DefaultParameterSetName="AppId")]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param (
        [Parameter(
            Mandatory=$false, Position=0, ValueFromPipeline=$true, 
            ValueFromPipelineByPropertyName=$true, ParameterSetName="AppId"    
        )]
        [Alias("Id")]
        [string]$ApplicationId,
        [Parameter(Mandatory=$false, ParameterSetName="Filter")]
        [string]$Filter,
        [Parameter(Mandatory=$false)]
        [string[]]$Select = @(
            "appId", "displayName", "keyCredentials", "passwordCredentials", "id"
        ),
        [Parameter(Mandatory=$false, ParameterSetName="All")]
        [switch]$All,
        [Parameter(Mandatory=$false, ParameterSetName="Filter")]
        [Parameter(Mandatory=$false, ParameterSetName="All")]
        [int]$ExpirationThreshold = 30
    
    )
    Begin { 
        $output_obj = [System.Collections.Generic.List[object]]@()

        # Ensure keyCredentials and passwordCredentials are always included in Select
        $required_properties = @("keyCredentials", "passwordCredentials")
        $select = @($select + $required_properties | Select-Object -Unique)
        
    } Process {
        Try {
            # Get-GraphApplication parameters
            $graph_application_params = @{}
            $graph_application_params["Select"] = $select
            
            # If the application ID is provided, use it to filter the application
            If ($applicationId) {
                $graph_application_params["ApplicationId"] = $applicationId
            
            # If the filter is provided, use it to filter the application
            } Elseif ($filter) {
                $graph_application_params["Filter"] = $filter

            # If the all switch is provided, retrieve all applications
            } Elseif ($all) {
                $graph_application_params["All"] = $true
            
            }

            # Get the applications
            $apps = Get-GraphApplication @graph_application_params

            Foreach ($app in $apps) {
                # Get the credentials
                Foreach ($cred in @($app.keyCredentials) + @($app.passwordCredentials)) {
                    # Get the expiration date
                    $cred_end_date = [datetime]$cred.endDateTime
                    
                    # Get the days until expiration
                    $days_until_expiration = ($cred_end_date - (Get-Date)).Days
                    
                    # If the days until expiration is less than or equal to the expiration threshold, or the application ID is provided, retrieve the credentials
                    if ($days_until_expiration -le $expirationThreshold -or $applicationId) {
                        $expired = $days_until_expiration -le 0

                        # If the custom key identifier is provided, it means the credential is a certificate
                        if ($cred.customKeyIdentifier) {
                            $key_type = "Certificate"
                            $thumb_print = [System.Convert]::ToBase64String([System.Convert]::FromBase64String($cred.customKeyIdentifier))
                        } Else {
                            # If the custom key identifier is not provided, it means the credential is a client secret
                            $key_type = "ClientSecret"
                            $thumb_print = "N/A"
                        
                        }

                        # Create the output object
                        $obj = [ordered]@{}

                        # Add properties passed in the select parameter
                        ForEach ($prop in $select | Where-Object {$_ -notin $required_properties}) {
                            $obj[$prop] = $app.$prop

                        }

                        # Add the credential properties
                        $obj["ExpirationDate"] = $cred.endDateTime
                        $obj["DaysUntilExpiration"] = $days_until_expiration
                        $obj["Expired"] = $expired
                        $obj["Thumbprint"] = $thumb_print
                        $obj["KeyType"] = $key_type
                        $obj["KeyId"] = $cred.keyId
                        $obj["Description"] = $cred.displayName

                        # Add the output object to the output object list
                        $output_obj.Add([pscustomobject]$obj)
                    }
                }
            }
        }
        Catch {
            Write-Error $_
        
        }
    } End {
        # Sort the output object by the days until expiration
        $output_obj | Sort-Object -Property DaysUntilExpiration
    
    }
}
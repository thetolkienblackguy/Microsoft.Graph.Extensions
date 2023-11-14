Function Get-GraphAuthenticationMethodDeviceData {
    <#
        .DESCRIPTION
        This function will return the authentication method data for a user.
    
        .SYNOPSIS
        This function will return the authentication method data for a user.

        .PARAMETER MethodType
        The type of authentication method to return. Valid values are:

        .PARAMETER DataTable
        The data table containing the authentication method data.

        .EXAMPLE
        Get-GraphAuthenticationMethodDeviceData -MethodType PhoneAuthentication -DataTable $DataTable

        .INPUTS
        System.String
        System.Collections.IDictionary

        .OUTPUTS
        System.String

        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 11/11/2023
        Version: 0.0.1
        Name: Get-GraphAuthenticationMethodDeviceData

        Version History:
        0.0.1 - Alpha Release - 11/11/2023 - Gabe Delaney

    #>
    [CmdletBinding()]
    [OutputType([system.string])]
    param (
        [Parameter(Mandatory=$true)]
        [string]$MethodType,
        [Parameter(Mandatory=$true)]
        [System.Collections.IDictionary]$DataTable
    
    )
    Begin {


    } Process {
        $device = Switch ($MethodType) {
            "PhoneAuthentication" {
                $DataTable["phoneType", "phoneNumber"] -join ' '; Break
            
            } "TemporaryAccessPass" {
                "Lifetime: $($DataTable["lifetimeInMinutes"])m - Status:$($DataTable["methodUsabilityReason"])"; Break
            
            } "Fido2" {
                $DataTable["model"]; Break
            
            } "EmailAuthentication" {
                $DataTable["emailAddress"]; Break
            
            } Default {
                $DataTable["displayName"]; Break
            
            }
        }
    } End {
        $device

    }
}
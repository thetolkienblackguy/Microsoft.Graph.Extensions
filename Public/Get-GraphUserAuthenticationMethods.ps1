
Function Get-GraphUserAuthenticationMethods {
    <# 
        .DESCRIPTION
        Gets the authentication methods for a user or users in Entra Id.

        .SYNOPSIS
        Gets the authentication methods for a user or users in Entra Id.

        .PARAMETER UserId
        The user or users to get the authentication methods for. This can be a single user or an array of users.

        .PARAMETER Method
        The authentication method to get. If this parameter is not specified, all authentication methods will be returned.

        .PARAMETER Filter
        The filter to use when getting users. This is passed to Get-MgUser.

        .PARAMETER All
        If this switch is specified, all users will be returned. This is passed to Get-MgUser.

        .EXAMPLE
        Get-GraphUserAuthenticationMethods -UserId "jdoe@contoso.com" 

        .EXAMPLE
        Get-GraphUserAuthenticationMethods -UserId "jdoe@contoso.com" -Method "AuthenticatorApp"

        .EXAMPLE
        Get-MgUser -Filter "startswith(UserPrincipalName, 'jdoe')" | Get-GraphUserAuthenticationMethods

        .NOTES
        Author: Gabriel Delaney
        Date: 11/12/2023
        Version: 0.0.1
        Name: Get-GraphUserAuthenticationMethods

        Version History:
        0.0.1 - Alpha Release - 11/11/2023 - Gabe Delaney
    
    #>
    [CmdletBinding(DefaultParameterSetName="UserId")]
    [OutputType([System.Collections.Generic.List[PSCustomObject]])]
    param(
        [Parameter(Mandatory=$true, ParameterSetName="UserId", ValueFromPipeline=$true,
                ValueFromPipelineByPropertyName=$true
        
        )]
        [Alias("UserPrincipalName","UPN")]
        [string[]]$UserId,
        [Parameter(Mandatory=$false)]
        [ValidateSet("AuthenticatorApp", "PhoneAuthentication", "Fido2", "WindowsHelloForBusiness", 
                "EmailAuthentication", "TemporaryAccessPass", "Passwordless", "SoftwareOath"
            
        )]
        [string]$Method,
        [Parameter(Mandatory=$false, ParameterSetName="All")]
        [string]$Filter,
        [Parameter(Mandatory=$false, ParameterSetName="All")]
        [switch]$All
    
    )
    Begin {
        # Create the object to return.
        $obj = [System.Collections.Generic.List[PSCustomObject]] @{}

    } Process {
        # If the All parameter is specified, we need to get all users and then iterate through them.
        If ($PSBoundParameters.ContainsKey('All')) {
            $get_mguser_params = @{}
            If ($PSBoundParameters.ContainsKey('Filter')) {
                $get_mguser_params["Filter"] = $filter
            
            }
            $get_mguser_params["All"] = $all
            Try {
                # Getting users, this should be unnecessary but the filter parameter doesn't work for Get-MgUserAuthenticationMethod.
                $userId = (Get-MgUser @get_mguser_params).UserPrincipalName

            } catch {
                # If we can't get the users, throw an error and break.
                Write-Error $_.Exception.Message
                Break
            
            }
        }
        # Iterate through the users and get their authentication methods.
        Foreach ($u in $userId) {
            Try {
                $methods = Get-MgUserAuthenticationMethod -UserId $u 
                Foreach ($m in $methods) {
                    # Get the authentication method type and the device name.
                    $data_table = $m.AdditionalProperties

                    # If the method type is not in the method table, skip it.
                    $method_type = [AuthenticationMethodTable]::GetAuthenticationMethod($data_table["@odata.type"])
                    If ($PSBoundParameters.ContainsKey('Method') -and $method_type -notin $method) {
                        Continue
                    
                    }
                    # Get the device name.
                    $device = [AuthenticationMethodData]::GetDeviceData($method_type, $data_table)

                    # Create the object and add it to the list.
                    $method_obj = [Ordered] @{}
                    $method_obj["UserPrincipalName"] = $u
                    $method_obj["AuthenticationMethodId"] = $m.Id
                    $method_obj["Method"] = $method_type
                    $method_obj["Device"] = $device
                    [void]$obj.Add([PSCustomObject]$method_obj) 

                }
            } catch {
                Write-Error $_.Exception.Message -ErrorAction Continue

            } 
        }
    } End {
        $obj
        
    }
}
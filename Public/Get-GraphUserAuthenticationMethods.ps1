Function Get-GraphUserAuthenticationMethods {
    <#
        .DESCRIPTION
        This function retrieves the authentication methods for a user.

        .SYNOPSIS
        This function retrieves the authentication methods for a user.

        .PARAMETER UserId
        The user ID of the user whose information is to be retrieved.

        .PARAMETER ApiVersion
        The API version to use.

        .EXAMPLE
        Get-GraphUser -UserId "12345678-1234-1234-1234-123456789012" | Get-GraphUserAuthenticationMethods

        .EXAMPLE
        Get-GraphUserAuthenticationMethods -UserId "12345678-1234-1234-1234-123456789012"

        .INPUTS
        System.String      

        .OUTPUTS
        System.Object

    #>
    [CmdletBinding(DefaultParameterSetName="UserId")]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param (
        [Parameter(
            Mandatory=$true,Position=0,ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,ParameterSetName="UserId"
                
        )]
        [Alias(
            "Id","UserPrincipalName","UPN"
            
        )]
        [string[]]$UserId,
        [Parameter(Mandatory=$false)]
        [ValidateSet("Beta","v1.0")]
        [string]$ApiVersion = "v1.0"
    
    )
    Begin {
        # Set the default parameter values
        $PSDefaultParameterValues = @{}
        $PSDefaultParameterValues["Add-Member:MemberType"] = "NoteProperty"
        $PSDefaultParameterValues["Add-Member:Force"] = $true
    
    } Process {
        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Uri"] = "https://graph.microsoft.com/$apiVersion/users/$userId/authentication/methods"
        $invoke_mg_params["Method"] = "GET"
        $invoke_mg_params["Headers"] = @{}
        $invoke_mg_params["Headers"]["ConsistencyLevel"] = "eventual"
        $invoke_mg_params["OutputType"] = "PSObject"

        Try {
            # Invoke-MgGraphRequest
            $r = (Invoke-MgGraphRequest @invoke_mg_params)
            
            # Add the AuthenticationMethod property to the results
            $auth_method_objs = $r.value
            $auth_method_objs | Add-Member -Name "userId" -Value $userId
            $auth_method_objs | Add-Member -Name "authenticationMethod" -Value ""
            Foreach ($auth_method_obj in $auth_method_objs) {
                $auth_method_obj.authenticationMethod = [GraphAuthenticationMethodInfo]::GetFriendlyName($auth_method_obj."@odata.type")

            }
        } Catch {
            # Return the error
            Write-Error -Message $_

        }
        # Return the results
        [pscustomobject]$auth_method_objs

    } End {
    
    }
}
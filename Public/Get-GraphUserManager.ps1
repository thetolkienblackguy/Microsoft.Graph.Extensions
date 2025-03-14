Function Get-GraphUserManager {
    <#
        .SYNOPSIS
        Get the manager for a user

        .DESCRIPTION
        Get the manager for a user

        .PARAMETER UserId
        The user ID of the user to get the manager for

        .PARAMETER Select
        The properties to select from the manager

        .PARAMETER ApiVersion
        The API version to use
get
        .EXAMPLE
        Get-GraphUserManager -UserId "1234567890"

        .EXAMPLE
        Get-GraphUserManager -UserId "1234567890" -Select "id", "userPrincipalName", "displayName"

        .INPUTS
        System.String

        .OUTPUTS
        System.Object
        
    #>
    [CmdletBinding()]
    [OutputType("System.Object")]
    param (
        [Parameter(
            Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true,
            Position=0
        
        )]
        [Alias("Id","UserPrincipalName")]
        [string[]]$UserId,
        [Parameter(Mandatory=$false)]
        [string[]]$Select = @(
            "id", "userPrincipalName", "displayName"
            
        ),
        [Parameter(Mandatory=$false)]
        [ValidateSet("Beta","v1.0")]
        [string]$ApiVersion = "v1.0"
    
    ) 
    Begin {
        # Set the error action preference
        $ErrorActionPreference = "Stop"

        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Method"] = "Get"
        $invoke_mg_params["OutputType"] = "PSObject"

        # Set the end point
        $end_point = "https://graph.microsoft.com/$apiVersion/users/{0}/manager?`$select=$($select -join ',')"

        If ($PSBoundParameters.ContainsKey("Select")) {
            Write-Warning "Manager properties are case sensitive. Property names are typically camel case. e.g. userPrincipalName"
        
        }
    } Process {
        # Get the manager for each user
        Foreach ($id in $userId) {
            # Invoke the request
            $r = Invoke-MgGraphRequest @invoke_mg_params -Uri $($end_point -f $id)

            # Return the result
            $r | Select-Object -Property $select
            
        }
    } End {
    }
}

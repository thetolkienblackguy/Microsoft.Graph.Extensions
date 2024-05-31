Function Get-GraphUser {
    <#
        .DESCRIPTION
        This function retrieves user information from the Microsoft Graph API. The function can be used to retrieve user information based on the user ID or a filter query. The function returns the user information in the form of a PSObject.

        .SYNOPSIS
        This function retrieves user information from the Microsoft Graph API.

        .PARAMETER UserId
        The user ID of the user whose information is to be retrieved.

        .PARAMETER Filter
        The filter query to be used to retrieve user information.

        .PARAMETER Select
        The properties to be selected for the user information. The default properties are DisplayName, Id, Mail, and UserPrincipalName.


        .EXAMPLE
        Get-GraphUser -UserId "12345678-1234-1234-1234-123456789012"

        .EXAMPLE
        Get-GraphUser -Filter "startswith(displayName,'A')"

        .EXAMPLE
        Get-GraphUser -Filter "endswith(mail,'@contoso.com')" -Select "DisplayName","Id","Mail"

        .INPUTS
        System.String
        

        .OUTPUTS
        System.Object

        .NOTES
        Author: Gabriel Delaney
        Date: 05/30/2024
        Version: 0.0.1
        Name: Get-GraphUser

        Version History:
        0.0.1 - Alpha Release - 05/30/2024 - Gabriel Delaney

    #>
    [CmdletBinding(DefaultParameterSetName="UserId")]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param (
        [Parameter(
            Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="UserId"
                
        )]
        [Alias(
            "Id","UserPrincipalName","UPN"
            
        )]
        [string[]]$UserId,
        [Parameter(Mandatory=$true,ParameterSetName="Filter")]
        [string]$Filter,
        [Parameter(Mandatory=$false)]
        [string[]]$Select = @(
            "DisplayName","Id","Mail","UserPrincipalName"
            
        )
    )
    Begin {
        # Setting the error action preference
        $ErrorActionPreference = "Stop"

        # Setting the function name
        $function = $MyInvocation.MyCommand.Name

    } Process {
        # Setting the filter based on the parameter set
        If ($PSCmdlet.ParameterSetName -eq "UserId") {
            $filter = "id eq '$userId'"
        
        } 
        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Uri"] = "https://graph.microsoft.com/v1.0/users?`$count=true&`$filter=$filter&`$select=$($select -join ",")"
        $invoke_mg_params["Method"] = "GET"
        $invoke_mg_params["Headers"] = @{}
        $invoke_mg_params["Headers"]["ConsistencyLevel"] = "eventual"#>
        $invoke_mg_params["OutputType"] = "PSObject"

        Try {
            $users = Do {
                $r = (Invoke-MgGraphRequest @invoke_mg_params)
                $r.Value
                $invoke_mg_params["Uri"] = $r."@odata.nextLink"
            
            # Looping through the results until there are no more results
            } Until (!$r."@odata.nextLink")

        } Catch {
            Write-Error -Message $_ -ErrorAction Stop

        }
        If (!$users -and $PSCmdlet.ParameterSetName -eq "UserId") {
            # Setting the error details
            $error_details_params = @{}
            $error_details_params["Message"] = "Resource '$userId' does not exist or one of its queried reference-property objects are not present"
            $error_details_params["Identity"] = $userId
            $error_details_params["Function"] = $function
            $error_details_params["Category"] = "ObjectNotFound"
            $error_details_params["CategoryTargetType"] = "Microsoft.Graph.User"
            $write_error_params = Set-ErrorDetails @error_details_params

            # Setting the error message
            Write-Error @write_error_params -ErrorAction Stop
            Break

        } Else {
            $users
        
        }
    } End {

    }
}
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

        .PARAMETER All
        Retrieve all users.

        .PARAMETER Top
        The number of results to return. The default value is 999.

        .EXAMPLE
        Get-GraphUser -UserId "12345678-1234-1234-1234-123456789012"

        .EXAMPLE
        Get-GraphUser -Filter "startswith(displayName,'A')"

        .EXAMPLE
        Get-GraphUser -Filter "endswith(mail,'@contoso.com')" -Select "DisplayName","Id","Mail"

        .INPUTS
        System.String
        System.String[]
        System.Int32
        System.Automation.SwitchParameter        

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
        [string]$UserId,
        [Parameter(Mandatory=$true,ParameterSetName="Filter")]
        [string]$Filter,
        [Parameter(Mandatory=$true,ParameterSetName="All")]
        [switch]$All,
        [Parameter(Mandatory=$false)]
        [string[]]$Select = @(
            "DisplayName","Id","Mail","UserPrincipalName"
            
        ),
        [Parameter(Mandatory=$false)]
        [ValidateSet("Beta","v1.0")]
        [string]$ApiVersion = "v1.0"
    
    )
    Begin {
    } Process {
        # Setting the filter based on the parameter set
        If ($PSCmdlet.ParameterSetName -eq "UserId") {
            $filter = "id eq '$userId'"
        
        } ElseIf ($PSCmdlet.ParameterSetName -eq "All") {
            $filter = $null

        }
        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Uri"] = "https://graph.microsoft.com/$apiVersion/users/$userId"
        $invoke_mg_params["Method"] = "GET"
        $invoke_mg_params["Headers"] = @{}
        $invoke_mg_params["Headers"]["ConsistencyLevel"] = "eventual"
        $invoke_mg_params["OutputType"] = "PSObject"

        Try {
            Do {
                # Invoke-MgGraphRequest
                $r = (Invoke-MgGraphRequest @invoke_mg_params)
                
                # Output the results
                If (!$r.Value) {
                    $r

                } Else {
                    $r.Value 
                
                }
                # Set the next link
                $invoke_mg_params["Uri"] = $r."@odata.nextLink"
            
            # Looping through the results until there are no more results
            } Until (!$r."@odata.nextLink")

        } Catch {
            Write-Error -Message $_

        }
    } End {

    }
}

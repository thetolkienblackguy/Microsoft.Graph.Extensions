Function Get-GraphApplication {
    <#
        .DESCRIPTION
        This function retrieves application information from the Microsoft Graph API. 
        The function can be used to retrieve application information based on the application ID, display name, or a filter query.

        .SYNOPSIS
        This function retrieves application information from the Microsoft Graph API.

        .PARAMETER ApplicationId
        The application ID of the application whose information is to be retrieved.

        .PARAMETER Filter
        The filter query to be used to retrieve application information.

        .PARAMETER Select
        The properties to be selected for the application information. The default properties are DisplayName, AppId, Id, and SignInAudience.

        .PARAMETER All
        Retrieve all applications.

        .PARAMETER Top
        The number of results to return. The default value is 999.

        .EXAMPLE
        Get-GraphApplication -ApplicationId "12345678-1234-1234-1234-123456789012"

        .EXAMPLE
        Get-GraphApplication -Filter "startswith(displayName,'Test')"

        .EXAMPLE
        Get-GraphApplication -All -Select "DisplayName","AppId","Id","SignInAudience"

        .INPUTS
        System.String
        System.String[]
        System.Int32
        System.Management.Automation.SwitchParameter

        .OUTPUTS
        System.Management.Automation.PSCustomObject

    #>
    [CmdletBinding(DefaultParameterSetName="ApplicationId")]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,ParameterSetName="ApplicationId")]
        [Alias("AppId","Id")]
        [string[]]$ApplicationId,
        [Parameter(Mandatory=$true,ParameterSetName="Filter")]
        [string]$Filter,
        [Parameter(Mandatory=$true,ParameterSetName="All")]
        [switch]$All,
        [Parameter(Mandatory=$false)]
        [string[]]$Select = @(
            "DisplayName","AppId","Id"
        
        ),
        [Parameter(Mandatory=$false)]
        [ValidateSet("Beta","v1.0")]
        [string]$ApiVersion = "v1.0"

    )
    Begin {
    } Process {
        # Setting the filter based on the parameter set
        If ($PSCmdlet.ParameterSetName -eq "ApplicationId") {
            # If the application ID is a GUID, use the AppId filter
            If ($applicationId -match "^\w{8}-\w{4}-\w{4}-\w{4}-\w{12}$") {
                $filter = "id eq '$applicationId'"
            
                # If the application ID is not a GUID, use the displayName filter
            } Else {
                $filter = "displayName eq '$applicationId'"
            }
        } ElseIf ($PSCmdlet.ParameterSetName -eq "All") {
            $filter = $null
        
        }
        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Uri"] = "https://graph.microsoft.com/$apiVersion/applications?`$count=true&`$filter=$filter&`$select=$($select -join ",")"   
        $invoke_mg_params["Method"] = "GET"
        $invoke_mg_params["Headers"] = @{}
        $invoke_mg_params["Headers"]["ConsistencyLevel"] = "eventual"
        $invoke_mg_params["OutputType"] = "PSObject"

        Try {
            Do {
                # Invoke-MgGraphRequest
                $response = (Invoke-MgGraphRequest @invoke_mg_params)

                # Output the results
                $response.Value

                # Set the next link
                $invoke_mg_params["Uri"] = $response."@odata.nextLink"
            
            # Looping through the results until there are no more results
            } Until (!$response."@odata.nextLink")

        } Catch {
            Write-Error -Message $_
        
        }
    } End {
    }
}

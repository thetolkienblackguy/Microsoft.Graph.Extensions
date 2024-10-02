Function Get-GraphDirectoryRole {
    <#
        .DESCRIPTION
        This function retrieves directory role information from the Microsoft Graph API. 
        The function can be used to retrieve directory role information based on the directory role ID, display name, or a filter query.

        .SYNOPSIS
        This function retrieves directory role information from the Microsoft Graph API.

        .PARAMETER DirectoryRole
        The directory role ID of the directory role whose information is to be retrieved.

        .PARAMETER Filter
        The filter query to be used to retrieve directory role information.

        .PARAMETER Select
        The properties to be selected for the directory role information. The default properties are DisplayName, Id, Description, and IsBuiltIn.

        .PARAMETER All
        Retrieve all directory roles.

        .PARAMETER Top
        The number of results to return. The default value is 999.

        .EXAMPLE
        Get-GraphDirectoryRole -DirectoryRole "12345678-1234-1234-1234-123456789012"

        .EXAMPLE
        Get-GraphDirectoryRole -Filter "startswith(displayName,'Global')"

        .EXAMPLE
        Get-GraphDirectoryRole -All -Select "DisplayName","Id","Description"

        .INPUTS
        System.String
        System.String[]
        System.Int32
        System.Management.Automation.SwitchParameter

        .OUTPUTS
        System.Management.Automation.PSCustomObject

        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 08/16/2024
        Version: 0.0.1
        Name: Get-GraphDirectoryRole

        Version History:
        0.0.1 - Alpha Release - 08/16/2024 - Gabriel Delaney

    #>
    [CmdletBinding(DefaultParameterSetName="DirectoryRole")]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param (
        [Parameter(
            Mandatory=$true,Position=0,ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,ParameterSetName="DirectoryRole"
            
        )]
        [Alias("Id","RoleDefinitionId")]
        [string[]]$DirectoryRole,
        [Parameter(Mandatory=$true,ParameterSetName="Filter")]
        [string]$Filter,
        [Parameter(Mandatory=$true,ParameterSetName="All")]
        [switch]$All,
        [Parameter(Mandatory=$false)]
        [string[]]$Select = @(
            "DisplayName","Id","Description","IsBuiltIn"
        
        ),
        [Parameter(Mandatory=$false)]
        [ValidateSet("Beta","v1.0")]
        [string]$ApiVersion = "v1.0"
        <#[Parameter(Mandatory=$false,ParameterSetName="Filter")]
        [Parameter(Mandatory=$false,ParameterSetName="All")]
        [ValidateRange(1,999)]
        [int]$Top#>
    )

    Begin {
    } Process {
        # Setting the filter based on the parameter set
        If ($PSCmdlet.ParameterSetName -eq "DirectoryRole") {
            # If the directory role is a GUID, use the ID filter
            If ($directoryRole -match "^\w{8}-\w{4}-\w{4}-\w{4}-\w{12}$") {
                $filter = "id eq '$directoryRole'"

            # If the directory role is a display name, use the display name filter
            } Else {
                $filter = "displayName eq '$directoryRole'"
            
            }
        } ElseIf ($PSCmdlet.ParameterSetName -eq "All") {
            $filter = $null
        
        }

        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Uri"] = "https://graph.microsoft.com/$apiVersion/roleManagement/directory/roleDefinitions?`$count=true&`$filter=$filter&`$select=$($select -join ",")"
        $invoke_mg_params["Method"] = "GET"
        $invoke_mg_params["Headers"] = @{}
        $invoke_mg_params["Headers"]["ConsistencyLevel"] = "eventual"
        $invoke_mg_params["OutputType"] = "PSObject"

        Try {
            Do {
                # Invoke-MgGraphRequest
                $r = (Invoke-MgGraphRequest @invoke_mg_params)

                # Output the results
                $r.Value

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

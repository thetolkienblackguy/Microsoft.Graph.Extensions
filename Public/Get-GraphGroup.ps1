Function Get-GraphGroup {
    <#
        .DESCRIPTION
        This function retrieves group information from the Microsoft Graph API.
    
        .SYNOPSIS
        This function retrieves group information from the Microsoft Graph API.

        .PARAMETER GroupId
        The group ID of the group whose information is to be retrieved.

        .PARAMETER Filter
        The filter query to be used to retrieve group information.

        .PARAMETER Select
        The properties to be selected for the group information. The default properties are DisplayName, Id, MailNickname, Description, and GroupTypes.

        .PARAMETER All
        Retrieve all groups.

        .EXAMPLE
        Get-GraphGroup -GroupId "12345678-1234-1234-1234-123456789012"

        .EXAMPLE
        Get-GraphGroup -Filter "startswith(displayName,'A')"

        .INPUTS
        System.String
        System.String[]
        System.Automation.SwitchParameter        

        .OUTPUTS
        System.Object

    #>
    [CmdletBinding(DefaultParameterSetName="GroupId")]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param (
        [Parameter(
            Mandatory=$true,Position=0,ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true,ParameterSetName="GroupId"
                
        )]
        [Alias("Id")]
        [string]$GroupId,
        [Parameter(Mandatory=$true,ParameterSetName="Filter")]
        [string]$Filter,
        [Parameter(Mandatory=$true,ParameterSetName="All")]
        [switch]$All,
        [Parameter(Mandatory=$false)]
        [string[]]$Select = @(
            "DisplayName","Id","MailNickname", "Description", "GroupTypes"
            
        ),
        [Parameter(Mandatory=$false)]
        [ValidateSet("Beta","v1.0")]
        [string]$ApiVersion = "v1.0"
    
    )
    Begin {
    } Process {
        # Setting the filter based on the parameter set
        If ($PSCmdlet.ParameterSetName -eq "GroupId") {
            $filter = "id eq '$groupId'"
        
        } ElseIf ($PSCmdlet.ParameterSetName -eq "All") {
            $filter = $null

        }
        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Uri"] = "https://graph.microsoft.com/$apiVersion/groups?`$count=true&`$filter=$filter&`$select=$($select -join ',')"
        $invoke_mg_params["Method"] = "GET"
        $invoke_mg_params["Headers"] = @{}
        $invoke_mg_params["Headers"]["ConsistencyLevel"] = "eventual"
        $invoke_mg_params["OutputType"] = "PSObject"

        Try {
            Do {
                # Invoke-MgGraphRequest
                $r = (Invoke-MgGraphRequest @invoke_mg_params)
                
                # Return the results
                $r.value
                
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
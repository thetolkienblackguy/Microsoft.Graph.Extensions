Function Get-GraphConditionalAccessPolicy {
    <#
        .DESCRIPTION
        Gets a Conditional Access Policy from Microsoft Graph

        .SYNOPSIS
        Gets a Conditional Access Policy from Microsoft Graph


        .EXAMPLE
        Get-GraphConditionalAccessPolicy -ConditionalAccessPolicyId "00000000-0000-0000-0000-000000000000" 

        .EXAMPLE
        Get-MgIdentityConditionalAccessPolicy | Get-GraphConditionalAccessPolicy 
        
        
        .EXAMPLE
        Get-GraphConditionalAccessPolicy -Filter "displayName eq 'Test Policy'"

        .EXAMPLE
        Get-GraphConditionalAccessPolicy -All -FlattenOutput
        
        .INPUTS
        System.String
        System.IO.FileInfo

        .OUTPUTS
        System.Management.Automation.PSObject

        .LINK
        https://docs.microsoft.com/en-us/graph/api/resources/conditionalaccesspolicy?view=graph-rest-1.0
        
        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 11/11/2023
        Version: 0.0.1
        Name: Get-GraphConditionalAccessPolicy

        Version History:
        0.0.1 - Alpha Release - 11/11/2023 - Gabe Delaney

    #>
    [CmdletBinding(DefaultParameterSetName="All")]
    [OutputType([System.Management.Automation.PSObject])]
    Param (
        [Parameter(
            Mandatory=$false,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,
            ParameterSetName="ConditionalAccessPolicyId"
        )]
        [Alias("Id","PolicyId")]
        [string[]]$ConditionalAccessPolicyId,
        [Parameter(Mandatory=$false,ParameterSetName="Filter")]
        [string]$Filter,
        [Parameter(Mandatory=$false,ParameterSetName="All")]
        [switch]$All,
        [Parameter(Mandatory=$false)]
        [ValidateSet("Beta","v1.0")]
        [string]$ApiVersion = "v1.0",
        [Parameter(Mandatory=$false,ParameterSetName="Filter")]
        [Parameter(Mandatory=$false,ParameterSetName="All")]
        [ValidateRange(1,999)]
        [int]$Top,
        [Parameter(Mandatory=$false)]
        [switch]$FlattenOutput
    
    )
    Begin {
        # Set the default parameter values
        $PSDefaultParameterValues = @{}
        $PSDefaultParameterValues["ConvertTo-Json:Depth"] = 10
        $PSDefaultParameterValues["Invoke-MgGraphRequest:Method"] = "GET"
        $PSDefaultParameterValues["Invoke-MgGraphRequest:OutputType"] = "PSObject"

    } Process {
        # Setting the filter based on the parameter set
        If ($PSCmdlet.ParameterSetName -eq "ConditionalAccessPolicyId") {
            $filter = "id eq '$conditionalAccessPolicyId'"
        
        } ElseIf ($PSCmdlet.ParameterSetName -eq "All") {
            $filter = $null

        }
        If ($top) {
            $top_str = "&`$top=$top"

        }
        Try {
            Do {
                # Get all the policies
                $r = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/$apiVersion/identity/conditionalAccess/policies?`$filter=$filter$($top_str)"
                
                # Output the policies
                If ($flattenOutput) {
                    # Flatten the output
                    Write-Warning "Object flattening is experimental and may not work as expected in all scenarios."
                    $r.Value | ConvertTo-FlatObject
                
                } Else {
                    # Return the raw object
                    $r.Value
                
                }
            } Until (!$r."@odata.nextLink")
        } Catch {
            # Write the error
            Write-Error -Message $_
        
        } 
    } End {

    }
}
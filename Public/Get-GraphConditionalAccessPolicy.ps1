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
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSObject])]
    Param (
        [Parameter(Mandatory=$false,ValueFromPipeline,ValueFromPipelineByPropertyName=$true)]
        [Alias("Id","PolicyId")]
        [string[]]$ConditionalAccessPolicyId

    )
    Begin {
        $output_object = [System.Collections.ArrayList]::new()
        # Set the default parameter values
        $PSDefaultParameterValues = @{}
        $PSDefaultParameterValues["ConvertTo-Json:Depth"] = 10
        $PSDefaultParameterValues["Invoke-MgGraphRequest:Method"] = "GET"
        $PSDefaultParameterValues["Invoke-MgGraphRequest:OutputType"] = "PSObject"

    } Process {
        If (!$conditionalAccessPolicyId) {
            Try {
                Do {
                    # Get all the policies
                    $r = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies"
                    [void]$output_object.Add($r.Value)
                    $next_link = $r."@odata.nextLink"

                } Until (!$next_link)
            } Catch {
                # Write the error
                Write-Error -Message $_.Exception.Message -ErrorAction Stop
            
            }
        } Else {
            Foreach ($id in $conditionalAccessPolicyId) {
                Try {
                    # Get the policy
                    $r = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies/$id"
                    [void]$output_object.Add($r)

                } Catch {
                    # Write the error
                    Write-Error -Message $_.Exception.Message -ErrorAction Stop

                }
            }
        }
    } End {
        [PSCustomObject]$output_object

    }
}
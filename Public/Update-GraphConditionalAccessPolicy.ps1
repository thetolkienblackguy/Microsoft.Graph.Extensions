Function Update-GraphConditionalAccessPolicy {
    <#
        .DESCRIPTION
        Updates a Conditional Access Policy in Microsoft Graph

        .SYNOPSIS
        Updates a Conditional Access Policy in Microsoft Graph

        .PARAMETER ConditionalAccessPolicyId
        The ID of the Conditional Access Policy to update

        .PARAMETER BodyParameters
        The JSON body of the Conditional Access Policy to update

        .EXAMPLE
        Update-GraphConditionalAccessPolicy -ConditionalAccessPolicyId "00000000-0000-0000-0000-000000000000" -BodyParameters $policy_json

        .INPUTS
        System.String
        System.Switch

        .OUTPUTS
        System.Object

        .LINK
        https://docs.microsoft.com/en-us/graph/api/resources/conditionalaccesspolicy?view=graph-rest-1.0
        
    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="Low")]
    [OutputType([System.Object])]
    Param (
        [Parameter(
            Mandatory=$false,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,
            Position=0
        )]
        [Alias("Id","PolicyId")]
        [string[]]$ConditionalAccessPolicyId,
        [Parameter(Mandatory=$false, Position=1)]
        [string]$BodyParameters,
        [Parameter(Mandatory=$false)]
        [ValidateSet("Beta","v1.0")]
        [string]$ApiVersion = "v1.0",
        [Parameter(Mandatory=$false)]
        [switch]$PassThru
    
    )
    Begin {

    } Process {

        If ($PSCmdlet.ShouldProcess("$id","Update Conditional Access Policy")) {
            # Convert the JSON body to a PowerShell object
            $policy = $bodyParameters | ConvertFrom-Json

            # Remove the Id, CreatedDateTime, ModifiedDateTime, and TemplateId properties
            Foreach ($property in @("Id","CreatedDateTime","ModifiedDateTime","TemplateId")) {
                $policy.PSObject.Properties.Remove($property)
            
            }
            # Invoke-MgGraphRequest parameters
            $invoke_mg_params = @{}
            $invoke_mg_params["Uri"] = "https://graph.microsoft.com/$apiVersion/identity/conditionalAccess/policies/$conditionalAccessPolicyId"
            $invoke_mg_params["Method"] = "PATCH"
            $invoke_mg_params["Body"] = $policy | ConvertTo-Json -Depth 10 -Compress
            $invoke_mg_params["OutputType"] = "PSObject"
            $invoke_mg_params["ContentType"] = "application/json"

            Try {
                # Update the Conditional Access Policy
                $r = Invoke-MgGraphRequest @invoke_mg_params
                    
            } Catch {
                # Write the error
                Write-Error -Message $_
            
            } 
        }
    } End {
        If ($passThru.isPresent) {
            $r
        
        }
    }
}
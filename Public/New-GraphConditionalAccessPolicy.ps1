Function New-GraphConditionalAccessPolicy {
    <#
        .DESCRIPTION
        Creates a new Conditional Access Policy in Microsoft Graph

        .SYNOPSIS
        Creates a new Conditional Access Policy in Microsoft Graph

        .PARAMETER BodyParameters
        The JSON body of the Conditional Access Policy to create

        .EXAMPLE
        New-GraphConditionalAccessPolicy -BodyParameters $policy_json

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
        [Parameter(Mandatory=$false, Position=0)]
        [string]$BodyParameters,
        [Parameter(Mandatory=$false)]
        [ValidateSet("Beta","v1.0")]
        [string]$ApiVersion = "v1.0",
        [Parameter(Mandatory=$false)]
        [switch]$PassThru
    
    )
    Begin {

    } Process {
        If ($PSCmdlet.ShouldProcess("New Conditional Access Policy",$policy.DisplayName)) {
            # Convert the JSON body to a PowerShell object
            $policy = $bodyParameters | ConvertFrom-Json

            # Update the DisplayName and State
            $policy.DisplayName = "$($policy.DisplayName)"
            $policy.State = "enabledForReportingButNotEnforced"

            # Remove the Id, CreatedDateTime, ModifiedDateTime, and TemplateId properties
            Foreach ($property in @("Id","CreatedDateTime","ModifiedDateTime","TemplateId")) {
                $policy.PSObject.Properties.Remove($property)
            
            }
            # Invoke-MgGraphRequest parameters
            $invoke_mg_params = @{}
            $invoke_mg_params["Uri"] = "https://graph.microsoft.com/$apiVersion/identity/conditionalAccess/policies"
            $invoke_mg_params["Method"] = "POST"
            $invoke_mg_params["Body"] = $policy | ConvertTo-Json -Depth 10 -Compress
            $invoke_mg_params["OutputType"] = "PSObject"

            Try {
                # Update the Conditional Access Policy
                $r = Invoke-MgGraphRequest @invoke_mg_params
                    
            } Catch {
                # Write the error
                Write-Error -Message $_ -ErrorAction Stop
            
            } 
        }
    } End {
        If ($passThru.isPresent) {
            $r
        
        }
    }
}

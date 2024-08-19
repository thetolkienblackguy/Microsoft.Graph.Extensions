Function Restore-GraphConditionalAccessPolicy {
    <#
        .DESCRIPTION
        Restores a conditional access policy from a JSON file

        .SYNOPSIS
        Restores a conditional access policy from a JSON file

        .PARAMETER Path
        The path to the JSON file

        .PARAMETER State
        The state of the conditional access policy. Valid values are Enabled, Disabled, enabledForReportingButNotEnforced, and Current. The default value is enabledForReportingButNotEnforced

        .PARAMETER NewDisplayName
        The new display name for the conditional access policy. If this parameter is not specified, the display name will be the same as the original policy with (RESTORED) appended to the end
        
        .PARAMETER PassThru
        Returns the response from the Graph API

        .EXAMPLE
        Restore-GraphConditionalAccessPolicy -Path .\policy.json -State Enabled -PassThru

        .EXAMPLE
        Restore-GraphConditionalAccessPolicy -Path .\policy.json -State Disabled

        .EXAMPLE
        Restore-GraphConditionalAccessPolicy -Path .\policy.json -State Current -NewDisplayName "My New Policy"
        
        .INPUTS
        System.IO.FileInfo
        System.String
        System.Management.Automation.SwitchParameter

        .OUTPUTS
        System.Collections.Hashtable

        .LINK
        https://docs.microsoft.com/graph/api/resources/conditionalaccesspolicy?view=graph-rest-1.0

        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 11/11/2023
        Version: 0.0.1
        Name: Restore-GraphConditionalAccessPolicy

        Version History:
        0.0.1 - Alpha Release - 11/11/2023 - Gabe Delaney

    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [Alias("FullName")]
        [ValidateScript({
            Test-Path $_ -PathType Leaf
        
        })]
        [system.io.fileinfo[]]$Path,
        [Parameter(Mandatory=$false)]
        [ValidateSet(
            "Enabled", "Disabled", "enabledForReportingButNotEnforced", "Current"
            
        )]   
        [string]$State = "enabledForReportingButNotEnforced",
        [Parameter(Mandatory=$false)]
        [String]$NewDisplayName,
        [Parameter(Mandatory=$false)]
        [switch]$PassThru
    
    )
    Begin {
        # Invoke-MgGraphRequest parameters
        $invoke_graph_params = @{}
        $invoke_graph_params['Method'] = "POST"
        $invoke_graph_params['Uri'] = "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies"
        $invoke_graph_params['ContentType'] = "application/json"
        
        # Exclude these properties from the JSON
        $remove_from_json = @("id", "createdDateTime", "modifiedDateTime", "@odata.context")

        # Select-String parameters
        $select_string_params = @{}
        $select_string_params['Pattern'] = $remove_from_json
        $select_string_params['NotMatch'] = $true
    
    } Process {
        Foreach ($p in $Path) {
            # Read the JSON file
            $json = Get-Content $p | Select-String @select_string_params
            $obj = $json | ConvertFrom-Json

            # Modify the JSON. If -NewDisplayName is specified, use that value. 
            # Otherwise, append (RESTORED) to the end of the display name
            If ($PSBoundParameters.ContainsKey("NewDisplayName")) {
                $display_name = $newDisplayName

            } Else {
                $display_name = "$($obj.displayName) (RESTORED)"
            
            }
            $json = [JsonModifier]::Modify($json, "displayName", $display_name) 
            If ($state -ne "Current") {
                $json = [JsonModifier]::Modify($json, "state", $state)

            }
            Try {
                # Invoke the Graph request
                Write-Verbose "Restoring the conditional access policy $display_name"
                $r = Invoke-MgGraphRequest @invoke_graph_params -Body $json

            } Catch {
                # Write the error message
                Write-Error "Failed to restore the conditional access policy $display_name due to the following error $($_.Exception.Message)" -ErrorAction Continue
            
            }
            # Return the response if -PassThru is specified
            if ($PassThru) {
                $r
            
            }
        }
    } End {


    }
}
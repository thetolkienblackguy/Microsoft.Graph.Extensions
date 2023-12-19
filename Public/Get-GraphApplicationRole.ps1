Function Get-GraphApplicationRole {
    <#
        .DESCRIPTION
        Gets the application roles for a given application id

        .SYNOPSIS
        Gets the application roles for a given application id

        .PARAMETER ApplicationId
        The application id of the application to get the roles for

        .PARAMETER OutputType
        The output type of the cmdlet. Valid values are PSObject, Hashtable, JSON, HttpResponseMessage

        .EXAMPLE
        Get-GraphApplicationRole -ApplicationId "00000000-0000-0000-0000-000000000000"

        .EXAMPLE
        Get-MgApplication -ApplicationId "00000000-0000-0000-0000-000000000000" | Get-GraphApplicationRole

        .EXAMPLE
        Get-GraphApplicationRole -ApplicationId "00000000-0000-0000-0000-000000000000" -OutputType "JSON"

        .INPUTS
        System.String

        .OUTPUTS
        System.Hashtable
        System.Management.Automation.PSCustomObject
        System.String

        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 12/17/2023
        Version: 0.0.1
        Name: Get-GraphApplicationRole

        Version History:
        0.0.1 - Alpha Release - 12/17/2023 - Gabe Delaney
    
    #>
    [CmdletBinding()]
    [OutputType(
        [System.Management.Automation.PSCustomObject],[Hashtable],[System.String]
        
    )]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [Alias("Id")]
        [guid]$ApplicationId,
        [Parameter(Mandatory=$false)]
        [ValidateSet(
            "PSObject","Hashtable","JSON"
        
        )]
        [string]$OutputType = "Hashtable"
    
    )
    Begin {
    } Process {
        $invoke_mg_params = @{}
        $invoke_mg_params["Method"] = "GET"
        $invoke_mg_params["Uri"] = "https://graph.microsoft.com/v1.0/applications/$($applicationId)?`$select=appRoles"
        $invoke_mg_params["OutputType"] = $outputType
        Try {
            $r = Invoke-MgGraphRequest @invoke_mg_params
        
        } Catch {
            Write-Error $_.Exception.Message -ErrorAction Stop
            
        }
    } End {
        If ($outputType -eq "JSON") {
            $r
        
        } Else {
            $r.appRoles
        
        } 
    }
}

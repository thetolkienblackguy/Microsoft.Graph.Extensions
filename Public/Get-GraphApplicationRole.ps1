Function Get-GraphApplicationRole {
    <#
        .DESCRIPTION
        Gets the application roles for a given application id

        .SYNOPSIS
        Gets the application roles for a given application id

        .PARAMETER ApplicationId
        The application id of the application to get the roles for

        .PARAMETER OutputType
        The output type of the cmdlet. Valid values are PSObject, Hashtable

        .EXAMPLE
        Get-GraphApplicationRole -ApplicationId "00000000-0000-0000-0000-000000000000"

        .EXAMPLE
        Get-MgApplication -ApplicationId "00000000-0000-0000-0000-000000000000" | Get-GraphApplicationRole

        .EXAMPLE
        Get-GraphApplicationRole -ApplicationId "00000000-0000-0000-0000-000000000000"

        .INPUTS
        System.String

        .OUTPUTS
        System.Management.Automation.PSCustomObject
    
    #>
    [CmdletBinding()]
    [OutputType([PSObject])]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [Alias("Id")]
        [guid]$ApplicationId
    
    )
    Begin {
    } Process {
        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Method"] = "GET"
        $invoke_mg_params["Uri"] = "https://graph.microsoft.com/v1.0/applications/$($applicationId)?`$select=appRoles"
        $invoke_mg_params["OutputType"] = "PSObject "
        
        # Invoke-MgGraphRequest
        Try {
            # Loop while there is a next link
            $output_obj = Do {
                $r = Invoke-MgGraphRequest @invoke_mg_params
                $r.appRoles
                $next_link = $r."@odata.nextLink"
                $invoke_mg_params["Uri"] = $next_link

            } While ($next_link)
        } Catch {
            # Write the error to the pipeline
            Write-Error $_.Exception.Message -ErrorAction Stop
            
        }
    } End {
        # Return the output object
        $output_obj
    }
}
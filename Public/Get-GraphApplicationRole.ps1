Function Get-GraphApplicationRole {
    <#
        .DESCRIPTION
        Gets the application roles for a given application id

        .SYNOPSIS
        Gets the application roles for a given application id

        .PARAMETER ServicePrincipalId
        The service principal id of the application to get the roles for

        .PARAMETER AppId
        The application id of the application to get the roles for

        .PARAMETER OutputType
        The output type of the cmdlet. Valid values are PSObject, Hashtable

        .EXAMPLE
        Get-GraphApplicationRole -ServicePrincipalId 00000000-0000-0000-0000-000000000000

        .EXAMPLE
        Get-GraphApplicationRole -AppId 00000000-0000-0000-0000-000000000000

        .EXAMPLE
        Get-GraphApplicationRole -AppId 00000000-0000-0000-0000-000000000000 -OutputType Hashtable

        .INPUTS
        System.Guid
        System.String

        .OUTPUTS
        System.Hashtable
        System.Management.Automation.PSCustomObject

        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 12/17/2023
        Version: 0.0.1
        Name: Get-GraphApplicationRole

        Version History:
        0.0.1 - Alpha Release - 12/17/2023 - Gabe Delaney
    
    #>
    [CmdletBinding(DefaultParameterSetName="ServicePrincipalId")]
    [OutputType(
        [System.Management.Automation.PSCustomObject],[Hashtable]
        
    )]
    param (
        [Parameter(
            Mandatory=$true,ParameterSetName="ServicePrincipalId",ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
            
        )]
        [Alias('Id')]
        [guid]$ServicePrincipalId,
        [Parameter(Mandatory=$true,ParameterSetName="AppId",ValueFromPipelineByPropertyName=$true)]
        [guid]$AppId,
        [Parameter(Mandatory=$false)]
        [ValidateSet(
            "PSObject","Hashtable"
        
        )]
        [string]$OutputType = "PSObject"
    
    )
    Begin {
        # Create identifier property for the request
        If ($PSCmdlet.ParameterSetName -eq "ServicePrincipalId") {
            $id = "/$($servicePrincipalId)"
            
        } Else {
            $id = "(appId='$($appId)')"
        
        }
    } Process {
        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Method"] = "GET"
        $invoke_mg_params["Uri"] = "https://graph.microsoft.com/v1.0/servicePrincipals$($id)?`$select=appRoles"
        $invoke_mg_params["OutputType"] = $outputType

        # Invoke the request
        Try {
            # Loop through the results if there is a next link
            $output_obj = Do {
                $r = Invoke-MgGraphRequest @invoke_mg_params
                $r.appRoles
                $next_link = $r."@odata.nextLink"
                $invoke_mg_params["Uri"] = $next_link

            } Until (!$next_link)
        } Catch {
            # If there is an error, write the error to the pipeline
            Write-Error $_.Exception.Message -ErrorAction Stop
            
        }
    } End {
        # Return the output object
        $output_obj
        
    }
}

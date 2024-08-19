Function Request-GraphUserEligibleDirectoryRole {
    <#
        .DESCRIPTION
        Requests a directory role for a user

        .SYNOPSIS
        Requests a directory role for a user

        .PARAMETER UserId
        Specifies the UserId

        .PARAMETER RoleDefinitionId
        Specifies the RoleDefinitionId

        .PARAMETER Justification
        Specifies the Justification

        .PARAMETER StartDateTime
        Specifies the StartDateTime

        .EXAMPLE
        Request-GraphUserEligibleDirectoryRole -UserId "jdoe@contoso.com" -RoleDefinitionId "00000000-0000-0000-0000-000000000000" -Justification "Requesting access to the role" -StartDateTime "2024-05-29T00:00:00Z" -Expiration "PT4H" -Action "SelfActivate" -DirectoryScopeId "/" -PassThru

        .EXAMPLE
        Request-GraphUserEligibleDirectoryRole -UserId "jdoe@contoso.com" -RoleDefinitionId "Global Administrator" -Justification "Requesting access to the role" -StartDateTime "2024-05-29T00:00:00Z" -Expiration "PT4H" -Action "SelfActivate" -DirectoryScopeId "/" -PassThru

        .INPUTS
        System.String 

        .OUTPUTS
        System.Management.Automation.PSCustomObject

        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 05/29/2024
        Version: 0.0.1
        Name: Request-GraphUserEligibleDirectoryRole

        Version History:
        0.0.1 - Original Release - Gabriel Delaney - 05/29/2024

    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param (
        [Parameter(Mandatory=$true)]
        [Alias("PrincipalId")]
        [string]$UserId,
        [Parameter(Mandatory=$true)]
        [Alias("Id", "DirectoryRole")]
        [string]$RoleDefinitionId,
        [Parameter(Mandatory=$false)]
        [string]$Justification = (Read-Host "Please provide a justification for this request"),
        [Parameter(Mandatory=$false)]
        [UtcDateTime]$StartDateTime = (Get-Date),
        [Parameter(Mandatory=$false)]
        [ValidateSet(
            "PT30M", "PT1H", "PT1H30M", "PT2H", "PT2H30M", "PT3H", "PT3H30M", "PT4H", "PT4H30M", 
            "PT5H", "PT5H30M", "PT6H", "PT6H30M", "PT7H", "PT7H30M", "PT8H"

        )]
        [string]$Expiration = "PT4H",
        [Parameter(Mandatory=$false)]
        [ValidateSet(
            "SelfActivate", "SelfDeactivate", "SelfExtend", "SelfRenew"
            
        )]
        [string]$Action = "SelfActivate",
        [Parameter(Mandatory=$false)]
        [string]$DirectoryScopeId = "/",
        [Parameter(Mandatory=$false)]
        [switch]$PassThru
    
    )    
    Begin {
        # Set the default parameter values for Write-Error
        $PSDefaultParameterValues = @{}
        $PSDefaultParameterValues["Write-Error:ErrorAction"] = "Stop"
        
    } Process {
        # Get-GraphUser and Get-GraphDirectoryRole
        Try {
            $id = (Get-GraphUser -UserId $userId).Id

            # This allows the function to accept a role definition ID or display name
            $roleDefinitionId = (Get-GraphDirectoryRole -DirectoryRole $roleDefinitionId).Id

        } Catch {
            # Write the error and stop the script if an error occurs
            Write-Error -Message $_ 
        
        }
        # Create the body for the request
        $body = @{}
        $body["PrincipalId"] = $id
        $body["RoleDefinitionId"] = $roleDefinitionId
        $body["Justification"] = $justification
        $body["DirectoryScopeId"] = $directoryScopeId
        $body["Action"] = $action
        $body["ScheduleInfo"] = @{}
        $body["ScheduleInfo"]["StartDateTime"] = $startDateTime.ToString()
        $body["ScheduleInfo"]["Expiration"] = @{}
        $body["ScheduleInfo"]["Expiration"]["Type"] = "AfterDuration"
        $body["ScheduleInfo"]["Expiration"]["Duration"] = $expiration

        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Uri"] = "https://graph.microsoft.com/v1.0/roleManagement/directory/roleAssignmentScheduleRequests"
        $invoke_mg_params["Method"] = "Post"
        $invoke_mg_params["Body"] = $body | ConvertTo-Json
        $invoke_mg_params["OutputType"] = "PSObject"
        If ($PSCmdlet.ShouldProcess($userId, "Request-GraphUserEligibleDirectoryRole")) {
            Try {
                # Invoke the request
                $r = Invoke-MgGraphRequest @invoke_mg_params

            } Catch {
                # Write the error
                Write-Error -Message $_ 

            }
        }
    } End {
        # Return the output if the -PassThru switch is used
        If ($passThru) {
            $r
        
        } 
    }
}
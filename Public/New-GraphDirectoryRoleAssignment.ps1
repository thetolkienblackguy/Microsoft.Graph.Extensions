Function New-GraphDirectoryRoleAssignment {
    <#
        .DESCRIPTION
        This function assigns a role to a principal in Microsoft Graph.

        .SYNOPSIS
        This function assigns a role to a principal in Microsoft Graph.

        .PARAMETER RoleDefinitionId
        The ID of the role to assign.

        .PARAMETER AssignmentType
        The type of assignment to create.

        .PARAMETER PrincipalId
        The ID of the principal to assign the role to.

        .PARAMETER DirectoryScopeId
        The ID of the directory scope to assign the role to.

        .PARAMETER Justification
        The justification for the assignment.

        .PARAMETER StartDateTime
        The start date and time of the assignment.

        .PARAMETER EndDateTime
        The end date and time of the assignment.

        .PARAMETER NoExpiration
        Switch to not set an expiration date.

        .PARAMETER PassThru
        Switch to return the role assignment object.

        .EXAMPLE
        New-GraphDirectoryRoleAssignment -RoleDefinitionId "12345678-1234-1234-1234-123456789012" -AssignmentType "Eligible" -PrincipalId "12345678-1234-1234-1234-123456789012" -DirectoryScopeId "/" -Justification "Assigning role via PowerShell" -NoExpiration -PassThru

        .EXAMPLE
        New-GraphDirectoryRoleAssignment -RoleDefinitionId "12345678-1234-1234-1234-123456789012" -AssignmentType "Active" -PrincipalId "12345678-1234-1234-1234-123456789012" -DirectoryScopeId "/" -Justification "Assigning role via PowerShell" -StartDateTime "2025-01-01T00:00:00Z" -EndDateTime "2025-01-01T00:00:00Z" -PassThru
    
        .INPUTS
        System.String
        System.Automation.SwitchParameter 

        .OUTPUTS
        System.Object
    
    #>
    [CmdletBinding(DefaultParameterSetName="AfterDateTime",SupportsShouldProcess=$true)]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        [string]$RoleDefinitionId,
        [Parameter(Mandatory=$false)]
        [ValidateSet("Eligible","Active")]
        [string]$AssignmentType = "Eligible",
        [Parameter(Mandatory=$true)]
        [string]$PrincipalId,
        [Parameter(Mandatory=$false)]
        [string]$DirectoryScopeId = "/",
        [Parameter(Mandatory=$false)]
        [string]$Justification = "Assigning role via PowerShell",
        [Parameter(Mandatory=$false)]
        [string]$StartDateTime = $((Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")),
        [Parameter(Mandatory=$true,ParameterSetName="AfterDateTime")]
        [string]$EndDateTime,
        [Parameter(Mandatory=$false,ParameterSetName="NoExpiration")]
        [Switch]$NoExpiration,
        [Parameter(Mandatory=$false)]
        [Switch]$PassThru

    )
    Begin {
        # Determine the URI based on the assignment type
        If ($assignmentType -eq "Eligible") {
            $uri = "https://graph.microsoft.com/v1.0/roleManagement/directory/roleEligibilityScheduleRequests"

        } Else {
            $uri = "https://graph.microsoft.com/v1.0/roleManagement/directory/roleAssignments"
            Write-Warning "EndDateTime is not currently supported for Active assignments." # TODO: Add support for EndDateTime

        }
        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Method"] = "POST"
        $invoke_mg_params["Uri"] = $uri
        $invoke_mg_params["OutputType"] = "PSObject"

    } Process {
        # Assigning role parameters
        $assignment_params = @{}
        $assignment_params["action"] = "AdminAssign"
        $assignment_params["justification"] = $justification
        $assignment_params["roleDefinitionId"] = $roleDefinitionId
        $assignment_params["directoryScopeId"] = $directoryScopeId
        $assignment_params["principalId"] = $principalId
        $assignment_params["scheduleInfo"] = @{}
        $assignment_params["scheduleInfo"]["startDateTime"] = $startDateTime
        $assignment_params["scheduleInfo"]["expiration"] = @{}

        # Determine the expiration type based on the parameter set
        If ($PSCmdlet.ParameterSetName -eq "NoExpiration") {
            $assignment_params["scheduleInfo"]["expiration"]["type"] = "NoExpiration"

        } Else {
            $assignment_params["scheduleInfo"]["expiration"]["endDateTime"] = $endDateTime
            $assignment_params["scheduleInfo"]["expiration"]["type"] = "AfterDateTime"
        
        }

        # Convert the assignment parameters to JSON
        $json_body = $assignment_params | ConvertTo-Json -Depth 4

        # Invoke the request
        If ($PSCmdlet.ShouldProcess($roleDefinitionId,"Assigning role to $principalId")) {
            Try {
                $r = Invoke-MgGraphRequest @invoke_mg_params -Body $json_body

            } Catch {
                # If an error occurs, log the error and continue
                Write-Error $_.Exception.Message -ErrorAction Stop

            }
        }
    } End {
        If ($passThru) {
            $r

        }
    }
}
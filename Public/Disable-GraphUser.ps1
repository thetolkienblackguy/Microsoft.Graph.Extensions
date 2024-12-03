Function Disable-GraphUser {
    <#
        .DESCRIPTION
        This function disables a user in Microsoft Graph.

        .SYNOPSIS
        This function disables a user in Microsoft Graph.

        .PARAMETER UserId
        The user ID of the user to disable.

        .PARAMETER RevokeSessions
        Switch to revoke the user's sign in sessions.

        .PARAMETER ApiVersion
        The API version to use. The default value is v1.0.

        .EXAMPLE
        Disable-GraphUser -UserId "12345678-1234-1234-1234-123456789012"

        .EXAMPLE
        Disable-GraphUser -UserId "12345678-1234-1234-1234-123456789012" -RevokeSessions

        .EXAMPLE
        Get-GraphUser -Filter "UserPrincipalName eq 'john.doe@contoso.com'" | Disable-GraphUser -RevokeSessions

        .INPUTS
        System.String
        System.String[]
        System.Automation.SwitchParameter        

        .OUTPUTS
        System.Object

    #>
    [CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact="High")]
    [OutputType([System.Management.Automation.PSCustomObject])]
    Param (
        [Parameter(
            Mandatory=$true,Position=0,ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
                
        )]
        [Alias(
            "Id","UserPrincipalName","UPN"
            
        )]
        [string[]]$UserId,
        [Parameter(Mandatory=$false)]
        [switch]$RevokeSessions,
        [Parameter(Mandatory=$false)]
        [ValidateSet("Beta","v1.0")]
        [string]$ApiVersion = "v1.0"
  
    )
    Begin {
        # Graph user endpoint
        $uri = "https://graph.microsoft.com/$apiVersion/users/{0}"
        
        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Method"] = "PATCH"
        $invoke_mg_params["Body"] = @{}
        $invoke_mg_params["Body"]["accountEnabled"] = $false
        
    } Process {
        If ($PSCmdlet.ShouldProcess($UserId,"Disable user")) {
            Try {
                # Disable user
                Invoke-MgGraphRequest @invoke_mg_params -Uri ($uri -f $UserId)

                # Revoke user sign in sessions, if the -RevokeSessions switch is used
                If ($revokeSessions) {
                    Revoke-GraphUserSignInSessions -UserId $UserId -Confirm:$false

                } Else {
                    Write-Warning -Message "User $UserId has been disabled, but sign in sessions have not been revoked. It is strongly recommended to revoke sign in sessions when disabling a user."
                    
                }
                If ($passThru) {
                    Get-GraphUser -UserId $UserId

                }
            } Catch {
                # Write error
                Write-Error -Message $_

            }
        }
    } End {
        
    }
}
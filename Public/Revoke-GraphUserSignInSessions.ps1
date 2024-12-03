Function Revoke-GraphUserSignInSessions {
    <#
        .DESCRIPTION
        This function revokes a user's sign in sessions in Microsoft Graph.

        .SYNOPSIS
        This function revokes a user's sign in sessions in Microsoft Graph.

        .PARAMETER UserId
        The user ID of the user whose sign in sessions are to be revoked.

        .PARAMETER ApiVersion
        The API version to use. The default value is v1.0.

        .EXAMPLE
        Revoke-GraphUserSignInSessions -UserId "12345678-1234-1234-1234-123456789012"

        .EXAMPLE
        Revoke-GraphUserSignInSessions -UserId "12345678-1234-1234-1234-123456789012" -ApiVersion "beta"

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
        [ValidateSet("Beta","v1.0")]
        [string]$ApiVersion = "v1.0",
        [Parameter(Mandatory=$false)]
        [switch]$PassThru
  
    )
    Begin {
        # Graph user endpoint
        $uri = "https://graph.microsoft.com/$apiVersion/users/{0}/revokeSignInSessions"
        
        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Method"] = "POST"

    } Process {
        If ($PSCmdlet.ShouldProcess($UserId,"Revoke user sign in sessions")) {
            Try {
                # Revoke user sign in sessions
                $r = Invoke-MgGraphRequest @invoke_mg_params -Uri ($uri -f $UserId)
                If ($passThru) {
                    $obj = @{}
                    $obj["UserId"] = $userId
                    $obj["SessionsRevoked"] = $r.Value
                    [pscustomobject]$obj
                
                }
            } Catch {
                # Write error
                Write-Error -Message $_
            
            }
        }
    } End {
        
    }
}
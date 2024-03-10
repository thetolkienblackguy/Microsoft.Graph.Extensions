Function ConvertTo-GraphExternalUser {
    <#
        .DESCRIPTION
        This function converts a pre-existing Azure AD member to a Guest using the Invitation API

        .SYNOPSIS
        This function converts a pre-existing Azure AD member to a Guest using the Invitation API
        
        .PARAMETER UserId
        Specifies the UserId

        .PARAMETER Mail
        Specifies the Mail

        .PARAMETER TenantName
        Specifies the TenantName

        .PARAMETER TenantId
        Specifies the TenantId

        .PARAMETER SendInvitation
        Specifies the SendInvitation

        .PARAMETER CustomizedMessageBody
        Specifies the CustomizedMessageBody

        .EXAMPLE
        ConvertTo-GraphExternalUser -UserId 5e327c38-652b-4e84-9e93-604daa1ce75e -Mail jdoe@contoso.com

        .EXAMPLE
        Get-MgUser -UserId 5e327c38-652b-4e84-9e93-604daa1ce75e | ConvertTo-GraphExternalUser 
    
        .INPUTS
        String
        Switch
        Boolean

        .OUTPUTS
        Object
    
        .NOTES
        Author: Gabe Delaney
        Version: 0.0.1
        Date: 02/14/2024
        Name: ConvertTo-GraphExternalUser

        Version History:
        0.0.1 - Original Release - 02/14/2024 - Gabe Delaney
    
    #>
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="Low")]
    [OutputType([PSObject])]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias("Id","ObjectId")]
        [string]$UserId,
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        [Alias("EmailAddress")]
        [string]$Mail,
        [Parameter(Mandatory=$false)]
        [string]$TenantName = (Get-MgDomain | Where-Object {$_.IsDefault}).Name,
        [Parameter(Mandatory=$false)]
        [string]$TenantId = (Get-MgContext).TenantId,
        [Parameter(Mandatory=$false)]
        [boolean]$SendInvitation = $false,
        [Parameter(Mandatory=$false)]
        [string]$CustomizedMessageBody = "You have been invited to collaborate with $tenantName. Please click the link to begin collaboration.",
        [Parameter(Mandatory=$false)]
        [switch]$PassThru
    
    ) 
    Begin {
        # Invoke-MgGraphRequest parameters
        $invoke_graph_params = @{}
        $invoke_graph_params["Uri"] = "https://graph.microsoft.com/v1.0/invitations"
        $invoke_graph_params["Method"] = "Post"
        $invoke_graph_params["OutputType"] = "PSObject"

    } Process {
        # Create the body of the request
        $body = @{}
        $body["invitedUserEmailAddress"] = $mail
        $body["invitedUser"] = @{}
        $body["invitedUser"]["id"] = $userId
        $body["sendInvitationMessage"] = $sendInvitation
        $body["inviteRedirectUrl"] = "https://myapps.microsoft.com/?$($tenantId)"
        $body["invitedUserMessageInfo"] = @{}
        $body["invitedUserMessageInfo"]["customizedMessageBody"] = $customizedMessageBody
        If ($PSCmdlet.ShouldProcess($mail, "ConvertTo-GraphExternalUser")) {        
            Try {
                # Invoke the request
                $r = (Invoke-MgGraphRequest @invoke_graph_params -Body $($body | ConvertTo-Json)).Value

            } Catch {
                Write-Error -Message $_.Exception.Message -ErrorAction Stop
                Exit 
            
            } 
        }
    } End {
        # Return the result if -PassThru is specified
        if ($passThru) {
            $r
        
        }    
    }
}
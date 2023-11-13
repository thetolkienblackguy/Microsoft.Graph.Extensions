Function Send-GraphMailMessage {
    <#
        .DESCRIPTION
        This function sends an email message using the Microsoft Graph API.

        .SYNOPSIS
        This function sends an email message using the Microsoft Graph API.

        .PARAMETER To
        Specifies the recipient(s) of the email message.

        .PARAMETER Subject
        Specifies the subject of the email message.

        .PARAMETER Body
        Specifies the body of the email message.

        .PARAMETER From
        Specifies the sender of the email message.

        .PARAMETER Cc
        Specifies the carbon copy recipient(s) of the email message.

        .PARAMETER Bcc
        Specifies the blind carbon copy recipient(s) of the email message.

        .PARAMETER Attachments
        Specifies the attachment(s) of the email message.

        .EXAMPLE
        Send-GraphMailMessage -To "john.doe@contoso.com" -From "jane.doe@contoso.com" -Subject "Test" -Body "This is a test"

        .EXAMPLE
        Send-GraphMailMessage -To "john.doe@contoso.com" -From "jane.doe@contoso.com" -Subject "Test" -Body "This is a test" -Attachments "C:\Temp\test.txt"

        .LINK
        https://docs.microsoft.com/en-us/graph/api/user-sendmail?view=graph-rest-1.0&tabs=http
        
        .INPUTS
        System.String
        System.IO.FileInfo
        System.Management.Automation.SwitchParameter

        .OUTPUTS
        System.Collections.Hashtable

        .NOTES
        Author: Gabe Delaney | gdelaney@phzconsulting.com
        Version: 0.0.1
        Date: 11/09/2023
        Name: Send-GraphMailMessage

        Version History:
        0.0.1 - Alpha Release - 11/09/2023 - Gabe Delaney
    
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (      
        [Parameter(Mandatory=$true)]
        [Alias("Recipient")]
        [string[]]$To,
        [Parameter(Mandatory=$true)]
        [string]$Subject,
        [Parameter(Mandatory=$true)]
        [Alias("EmailBody")]
        [string]$Body,
        [Parameter(Mandatory=$true)]
        [Alias("Sender")]
        [string]$From,
        [Parameter(Mandatory=$false)]
        [string[]]$Cc,
        [Parameter(Mandatory=$false)]
        [string[]]$Bcc,
        [Parameter(Mandatory=$false)]
        [system.io.fileinfo[]]$Attachments,
        [Parameter(Mandatory=$false)]
        [switch]$PassThru

    )
    Begin {
        # Creating parent message hash table
        $mail_message = @{}
        $mail_message["message"] = ""
           
        # Creating message hash table
        $message = @{}
        $message["subject"] =  $PSBoundParameters["Subject"]
        $message["body"] = [ordered] @{
            contentType = "HTML"
            content = $PSBoundParameters["Body"]

        }
        # Setting recipients
        $message["toRecipients"] = @(Set-GraphRecipientArray -Recipients $to)
        
        # Setting cc recipients
        If ($PSBoundParameters.ContainsKey("Cc")) {
            $message["ccRecipients"] = @(Set-GraphRecipientArray -Recipients $cc)

        }

        # Setting Bcc recipients
        If ($PSBoundParameters.ContainsKey("Bcc")) {
            $message["bccRecipients"] = @(Set-GraphRecipientArray -Recipients $bcc)

        }

        # Setting attachments
        If ($PSBoundParameters.ContainsKey("Attachments")) {
            $message["attachments"] = @(Set-GraphAttachmentArray -Attachments $attachments])

        }

        # Setting the message key
        $mail_message["message"] = $message

        # Setting the Invoke-MgGraphRequest parameters
        $invoke_mggraph_params = @{}
        $invoke_mggraph_params["Uri"] = "https://graph.microsoft.com/v1.0/users/$from/sendMail"
        $invoke_mggraph_params["Method"] = "Post"
        $invoke_mggraph_params["Body"] = $mail_message | ConvertTo-Json -Depth 4
        $invoke_mggraph_params["ContentType"] = "application/json"

    } Process {
        # Sending the message
        $r = Invoke-MgGraphRequest @invoke_mggraph_params

    } End {
        # Returning the response if the PassThru switch is used
        If ($PassThru) {
            $r

        }
    }
} 
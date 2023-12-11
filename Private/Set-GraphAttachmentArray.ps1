Function Set-GraphAttachmentArray {
    <#
        .DESCRIPTION
        This function sets the attachment array for the Send-GraphMailMessage function.

        .SYNOPSIS
        This function sets the attachment array for the Send-GraphhMailMessage function.

        .PARAMETER Attachments
        This is the array of attachments.

        .EXAMPLE
        Set-GraphAttachmentArray -Attachments @("C:\Temp\test.txt")

        .LINK
        https://docs.microsoft.com/en-us/graph/api/user-sendmail?view=graph-rest-1.0&tabs=http

        .INPUTS
        System.IO.File

        .OUTPUTS
        System.Collections.ArrayList

        .NOTES
        Author: Gabe Delaney | gdelaney@phzconsulting.com
        Version: 0.0.1
        Date: 11/09/2023
        Name: Set-GraphAttachmentArray

        Version History:
        0.0.1 - Alpha Release - 11/09/2023 - Gabe Delaney


    #>
    [CmdletBinding()]
    [OutputType([System.Collections.ArrayList])]
    param (   
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [array]$Attachments

    )
    Begin {
        # Create the attachment array
        $attachment_array = [system.collections.arraylist]::new()

    } Process {
        # Loop through each attachment and add it to the attachment array
        Foreach ($attachment in $attachments) {
            # Create the attachment table
            $attachment_table = @{}
            $attachment_table["@odata.type"] = "#microsoft.graph.fileAttachment"
            $attachment_table["name"] = $attachment | Split-Path -Leaf
            $attachment_table["contentType"] = "text/plain"
            $attachment_table["contentBytes"] = [Convert]::ToBase64String([IO.File]::ReadAllBytes((Get-Item $attachment).FullName))
            
            # Add the attachment table to the attachment array
            [void]$attachment_array.Add($attachment_table)

        }
    } End {
        $attachment_array

    }  
}
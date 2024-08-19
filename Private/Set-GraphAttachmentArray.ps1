Function Set-GraphAttachmentArray {
    <#
        .DESCRIPTION
        This is a helper function to create an attachment array for the Send-GraphMailMessage function.

        .LINK
        https://docs.microsoft.com/en-us/graph/api/user-sendmail?view=graph-rest-1.0&tabs=http

        .INPUTS
        System.Array

        .OUTPUTS
        System.Col

        .NOTES
        Author: Gabe Delaney | gdelaney@phzconsulting.com
        Version: 0.0.1
        Date: 11/09/2023
        Name: Set-GraphAttachmentArray

        Version History:
        0.0.1 - Alpha Release - 11/09/2023 - Gabe Delaney

    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.List[PSObject]])]
    param (   
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [array]$Attachments

    )
    Begin {
        # Create the attachment array
        $attachment_array = [system.collections.generic.list[psobject]]::new()

    } Process {
        # Loop through each attachment and add it to the attachment array
        Foreach ($attachment in $attachments) {
            # Get the file info
            $attachment_file_info = Get-Item $attachment
            
            # Create the attachment table
            $attachment_table = @{}
            $attachment_table["@odata.type"] = "#microsoft.graph.fileAttachment"
            $attachment_table["name"] = $attachment | Split-Path -Leaf
            $attachment_table["contentType"] = [MimeMapping]::GetMimeType($attachment_file_info.FullName)
            $attachment_table["contentBytes"] = [Convert]::ToBase64String([IO.File]::ReadAllBytes(($attachment_file_info).FullName))
            
            # Add the attachment table to the attachment array
            $attachment_array.Add($attachment_table)

        }
    } End {
        $attachment_array

    }  
}
Function Set-GraphRecipientArray {
    <#
        .DESCRIPTION
        This is a helper function that sets the recipient array for the Send-GraphMailMessage function.

        .INPUTS
        System.Array

        .OUTPUTS
        System.Collections.Generic.List[PSObject]

        .LINK
        https://docs.microsoft.com/en-us/graph/api/user-sendmail?view=graph-rest-1.0&tabs=http

        .NOTES
        Author: Gabe Delaney | gdelaney@phzconsulting.com
        Version: 0.0.1
        Date: 11/09/2023
        Name: Set-GraphRecipirentArray

        Version History:
        0.0.1 - Alpha Release - 11/09/2023 - Gabe Delaney

    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.List[PSObject]])]
    param (   
        [Parameter(Mandatory=$true)]
        [string[]]$Recipients

    )
    Begin {
        # Create the recipient array
        $recipient_array = [system.collections.generic.list[psobject]]::new()
        
    } Process {
        # Loop through each recipient and add it to the recipient array
        Foreach ($recipient in $recipients) {
            # Create the address table          
            $address = @{}
            $address["address"] = $recipient

            # Create the recipient table
            $recipient_table = @{}
            $recipient_table["emailAddress"] = $address

            # Add the recipient table to the recipient array
            $recipient_array.Add($recipient_table)

        }
    } End {
        # Return the recipient array
        $recipient_array

    }  
}
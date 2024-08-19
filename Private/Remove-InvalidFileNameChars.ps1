function Remove-InvalidFileNameChars {
    <#
        .DESCRIPTION
        Removes invalid characters from a file name
    
        .SYNOPSIS
        Removes invalid characters from a file name

        .PARAMETER FileName
        The file name to remove invalid characters from

        .EXAMPLE
        Remove-InvalidFileNameChars -FileName "My File Name.txt"

        .INPUTS
        System.String

        .OUTPUTS
        System.String

        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 11/14/2023
        Version: 0.0.1
        Name: Remove-InvalidFileNameChars

        Version History:
        0.0.1 - Alpha Release - 11/14/2023 - Gabe Delaney
     
    #>
    [CmdletBinding()]
    [outputType([system.string])]
    param (
        [Parameter(Mandatory=$true)]
        [string]$FileName
    
    )
    Begin {
        # Define a regular expression pattern for invalid characters
        $invalid_char = "[$([RegEx]::Escape([String][IO.Path]::GetInvalidFileNameChars()))]"

    } Process {
        # Use regex replace to remove all invalid characters
        $new_file_name = [RegEx]::Replace($FileName, $invalid_char, "_")

    } End {
        $new_file_name 

    }
}
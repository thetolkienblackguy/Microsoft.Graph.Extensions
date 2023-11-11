Function Backup-GraphConditionalAccessPolicy {
    <#
        .DESCRIPTION
        Backs up a Entra Id Conditional Access Policy to a JSON file

        .SYNOPSIS
        Backs up a Entra Id Conditional Access Policy to a JSON file

        .PARAMETER ConditionalAccessPolicyId
        The Id of the Conditional Access Policy to backup

        .PARAMETER Path
        The path to save the backup file to

        .EXAMPLE
        Backup-GraphConditionalAccessPolicy -ConditionalAccessPolicyId "00000000-0000-0000-0000-000000000000" -Path "C:\temp"

        .INPUTS
        System.String
        System.IO.FileInfo

        .OUTPUTS
        System.IO.File

        .LINK
        https://docs.microsoft.com/en-us/graph/api/resources/conditionalaccesspolicy?view=graph-rest-1.0
        
        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 11/11/2023
        Version: 0.0.1
        Name: Backup-GraphConditionalAccessPolicy

        Version History:
        0.0.1 - Alpha Release - 11/09/2023 - Gabe Delaney

    #>
    [CmdletBinding()]
    [OutputType([system.string])]
    Param (
        [Parameter(Mandatory=$true, ValueFromPipeline, ValueFromPipelineByPropertyName=$true)]
        [Alias("Id","PolicyId")]
        [string[]]$ConditionalAccessPolicyId,
        [Parameter(Mandatory=$true)]
        [ValidateScript({
            Test-Path -Path $_ -PathType "Container"
        
        })]
        [system.io.fileinfo]$Path
        
    )
    Begin {
        # Set the default parameter values
        $PSDefaultParameterValues = @{}
        $PSDefaultParameterValues["Join-Path:Path"] = $path
        $PSDefaultParameterValues["ConvertTo-Json:Depth"] = 10

    } Process {
        Foreach ($id in $conditionalAccessPolicyId) {
            # Get the policy
            Write-Verbose -Message "Backing up Conditional Access Policy with Id: $id"
            $policy = Get-mgIdentityConditionalAccessPolicy -ConditionalAccessPolicyId $id

            # Create the file name
            $file_name = "$($policy.DisplayName.ToString()).json"

            # Create the file path
            $file_path = Join-Path -ChildPath ([RemoveInvalidCharsFromFileName]::RemoveInvalidChars($file_name)) 

            # Save the policy
            Write-Verbose -Message "Saving Conditional Access Policy to $file_path"
            $policy | ConvertTo-Json | Out-File -FilePath $file_path 

        }
    } End {

    }
}
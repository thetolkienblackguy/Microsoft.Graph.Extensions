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

        .EXAMPLE
        Get-MgIdentityConditionalAccessPolicy | Backup-GraphConditionalAccessPolicy -Path "C:\temp"

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
        0.0.1 - Alpha Release - 11/11/2023 - Gabe Delaney

    #>
    [CmdletBinding()]
    [OutputType([system.string])]
    Param (
        [Parameter(Mandatory=$true,ValueFromPipeline,ValueFromPipelineByPropertyName=$true)]
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
        $PSDefaultParameterValues["ConvertTo-Json:Depth"] = 10
        $PSDefaultParameterValues["Invoke-MgGraphRequest:Method"] = "GET"

    } Process {
        Foreach ($id in $conditionalAccessPolicyId) {
            # Get the policy
            Try {
                # Get the policy
                $policy = Invoke-MgGraphRequest -Uri "https://graph.microsoft.com/v1.0/identity/conditionalAccess/policies/$id"

            } Catch {
                # Write the error
                Write-Error -Message "Failed to backup Conditional Access Policy with Id: $id. Due to error: $($_.Exception.Message)"

            }

            # Create the file name
            $file_name = "$($policy.DisplayName.ToString()).json"

            # Create the file path
            $file_path = Join-Path -ChildPath $(Remove-InvalidFileNameChars -FileName $file_name) -Path $path

            # Save the policy
            Write-Verbose -Message "Saving Conditional Access Policy to $file_path"
            $policy | ConvertTo-Json | Out-File -FilePath $file_path 

        }
    } End {

    }
}
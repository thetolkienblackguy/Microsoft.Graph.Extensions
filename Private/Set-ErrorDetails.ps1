Function Set-ErrorDetails {
    <#
        .DESCRIPTION
        This function is used to create a hashtable with the error details of a function.
        The hashtable can be used to create a custom error object.

        .SYNOPSIS
        This function is used to create a hashtable with the error details of a function.
    
        .PARAMETER Identity
        The identity of the object that had the error.

        .PARAMETER Function
        The name of the function that was called.

        .PARAMETER Message
        The message that will be displayed in the error.

        .PARAMETER Category
        The category of the error. Default is ObjectNotFound.

        .PARAMETER CategoryTargetName
        The target name of the error.

        .PARAMETER CategoryActivity
        The activity of the error.

        .PARAMETER CartegoryTargetType
        The target type of the error.

        .PARAMETER CategoryReason
        The reason of the error.

        .PARAMETER Exception
        The exception of the error.

        .PARAMETER ErrorDetails
        The error details of the error.

        .PARAMETER ErrorId
        The error id of the error.

        .EXAMPLE
        Set-ErrorDetails -Identity jdoe -Function Get-ADUser 
    
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    Param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string[]]$Identity,
        [Parameter(Mandatory=$true)]
        [string]$Function,
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [Parameter(Mandatory=$true)]
        [string]$Category,
        [Parameter(Mandatory=$false)]
        [string]$CategoryTargetName = ($identity | Out-String -Stream),
        [Parameter(Mandatory=$false)]
        [string]$CategoryActivity = $function,
        [Parameter(Mandatory=$true)]
        [string]$CategoryTargetType,
        [Parameter(Mandatory=$false)]
        [string]$CategoryReason,
        [Parameter(Mandatory=$false)]
        [string]$Exception,
        [Parameter(Mandatory=$false)]
        [string]$ErrorDetails,
        [Parameter(Mandatory=$false)]
        [string]$ErrorId = (Get-Date).Ticks.ToString()

    )
    Begin {
        # Set default parameter values
        $PSDefaultParameterValues = @{}
        $PSDefaultParameterValues["Get-Variable:ValueOnly"] = $true
        $PSDefaultParameterValues["Get-Variable:ErrorAction"] = "SilentlyContinue"

        # Create an array with the keys to remove from the hashtable
        $keys_to_remove = @("Identity","Function",[System.Management.Automation.PSCmdlet]::CommonParameters)

        # Create the hashtable
        $error_details = [ordered]@{}

        # Get the parameters of the function
        $parameters = (Get-Command -Name $MyInvocation.InvocationName).Parameters.Keys 

    } Process {
        # Add the parameters to the hashtable
        Foreach ($key in $parameters) {
            If ($key.ToString() -notin $keys_to_remove) {
                $value = Get-Variable -Name $key
                if ($value) {
                    $error_details[$key] = $value
                
                }
            }
        }
    } End {
        # Return the hashtable
        $error_details

    }
}
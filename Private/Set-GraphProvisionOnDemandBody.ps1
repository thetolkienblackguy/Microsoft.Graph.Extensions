Function Set-GraphProvisionOnDemandBody {
    <#
        .SYNOPSIS
        Creates the table for Test-GraphCrossTenantProvisionOnDemand

        .DESCRIPTION
        Creates the table for Test-GraphCrossTenantProvisionOnDemand

        .PARAMETER ObjectId
        The object ID of the user or group to test

        .PARAMETER ObjectTypeName
        The type of object to test

        .PARAMETER RuleId
        The ID of the provisioning rule to test

        .EXAMPLE
        Set-GraphProvisionOnDemandBody -ObjectId "12345678-1234-1234-1234-123456789012" -ObjectTypeName "User" -RuleId "12345678-1234-1234-1234-123456789012"

        .INPUTS
        System.String

        .OUTPUTS
        System.Collections.Hashtable

        .NOTES
        Author: Gabriel Delaney
        Date: 11/24/2023
        Version: 0.0.1
        Name: Set-GraphProvisionOnDemandBody

        Version History:
        0.0.1 - Alpha Release - 11/24/2023 - Gabe Delaney
        
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory=$true)]
        [string[]]$ObjectId,
        [Parameter(Mandatory=$true)]
        [validateset(
            "User","Group"
            
        )]
        [string]$ObjectTypeName,
        [Parameter(Mandatory=$true)]
        [string]$RuleId
    
    )
    Begin {
        # Create the body hash
        $body = @{}

        # Create the subjects hash
        $subjects = @{}

        # Create the rule_id hash
        $rule_id = @{}

        # Create the params array
        $params_array = [System.Collections.ArrayList]::new()

        # Create the subject array
        $subjects_array = [System.Collections.ArrayList]::new()

    } Process {
        # Add the subjects to the subjects array
        Foreach ($id in $objectId) {
            $obj = @{}
            $obj["ObjectId"] = $id
            $obj["ObjectTypeName"] = $objectTypeName
            [void]$subjects_array.Add($obj)
        
        }

        # Add the subjects array to the subjects hash
        $subjects["Subjects"] = $subject_array

        # Add the ruleId to the rule_id hash to the params array
        $rule_id["RuleId"] = $ruleId

        # Add the subjects hash to the params array
        [void]$params_array.Add($subjects)

        # Add the rule_id hash to the params array
        [void]$params_array.Add($rule_id)

        # Add the params array to the Table hash
        $body["Parameters"] = $params_array

    } End {
        $body

    }
}
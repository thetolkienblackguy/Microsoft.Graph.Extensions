Function ConvertTo-GraphPolicyFlatObject {
    [cmdletbinding()]
    param(
        [parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [object]$InputObject,
        [parameter(Mandatory=$false)]
        [string]$BaseName,
        [parameter(Mandatory=$false)]
        [switch]$AsHashTable

    )
    Begin {
        $ErrorActionPreference = "Continue"
        $output_object = [ordered]@{}
        $flat_types = @(
            "String", "DateTime", "TimeSpan", "Version", "Enum", "Array", "Boolean"

        )
        $exclude = @(
            "AdditionalProperties"

        )
    } Process {
        If (!$inputObject) {
            return 

        } ElseIf ($inputObject -is [Object]) {
            Foreach ($p in $inputObject.PSObject.Properties) {
                If ($PSBoundParameters.ContainsKey("BaseName")) {
                    $key_name = "$($baseName)$($p.Name)"

                } Else {
                    $key_name = $p.Name

                }
                If (!$p.Value) {
                    $output_object[$key_name] = $null

                } ElseIf ($p.Name -in $exclude) {
                    Continue

                } ElseIf ($p.Value.GetType().Name -in $flat_types) {
                    $output_object[$key_name] = $inputObject.$($p.Name) -join ", "                    
        
                } ElseIf ($p.Value -is [System.Collections.IEnumerable]) {
                    $output_object[$key_name] = $inputObject.$($p.Name) -join ", "
 
                } Else {
                    $ErrorActionPreference = "SilentlyContinue"
                    $output_object += ConvertTo-GraphPolicyFlatObject -InputObject $p.Value -BaseName $p.Name -AsHashTable

                }
            }
        }
    } End {
        If ($asHashTable) {
            $output_object

        } Else {
            [pscustomobject]$output_object

        }
    }
}
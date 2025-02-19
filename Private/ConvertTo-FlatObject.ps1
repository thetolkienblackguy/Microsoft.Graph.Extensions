function ConvertTo-FlatObject {
    <#
        .DESCRIPTION
        Converts a Graph API object to a flat object. This is useful for exporting to CSV or other formats that don't support nested objects. 
        
        .PARAMETER InputObject
        The object to convert.

        .PARAMETER Prefix
        A prefix to add to the property names. This is useful for avoiding conflicts with existing property names.

        .PARAMETER ExistingProperties
        A set of existing property names. This is used to avoid conflicts with existing property names.

        .EXAMPLE
        $output = Get-GraphConditionalAccessPolicy | ConvertTo-FlatObject

        .INPUTS
        System.Object
        System.Collections.Generic.HashSet[string]
        System.String

        .OUTPUTS
        System.Object
    
    #>
    [CmdletBinding()]
    [OutputType([PSObject])]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [object]$InputObject,
        [Parameter(Mandatory=$false)]
        [string]$Prefix,
        [Parameter(Mandatory=$false)]
        [System.Collections.Generic.HashSet[string]]$ExistingProperties = [System.Collections.Generic.HashSet[string]]::new()
    
    )
    Begin {
        $PSDefaultParameterValues = @{}
        $PSDefaultParameterValues["Add-Member:Force"] = $true
        $flat_object = New-Object PSObject
        $text_info = [System.Globalization.CultureInfo]::CurrentCulture.TextInfo
    
    } Process {
        foreach ($property in $InputObject.PSObject.Properties) {
            $property_name = $text_info.ToTitleCase($property.Name)
            $original_name = $property_name
            
            # Check if the property name already exists, if so, use the prefix
            If ($existingProperties.Contains($property_name)) {
                $property_name = if ($prefix) { 
                    "$($prefix)_$($property_name)" 
                
                } Else { 
                    $property_name 
                
                }
            }
            # Add the property name to the set of existing properties
            [void]$existingProperties.Add($original_name)
            
            If ($property.Value -is [Hashtable] -or $property.Value -is [PSObject]) {
                $nested_object = ConvertTo-FlatObject -InputObject $property.Value -Prefix $property_name -ExistingProperties $ExistingProperties
                
                Foreach ($nested_property in $nested_object.PSObject.Properties) {
                    if (!$flat_object.PSObject.Properties[$nested_property.Name]) {
                        $flat_object | Add-Member -NotePropertyName $nested_property.Name -NotePropertyValue ($nested_property.Value -join ", ")
                    
                    }
                }
            } Else {
                if (!$flat_object.PSObject.Properties[$property_name]) {
                    $flat_object | Add-Member -NotePropertyName $property_name -NotePropertyValue ($property.Value -join ", ")
                
                }
            }
        }
    } End {
        $flat_object
    
    }
}
Function ConvertTo-FlatObject {
    <#
        .DESCRIPTION
        Converts a Graph API object to a flat object. This is useful for exporting to CSV or other formats that don't support nested objects. 
        
        .PARAMETER InputObject
        The object to convert.

        .EXAMPLE
        $output = Get-GraphConditionalAccessPolicy | ConvertTo-GraphFlatObject

        .INPUTS
        System.Object

        .OUTPUTS
        System.Object
        
        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 11/11/2023
        Version: 0.0.1
        Name: ConvertTo-FlatObject

        Version History:
        0.0.1 - Alpha Release - 11/11/2023 - Gabe Delaney
    
        TODO: More testing

    #>
    [CmdletBinding()]
    [OutputType([System.Object])]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [object]$InputObject

    )
    Begin {
        # Set the default parameter values
        $PSDefaultParameterValues = @{}
        $PSDefaultParameterValues["Add-Member:Force"] = $true

        # Create the output object
        $flat_object = New-Object PSObject

        # Create the text info object
        $text_info = [System.Globalization.CultureInfo]::CurrentCulture.TextInfo

    } Process {        
        # loop through the properties
        foreach ($property in $inputObject.PSObject.Properties) {
            # Capitalize the property name
            $property_name = $text_info.ToTitleCase($property.Name)

            # If the property is hashtables or PSObjects, then we need to flatten it
            if ($property.Value -is [Hashtable] -or $property.Value -is [PSObject]) {
                $nested_object = ConvertTo-FlatObject -InputObject $property.Value 
                foreach ($nested_property in $nested_object.PSObject.Properties) {
                    # Add the nested properties to the output object
                    $flat_object | Add-Member -NotePropertyName $nested_property.Name -NotePropertyValue ($nested_property.Value -join ", ")
                }
            } else {
                # Add the property to the output object
                $flat_object | Add-Member -NotePropertyName "$($prefix)$($property_name)" -NotePropertyValue $($property.Value -join ", ")
            }
        }
    } End {
        # Return the output object
        $flat_object
    
    }
}
class DefaultProperties:System.Management.Automation.ArgumentTransformationAttribute {
    [string[]]$default_properties

    # DefaultProperties constructor
    DefaultProperties([string[]]$default_properties) {
        $this.default_properties = $default_properties
    
    }

    # Transform method
    [object] Transform([System.Management.Automation.EngineIntrinsics]$engine_intrinsics, [object]$input_data) {
        return [Linq.Enumerable]::ToArray([Linq.Enumerable]::Distinct([string[]]($this.Default_Properties + $input_data)))
    
    }
}
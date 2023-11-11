class SecureStringTransformation:System.Management.Automation.ArgumentTransformationAttribute {
    [object]Transform([System.Management.Automation.EngineIntrinsics]$engine_intrinsics, [object]$str) {
        if ($str -is [System.Security.SecureString]) {
            return [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
                [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($str)
            
            )
        } else {
            return $str
        
        }
    }
}
class SecureStringDecoder:System.Management.Automation.ArgumentTransformationAttribute {
    [object]Transform([System.Management.Automation.EngineIntrinsics]$engine_intrinsics, [object]$str) {
        # If the parameter is a secure string, convert it to plain text
        if ($str -is [System.Security.SecureString]) {
            return [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
                [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($str)
            
            )
        } else {
            # Otherwise, return the parameter as-is
            return $str
        
        }
    }
}
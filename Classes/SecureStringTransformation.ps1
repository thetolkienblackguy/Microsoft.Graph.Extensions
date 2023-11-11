class SecureStringTransformation:System.Management.Automation.ArgumentTransformationAttribute {
    [object]Transform([System.Management.Automation.EngineIntrinsics]$engineIntrinsics, [object]$inputData) {
        if ($inputData -is [System.Security.SecureString]) {
            return [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
                [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($inputData)
            
            )
        } else {
            return $inputData
        
        }
    }
}
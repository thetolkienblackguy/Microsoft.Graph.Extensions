class AuthenticationMethodData {
    static [string]GetDeviceData([string]$method_type, [System.Collections.IDictionary]$data_table) {
        $device = Switch ($method_type) {
            "PhoneAuthentication" {
                $data_table["phoneType", "phoneNumber"] -join ' '; Break
            
            } "TemporaryAccessPass" {
                "Lifetime: $($data_table["lifetimeInMinutes"])m - Status:$($data_table["methodUsabilityReason"])"; Break
            
            } "Fido2" {
                $data_table["model"]; Break
            
            } "EmailAuthentication" {
                $data_table["emailAddress"]; Break
            
            } Default {
                $data_table["displayName"]; Break
            
            } 
        }
        return $device
    
    }
}
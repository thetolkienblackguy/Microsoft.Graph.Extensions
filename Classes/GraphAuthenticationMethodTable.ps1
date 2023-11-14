class GraphAuthenticationMethodTable {
    static [System.Collections.IDictionary]$method_table = @{
        "#microsoft.graph.microsoftAuthenticatorAuthenticationMethod" = "AuthenticatorApp"
        "#microsoft.graph.phoneAuthenticationMethod" = "PhoneAuthentication"
        "#microsoft.graph.passwordAuthenticationMethod" = "PasswordAuthentication"
        "#microsoft.graph.fido2AuthenticationMethod" = "Fido2"
        "#microsoft.graph.windowsHelloForBusinessAuthenticationMethod" = "WindowsHelloForBusiness"
        "#microsoft.graph.emailAuthenticationMethod" = "EmailAuthentication"
        "#microsoft.graph.temporaryAccessPassAuthenticationMethod" = "TemporaryAccessPass"
        "#microsoft.graph.passwordlessMicrosoftAuthenticatorAuthenticationMethod" = "Passwordless"
        "#microsoft.graph.softwareOathAuthenticationMethod" = "SoftwareOath"
    
    }
    static [string]GetAuthenticationMethod([string]$method) {
        If ([GraphAuthenticationMethodTable]::method_table.ContainsKey($method)) {
            return [GraphAuthenticationMethodTable]::method_table[$method]
        
        } Else {
            Write-Error "Method $method not found in the table." -ErrorAction Continue
            return $null
        
        }
    }
}
class GraphApplicationSecretInfoObject {
    static[object]Create([object]$app, [object]$secret, [int]$days_until_expiration, [bool]$expired, [string]$thumb_print, [string]$key_type) {
        $obj = [ordered]@{}
        $obj["AppDisplayName"] = $app.DisplayName
        $obj["AppId"] = $app.AppId
        $obj["Id"] = $app.Id
        $obj["ExpirationDate"] = $secret.EndDateTime
        $obj["DaysUntilExpiration"] = $days_until_expiration
        $obj["Expired"] = $expired
        $obj["Thumbprint"] = $thumb_print
        $obj["KeyType"] = $key_type
        $obj["KeyId"] = $secret.KeyId
        $obj["Description"] = $secret.DisplayName
        return [pscustomobject]$obj
    
    }
}
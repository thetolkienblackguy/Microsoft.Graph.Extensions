class JsonModifier {
    static [string] Modify([string]$json, [string]$key, [string]$newValue) {
        # Regex pattern to match the key and its value
        $pattern = '(?<="' + [regex]::Escape($key) + '":\s).*?(?=[,}])'

        # Check if the key exists
        If ($json -match $pattern) {
            # Replace the value of the key
            $json = $json -replace $pattern, "`"$newValue`""
        
        } Else {
            Write-Warning "The key '$key' does not exist in the JSON."
            return $null
        
        }
        return $json
        
    }
}
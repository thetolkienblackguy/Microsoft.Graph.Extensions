class RemoveInvalidCharsFromFileName {
    static [string]RemoveInvalidChars([string]$file_name) {
        # Define a regular expression pattern for invalid characters
        $invalid_char = "[$([RegEx]::Escape([String][IO.Path]::GetInvalidFileNameChars()))]"

        # Use regex replace to remove all invalid characters
        return [RegEx]::Replace($file_name, $invalid_char, "_")

    }
}
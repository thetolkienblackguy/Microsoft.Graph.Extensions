# Get public and private function definition files.
$public  = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue)
$private = @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)
# Get classes
$classes = @(Get-ChildItem -Path $PSScriptRoot\Classes\*.ps1 -ErrorAction SilentlyContinue)

# Dot source the files
Foreach($import in @($classes + $public + $private)) {
    $full_name = $import.fullname
    Try {
        . $full_name
    
    } Catch {
        Write-Error -Message "Failed to import function $($full_name): $_"
    
    }
}

Export-ModuleMember -Function $public.Basename

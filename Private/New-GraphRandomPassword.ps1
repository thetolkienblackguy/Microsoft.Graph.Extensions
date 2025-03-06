Function New-GraphRandomPassword {
        <#
        .SYNOPSIS
        This function generates a random complex password and returns it as a secure string. 

        .DESCRIPTION
        This function generates a random complex password and returns it as a secure string. 
    
        .PARAMETER PasswordLength
        This is the length of the password you would like generated. 

        .PARAMETER CopyToClipboard
        This switch will copy a plaintext version of the password to your clipboard. 

        .PARAMETER AsPlainText
        This switch will return the password as a plaintext string.  This is useful for passing the password to other functions

        .PARAMETER UsePassphrase
        This switch will generate a passphrase instead of a password.  This is useful for generating a password that is easy to remember

        .EXAMPLE
        New-GraphRandomPassword -PasswordLength 14

        .EXAMPLE
        New-GraphRandomPassword -PasswordLength 8 -CopyToClipboard

        .INPUTS
        Int32

        .OUTPUTS
        SecureString
        
    #>
    [CmdletBinding(DefaultParameterSetName="RandomPassword")]
    [OutputType([System.Security.SecureString])]
    param (        
        [Parameter(Mandatory=$false,Position=0)] 
        [int]$PasswordLength = 14,
        [Parameter(Mandatory=$false)]
        [switch]$AsPlainText,
        [Parameter(Mandatory=$false)]
        [switch]$CopyToClipboard,
        [Parameter(ParameterSetName="UsePassphrase",Mandatory=$false)]
        [switch]$UsePassphrase,
        [Parameter(ParameterSetName="UsePassphrase",Mandatory=$true)]
        [string[]]$WordList
            
    )
    Begin {
        If ($PSBoundParameters.ContainsKey("UsePassphrase")) {
            $alpha = $wordList | Get-Random -Count 1
            $numeric = ([Char[]]"1234567890"| Get-Random -count ($passwordLength - $alpha.Length - 1)) -join ""
            $password = "$($alpha)_$($numeric)"

        } Else {
            Do {
                $password = ([Char[]]"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ123456789!@#$%*+=&"| Get-Random -count $passwordLength) -join ""
                If ($password -cmatch "[A-Z\p{Lu}\s]" -and $password -cmatch "[a-z\p{Ll}\s]" -and $password -match "[\d]" -and $password -match "[^\w]") {
                    $complexity_check = $true 

                } 
            } While (!$complexity_check)
        }
    } Process {
        If ($copyToClipboard) { 
            $password | Set-Clipboard
        
        }
        $secure_str = $password | ConvertTo-SecureString -AsPlainText -Force 
    
    } End {
        If ($PSBoundParameters.ContainsKey("AsPlainText")) {
            Return [pscustomobject] [ordered] @{
                Password = $password 
                SecureString = $secure_str

            }
        } Else {
            Return $secure_str

        }
    }
}
Function Set-GraphUserCertificateUserIds {
    <#
        .DESCRIPTION
        This function sets the certificate user ids for a user in Azure AD. The function can be used to set the certificate user ids to a value or to a certificate file. 
        The function can also be used to append a certificate user id to the existing certificate user ids.

        .SYNOPSIS
        This function sets the certificate user ids for a user in Azure AD. The function can be used to set the certificate user ids to a value or to a certificate file.
    
        .PARAMETER UserId
        The user id of the user to set the certificate user ids for. This can be the user's object id or user principal name

        .PARAMETER CertificateMapping
        The certificate mapping to use. Valid values are PrincipalName, RFC822Name, X509SKI, and X509SHA1PublicKey. The default value is PrincipalName

        .PARAMETER Value
        The value to set the certificate user ids to. This parameter is required if the parameter set is "Value"

        .PARAMETER CertificatePath
        The path to the certificate file to set the certificate user ids to. This parameter is required if the parameter set is "Path"

        .PARAMETER Append
        If this switch is specified, the certificate user id will be appended to the existing certificate user ids. If this switch is not specified, the existing certificate user ids will be overwritten.

        .PARAMETER PassThru
        If this switch is specified, the user object will be returned after the certificate user ids have been set.
    
        .EXAMPLE
        Set-GraphUserCertificateUserIds -UserId "John.Doe@contoso.com" -CertificateMapping "PrincipalName" -Value "john.doe@contoso.com" -PassThru

        .EXAMPLE
        Set-GraphUserCertificateUserIds -UserId "John.Doe@contoso.com" -CertificateMapping "PrincipalName" -CertificatePath "C:\Users\John.Doe\Documents\John.Doe.cer"

    #>
    [CmdletBinding(
        DefaultParameterSetName="Value",SupportsShouldProcess=$true,ConfirmImpact="Low"
        
    )]
    [OutputType([PSObject])]
    param (
        [Parameter(
            Mandatory=$true,Position=0,ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true
        
        )]
        [string]$UserId,
        [Parameter(Mandatory=$true,Position=1)]
        [ValidateSet(
            "PrincipalName", "RFC822Name", "X509SKI", "X509SHA1PUblicKey"
    
        )]
        [Alias(
            "Binding", "X509Mapping"

        )]
        [string]$CertificateMapping,
        [Parameter(Mandatory=$true,ParameterSetName="Value")]
        [string]$Value,
        [Parameter(Mandatory=$true,ParameterSetName="Path")]
        [ValidateScript({
            Test-Path $_ -PathType Leaf
        
        })]
        [System.IO.FileInfo]$CertificatePath,
        [Parameter(Mandatory=$false)]
        [switch]$Append,
        [Parameter(Mandatory=$false)]
        [switch]$PassThru

    )
    Begin {
        # Set the error action preference to stop
        $ErrorActionPreference = "Stop"

        # Set the default parameter values for Write-Error
        $PSDefaultParameterValues = @{}
        $PSDefaultParameterValues["Write-Error:ErrorAction"] = "Stop"

        # Create an array of properties to get from the user object
        $properties = @(
            "UserPrincipalName", "Id", "authorizationInfo"

        )
        # Create a hashtable to map the certificate mapping to the prefix, friendly name, and pattern
        # Might make more sense as function or class
        $extension_table = [System.Collections.IDictionary] @{}
        $extension_table["PrincipalName"] = @("PN","Subject Alternative Name","Principal Name")
        $extension_table["RFC822Name"] = @("RFC822","Subject Alternative Name","RFC822 Name")
        $extension_table["X509SKI"] = @("SKI","Subject Key Identifier", $null)
        $extension_table["X509SHA1PublicKey"] = @("SHA1-PUKEY", $null, $null)

        # Get the extension array from the hashtable
        $extension_array = $extension_table[$certificateMapping]

        # Set the prefix, friendly name, and pattern
        $prefix = "X509:<$($extension_array[0])>"
        $friendly_name = $extension_array[1]
        If ($($extension_array[2])) { 
            $pattern = "$($extension_array[2])=(.+)"

        } Else {
            $pattern = $null
        
        }
    } Process {
        $get_user_params = @{}
        $get_user_params["UserId"] = $userId
        $get_user_params["Select"] = $properties
        Try {
            $user = Get-GraphUser @get_user_params
            $id = $user.Id

        } Catch {
            Write-Error -Message $_ -ErrorAction Stop

        }
        Try {
            # If the parameter set is "Value", check if the value matches the prefix. If not, add the prefix to the value
            If ($PSCmdlet.ParameterSetName -eq "Value") {
                If ($value -notmatch "$prefix(.+)") {
                    $value = "$prefix$value"
                    
                }
            } Else {
                # If the parameter set is "Path", get the certificate object and get the extension data
                $cert_obj = [System.Security.Cryptography.X509Certificates.X509Certificate2]((Get-Item $certificatePath).FullName)
                If ($friendly_name) {

                    # If the pattern is set, get the extension data and match the pattern. If the pattern matches, get the value from the match
                    # Could be a function?
                    $extension_data = ($cert_obj.Extensions | Where-Object {$_.Oid.FriendlyName -eq $friendly_name}).Format($true)
                    If ($pattern) {
                        $extension_data -match $pattern | Out-Null
                        If ($matches) {
                            $value = "$($prefix)$($matches[1].Trim())"

                        } Else {
                            Write-Error -Message "Failed to update the CertificateUserIds for $userId. An extension with the friendly name '$friendly_name' doesn't appear to be on the provided certificate"

                        }
                    } Else {
                        $value = "$($prefix)$($extension_data.Trim())"
                    
                    }
                } Else {
                    $value = "$($prefix)$($cert_obj.Thumbprint.ToLower())"
                
                }
                If (!$value) {
                    Write-Error -Message "Failed to get the certificate extension data for certificate $certificatePath" 
                
                }
            }
            
            # If the append switch is set, get the existing certificate user ids and add the new value to the array
            $certificate_user_ids = [System.Collections.ArrayList] @()
            if ($append) {
                $existing_ids = $user.authorizationInfo.certificateUserIds
                [void]$certificate_user_ids.AddRange(@($existing_ids))

            }
            # If the new value is not already in the array, add it
            If ($certificate_user_ids -notcontains $value) {
                [void]$certificate_user_ids.Add($value)

            }
            # If the array has more than 5 values, throw an error
            If ($certificate_user_ids.Count -gt 5) {
                Write-Error -Message "User $userId already has the max of 5 certificate user ids. Please remove one before adding another"

            }
            # Create the authorization info object and add the certificate user id
            $auth_info = @{}
            $auth_info["authorizationInfo"] = @{}
            $auth_info["authorizationInfo"]["certificateUserIds"] = $certificate_user_ids

            # Invoke-MgGraphRequest parameters
            $invoke_mg_params = @{}
            $invoke_mg_params["Method"] = "PATCH"
            $invoke_mg_params["Uri"] = "https://graph.microsoft.com/v1.0/users/$id"
            $invoke_mg_params["Body"] = $auth_info

        } Catch {
            Write-Error =<Message "Failed to update the CertificateUserIds to $value for user $userId due to the following error: $($_.Exception.Message)"
        
        }

        # Update the user
        If ($PSCmdlet.ShouldProcess("$id","Set-CertificateUserIds")) {
            Try {     
                Invoke-MgGraphRequest @invoke_mg_params
                Write-Verbose "Updated the CertificateUserIds to $value for user $userId"
            
            } Catch {
                Write-Error -Message "Failed to update the CertificateUserIds to $value for user $userId due to the following error: $($_.Exception.Message)"
            
            }
        }
    } End {
        # Return the user object if -PassThru is specified
        If ($passThru) {
            Start-Sleep -Seconds 5
            Get-GraphUser @get_user_params | Select-Object UserPrincipalName, Id, @{
                Name="CertificateUserIds";Expression={
                    $_.authorizationInfo.certificateUserIds    
                
                }
            }
        } 
    }
}
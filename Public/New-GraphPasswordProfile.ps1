Function New-GraphPasswordProfile {
    <#
        .SYNOPSIS
        Creates a password profile for a user in Microsoft Graph.
        
        .DESCRIPTION
        This function creates a password profile for a user in Microsoft Graph.
        
        .PARAMETER Password
        The password to set for the user.
        
        .PARAMETER ForceChangePasswordNextSignIn
        Whether to force the user to change their password on the next sign-in.

        .PARAMETER ForceChangePasswordNextSignInWithMfa
        Whether to force the user to change their password on the next sign-in with MFA.
        
        .EXAMPLE
        New-GraphPasswordProfile

        .EXAMPLE
        New-GraphPasswordProfile -Password (New-GraphRandomPassword) -ForceChangePasswordNextSignIn $true -ForceChangePasswordNextSignInWithMfa $true
        
        .INPUTS
        System.String
        System.Boolean

        .OUTPUTS
        System.Collections.Hashtable
    
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
        [Parameter(Mandatory=$false)]
        [string]$Password = (New-GraphRandomPassword -AsPlainText).Password,
        [Parameter(Mandatory=$false)]
        [bool]$ForceChangePasswordNextSignIn = $true,
        [Parameter(Mandatory=$false)]
        [bool]$ForceChangePasswordNextSignInWithMfa = $false
    
    )
    # Create a password profile
    $password_profile = @{}
    $password_profile["password"] = $password
    $password_profile["forceChangePasswordNextSignIn"] = $forceChangePasswordNextSignIn
    $password_profile["forceChangePasswordNextSignInWithMfa"] = $forceChangePasswordNextSignInWithMfa
    
    # Return the password profile
    $password_profile

}

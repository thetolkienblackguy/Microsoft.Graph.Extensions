Function Invoke-GraphConditionalAccessPolicyEvaluation {
    <#
        .DESCRIPTION
        This function evaluates conditional access policies for a user or application. The function 
        can be used to evaluate conditional access policies based on the user ID, applications, 
        user actions, device platforms, sign-in risk levels, user risk levels, countries, and 
        IP addresses. The function returns the conditional access policies that apply to the user 
        or application in the form of a PSObject.

        .SYNOPSIS
        This function evaluates conditional access policies for a user or application.

        .PARAMETER UserId
        The user ID of the user to evaluate conditional access policies for.

        .PARAMETER IncludeApplications
        The applications to include in the evaluation.

        .PARAMETER UserAction
        The user action to evaluate conditional access policies for.

        .PARAMETER DevicePlatform
        The device platforms to evaluate conditional access policies for.

        .PARAMETER SignInRiskLevel
        The sign-in risk levels to evaluate conditional access policies for.

        .PARAMETER UserRiskLevel
        The user risk levels to evaluate conditional access policies for.

        .PARAMETER Country
        The countries to evaluate conditional access policies for.

        .PARAMETER IpAddress
        The IP addresses to evaluate conditional access policies for.

        .EXAMPLE
        Invoke-GraphConditionalAccessPolicyEvaluation -UserId "12345678-1234-1234-1234-123456789012" -IncludeApplications "00000000-0000-0000-0000-000000000000" -DevicePlatform "iOS" -SignInRiskLevel "Low" -UserRiskLevel "Low" -Country "US"

        .EXAMPLE
        Get-MgUser -UserId "john.doe@contoso.com" | Invoke-GraphConditionalAccessPolicyEvaluation -IncludeApplications "00000000-0000-0000-0000-000000000000" -DevicePlatform "iOS" -SignInRiskLevel "Low" -UserRiskLevel "Low" -Country "US"

        .EXAMPLE
        Invoke-GraphConditionalAccessPolicyEvaluation -UserId "12345678-1234-1234-1234-123456789012" -UserAction "registerOrJoinDevices"

        .INPUTS
        System.String
        System.String[]
        System.Management.Automation.SwitchParameter

        .OUTPUTS
        System.Management.Automation.PSObject

        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 08/30/2024
        Version: 0.0.2
        Name: Invoke-GraphConditionalAccessPolicyEvaluation

        Version History:
        0.0.1 - Alpha Release - 06/08/2024 - Gabe Delaney
        0.0.2 - Corrected an issue where the function would return all results, and not just policies that apply. 
                - 08/30/2024 - Gabe Delaney
    
    #>
    [CmdletBinding(DefaultParameterSetName="Application")]
    [OutputType([System.Management.Automation.PSObject])]
    param (
        [Parameter(
            Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true
            
        )]
        [Alias("Id")]
        [string]$UserId,
        [Parameter(Mandatory=$false, ParameterSetName="Application")]
        [string[]]$IncludeApplications = @(),
        [Parameter(Mandatory=$true, ParameterSetName="UserAction")]
        [ValidateSet("registerOrJoinDevices", "registerSecurityInformation")]
        [Parameter(Mandatory=$false)]
        [string]$UserAction,
        [ValidateSet(
            "All", "Android", "iOS", "windows", "windowsPhone", "macOS", "linux"
            
        )]
        [string]$DevicePlatform,
        [Parameter(Mandatory=$false)]
        [ValidateSet("None", "Low", "Medium", "High")]
        [string]$SignInRiskLevel,
        [Parameter(Mandatory=$false)]
        [ValidateSet("None", "Low", "Medium", "High")]
        [string]$UserRiskLevel,
        [Parameter(Mandatory=$false)]
        [ValidateSet(
            "AD", "AE", "AF", "AG", "AI", "AL", "AM", "AO", "AQ", "AR", 
            "AS", "AT", "AU", "AW", "AX", "AZ", "BA", "BB", "BD", "BE", 
            "BF", "BG", "BH", "BI", "BJ", "BL", "BM", "BN", "BO", "BQ", 
            "BR", "BS", "BT", "BV", "BW", "BY", "BZ", "CA", "CC", "CD", 
            "CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN", "CO", "CR", 
            "CU", "CV", "CW", "CX", "CY", "CZ", "DE", "DJ", "DK", "DM", 
            "DO", "DZ", "EC", "EE", "EG", "EH", "ER", "ES", "ET", "FI", 
            "FJ", "FK", "FM", "FO", "FR", "GA", "GB", "GD", "GE", "GF", 
            "GG", "GH", "GI", "GL", "GM", "GN", "GP", "GQ", "GR", "GS", 
            "GT", "GU", "GW", "GY", "HK", "HM", "HN", "HR", "HT", "HU", 
            "ID", "IE", "IL", "IM", "IN", "IO", "IQ", "IR", "IS", "IT", 
            "JE", "JM", "JO", "JP", "KE", "KG", "KH", "KI", "KM", "KN", 
            "KP", "KR", "KW", "KY", "KZ", "LA", "LB", "LC", "LI", "LK", 
            "LR", "LS", "LT", "LU", "LV", "LY", "MA", "MC", "MD", "ME", 
            "MF", "MG", "MH", "MK", "ML", "MM", "MN", "MO", "MP", "MQ", 
            "MR", "MS", "MT", "MU", "MV", "MW", "MX", "MY", "MZ", "NA", 
            "NC", "NE", "NF", "NG", "NI", "NL", "NO", "NP", "NR", "NU", 
            "NZ", "OM", "PA", "PE", "PF", "PG", "PH", "PK", "PL", "PM", 
            "PN", "PR", "PS", "PT", "PW", "PY", "QA", "RE", "RO", "RS", 
            "RU", "RW", "SA", "SB", "SC", "SD", "SE", "SG", "SH", "SI", 
            "SJ", "SK", "SL", "SM", "SN", "SO", "SR", "SS", "ST", "SV", 
            "SX", "SY", "SZ", "TC", "TD", "TF", "TG", "TH", "TJ", "TK", 
            "TL", "TM", "TN", "TO", "TR", "TT", "TV", "TW", "TZ", "UA", 
            "UG", "UM", "US", "UY", "UZ", "VA", "VC", "VE", "VG", "VI", 
            "VN", "VU", "WF", "WS", "YE", "YT", "ZA", "ZM", "ZW"
            
        )]
        [string]$Country,
        [Parameter(Mandatory=$false)]
        [ValidateScript({
            $_ -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$"
        
        })]
        [string]$IpAddress

    )
    Begin {
        # Set error action preference to stop
        $ErrorActionPreference = "Stop"

        # Create user action context
        $action_context = @{}
        $action_context["@odata.type"] = "#microsoft.graph.whatIfUserActionContext"
        $action_context["userAction"] = $userAction

        # Create application context
        $app_context = @{}
        $app_context["@odata.type"] = "#microsoft.graph.whatIfApplicationContext"
        $app_context["includeApplications"] = @($includeApplications)

        # Create context table with application and user action contexts
        $context_table = [System.Collections.IDictionary] @{}
        $context_table["Application"] = $app_context
        $context_table["UserAction"] = $action_context

        # Create evaluation definition
        $evaluation_definition = @{}
        $evaluation_definition["conditionalAccessWhatIfSubject"] = @{}
        $evaluation_definition["conditionalAccessWhatIfSubject"]["@odata.type"] = "#microsoft.graph.userSubject"
        $evaluation_definition["conditionalAccessContext"] = $context_table[$PSCmdlet.ParameterSetName]
        $evaluation_definition["conditionalAccessWhatIfConditions"] = @{}

        # Add conditions to evaluation definition
        $conditions = $evaluation_definition["conditionalAccessWhatIfConditions"]
        Foreach ($key in $PSBoundParameters.Keys) {
            if ($key -notin @("UserId", "IncludeApplications", "UserAction")) {
                $conditions[$key] = $PSBoundParameters[$key]
                
            }
        }

        # Invoke-MgGraphRequest parameters
        $invoke_mg_params = @{}
        $invoke_mg_params["Method"] = "POST"
        $invoke_mg_params["Uri"] = "https://graph.microsoft.com/beta/identity/conditionalAccess/evaluate?`$count=true`&`$orderby=createdDateTime desc"
        $invoke_mg_params["Headers"] = @{}
        $invoke_mg_params["Headers"]["ConsistencyLevel"] = "eventual"
        $invoke_mg_params["OutputType"] = "PSObject"

    } Process {
        # Finalize evaluation definition
        $evaluation_definition["conditionalAccessWhatIfSubject"]["userId"] = $userId
        
        # Finalize invoke-MgGraphRequest parameters
        $invoke_mg_params["Body"] = $evaluation_definition | ConvertTo-Json -Depth 10
        Try {
            Do {
                $r = (Invoke-MgGraphRequest @invoke_mg_params)
                $r.Value | Where-Object {
                    $_.policyApplies -or $_.reasons -contains "notEnoughInformation"
                
                } 
                $invoke_mg_params["Uri"] = $r."@odata.nextLink"
            
            # Looping through the results until there are no more results
            } Until (!$r."@odata.nextLink")

        } Catch {
            Write-Error -Message $_ -ErrorAction Stop

        }
    } End {

    }
}
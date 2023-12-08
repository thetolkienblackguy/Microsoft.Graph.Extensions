Function Get-GraphApplicationSignInLogs {
    <#
        .DESCRIPTION
        Gets the sign in logs for an application from the Microsoft Graph API

        .SYNOPSIS
        Gets the sign in logs for an application from the Microsoft Graph API

        .PARAMETER AppDisplayName
        The display name of the application

        .PARAMETER AppId
        The application ID

        .PARAMETER StartDate
        The start date for the logs

        .PARAMETER EndDate
        The end date for the logs

        .EXAMPLE
        Get-GraphApplicationSignInLogs -AppDisplayName "Microsoft Teams" -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date)

        .EXAMPLE
        Get-GraphApplicationSignInLogs -AppId "00000003-0000-0ff1-ce00-000000000000" -StartDate (Get-Date).AddDays(-30) -EndDate (Get-Date)

        .INPUTS
        System.String
        UTCDateTime (Class)
        System.Management.Automation.SwitchParameter

        .OUTPUTS
        System.Collections.Generic.List[Object]

        .LINK
        https://docs.microsoft.com/en-us/graph/api/signin-list?view=graph-rest-1.0&tabs=http

        .NOTES
        Author: Gabe Delaney | gdelaney@phzconsulting.com
        Version: 0.0.1
        Date: 12/06/2023
        Name: Get-GraphApplicationSignInLogs

        Version History:
        0.0.1 - Alpha Release - 12/06/2023 - Gabe Delaney
          
    #>
    [CmdletBinding(DefaultParameterSetName="AppDisplayName")]
    [OutputType([System.Collections.Generic.List[Object]])]
    Param (
        [Parameter(Mandatory=$true,ParameterSetName="AppDisplayName")]
        [String]$AppDisplayName,
        [Parameter(Mandatory=$true,ParameterSetName="AppId")]
        [String]$AppId,
        [Parameter(Mandatory=$false)]
        [Alias("Start")]
        [utcdatetime]$StartDate = (Get-Date 00:00:00).AddDays(-30),
        [Parameter(Mandatory=$false)]
        [Alias("End")]
        [utcdatetime]$EndDate = (Get-Date 00:00:00)

    )
    Begin {
        # Create a list to store the output
        $output_obj = [System.Collections.Generic.List[Object]]::new()

        # Create the filter string
        $filter = "createdDateTime ge {0} and createdDateTime le {1}" -f $startDate.ToString(), $endDate.ToString()
        
        # Update the filter string based on the parameter set
        If ($PSCmdlet.ParameterSetName -eq "AppDisplayName") {
            Write-Warning "AppDisplayName is case sensitive, if you are not seeing any results, try using the AppId parameter instead"
            $filter += " and appDisplayName eq '$appDisplayName'"
        
        } ElseIf ($PSCmdlet.ParameterSetName -eq "AppId") {
            $filter += " and appId eq '$appId'"
        
        }

        # Invoke-MgGraphRequest parameters
        $invoke_graph_params = @{}
        $invoke_graph_params["Uri"] = "https://graph.microsoft.com/v1.0/auditLogs/signIns?`$filter=$filter"
        $invoke_graph_params["Method"] = "GET"
        $invoke_graph_params["OutputType"] = "PSObject"
    } Process {
        # Invoke the Graph request
        Do {
            $r = Invoke-GraphRequest @invoke_graph_params

            # Add the results to the output list
            [void]$output_obj.AddRange($r.value)

            # Update the next link
            $next_link = $r.'@odata.nextLink'
            $invoke_graph_params["Uri"] = $next_link
        
        # Continue while there is a next link
        } While ($next_link)
    } End {
        # Return a warning if no sign in logs are found
        If (!$output_obj) {
            Write-Warning "No sign in logs found for the specified application and date range"
        
        } Else {
            # Return the output
            $output_obj

        }
    }
}
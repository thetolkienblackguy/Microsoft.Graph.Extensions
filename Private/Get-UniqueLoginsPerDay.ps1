function Get-UniqueLoginsPerDay {
    <#
        .DESCRIPTION
        Gets the unique logins per day from a list of sign in logs

        .SYNOPSIS
        Gets the unique logins per day from a list of sign in logs

        .PARAMETER Logs
        The sign in logs

        .EXAMPLE
        Get-UniqueLoginsPerDay -Logs $logs

        .INPUTS
        System.Object

        .OUTPUTS
        System.Collections.Generic.List[Object]

        .NOTES
        Author: Gabe Delaney | gdelaney@phzconsulting.com
        Version: 0.0.1
        Date: 12/06/2023
        Name: Get-UniqueLoginsPerDay

        Version History:
        0.0.1 - Alpha Release - 12/06/2023 - Gabe Delaney
    
    #>
    [CmdletBinding()]
    [OutputType([System.Collections.Generic.List[Object]])]
    param (
        [Parameter(Mandatory=$true)]
        [object[]]$Logs
    
    )
    Begin {
        # Create a list to store the output
        $output_obj = [System.Collections.Generic.List[Object]]::new()
        

    } Process {
        # Get the earliest date from the logs
        $earliest_date = ($logs | Measure-Object -Property createdDateTime -Minimum).Minimum.Date

        # Get the latest date from the logs
        $latest_date = ($logs | Measure-Object -Property createdDateTime -Maximum).Maximum.Date
        
        # Create a date range from the earliest date to the latest date
        $time_span = New-TimeSpan -Start $earliest_date -End $latest_date
        $date_range = for ($i = 0; $i -le $time_span.Days; $i++) {
            $earliest_date.AddDays($i)
        
        }
        # Group the logs by date
        $obj_groups = $logs | Group-Object @{Expression={($_.createdDateTime).Date.ToString("MM/dd/yyyy")}} 

        # Loop through the date range
        Foreach ($date in $date_range) {
            # Create an ordered hashtable to store the output
            $obj = [ordered] @{}
            $obj["AppDisplayName"] = $logs[0].appDisplayName

            # Convert the date to a string
            $date_str = $date.ToString("MM/dd/yyyy")

            # Check if there are any logs for the date
            $logins = $obj_groups | Where-Object Name -eq $date_str

            # If there are logs, get the unique logins and users
            if ($logins) {
                $unique_logins = $logins.Group | Select-Object userPrincipalName -Unique
                $obj["Date"] = $date_str
                $obj["UniqueLogins"] = $unique_logins.Count
                $obj["Users"] = $unique_logins.userPrincipalName -join ", "
            
            # If there are no logs, set the unique logins and users to 0 and empty string
            } else {
                $obj["Date"] = $date_str
                $obj["UniqueLogins"] = 0
                $obj["Users"] = ""

            }

            # Add the object to the output list
            [void]$output_obj.Add([pscustomobject]$obj)
        
        }
    } End {
        # Return the output
        $output_obj

    }
}
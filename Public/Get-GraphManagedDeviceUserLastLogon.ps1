Function Get-GraphManagedDeviceUserLastLogon {
    <#
        .DESCRIPTION
        Gets the user principal name and last logon date time for a managed device

        .SYNOPSIS
        Gets the user principal name and last logon date time for a managed device

        .PARAMETER DeviceId
        Specifies the DeviceId

        .PARAMETER DeviceName
        Specifies the DeviceName

        .PARAMETER ConvertFromUtc
        Specifies whether to convert the LastSyncDateTime and LastLogonDateTime to local time

        .PARAMETER Select
        Specifies the properties to select

        .EXAMPLE
        Get-GraphManagedDeviceUserLastLogon -DeviceId "12345678-1234-1234-1234-123456789012"

        .EXAMPLE
        Get-GraphManagedDeviceUserLastLogon -DeviceName "DeviceName"

        .INPUTS
        System.String
        System.Boolean

        .OUTPUTS
        System.Management.Automation.PSCustomObject

        .NOTES
        Author: Gabriel Delaney | gdelaney@phzconsulting.com
        Date: 05/29/2024
        Version: 0.0.1
        Name: Get-GraphManagedDeviceUserLastLogon

        Version History:
        0.0.1 - Alpha Release - Gabriel Delaney - 05/29/2024
        
    #>
    [CmdletBinding(DefaultParameterSetName="DeviceId")]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param (
        [Parameter(
            Mandatory=$true, ValueFromPipelineByPropertyName=$true, ValueFromPipeline=$true, ParameterSetName="DeviceId"
            
        )]
        [Alias("Id")]
        [string[]]$DeviceId,
        [Parameter(
            Mandatory=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName="DeviceName"
            
        )]
        [string]$DeviceName,
        [Parameter(Mandatory=$false)]
        [boolean]$ConvertFromUtc = $true,
        [Parameter(Mandatory=$false)]
        [string[]]$Select = @(
            "Id","DeviceName","LastSyncDateTime","OperatingSystem", "OSVersion", 
            "SerialNumber", "Model", "Manufacturer", "JoinType", "UsersLoggedOn"

        )
    )
    Begin {
        # Setting the error action preference
        $ErrorActionPreference = "Stop"

        # Setting default parameter values
        $PSDefaultParameterValues = @{}
        $PSDefaultParameterValues["Add-Member:Membertype"] = "NoteProperty"
        $PSDefaultParameterValues["Add-Member:Force"] = $true
        $PSDefaultParameterValues["Invoke-MgGraphRequest:Method"] = "GET"
        $PSDefaultParameterValues["Invoke-MgGraphRequest:OutputType"] = "PSObject"

        # Add the UsersLoggedOn property to the select array if it is not present
        If ($select -notcontains "UsersLoggedOn") {
            $select += "UsersLoggedOn"
        
        }

        # Set the function name
        $function = $MyInvocation.MyCommand.Name
    } Process {
        Try {
            # Get the device id if the device name is provided
            If ($PSCmdlet.ParameterSetName -eq "DeviceName") {
                $uri = "https://graph.microsoft.com/beta/deviceManagement/managedDevices?`$filter=deviceName eq '$($deviceName)'&`$select=id"
                $deviceId = (Invoke-MgGraphRequest -Uri $uri ).Value.Id

                # If the device id is not found, set the error details
                If (!$deviceId) {
                    # Setting the error details
                    $error_details_params = @{}
                    $error_details_params["Message"] = "Resource '$deviceName' does not exist or one of its queried reference-property objects are not present"
                    $error_details_params["Identity"] = $deviceName
                    $error_details_params["Function"] = $function
                    $error_details_params["Category"] = "ObjectNotFound"
                    $error_details_params["CategoryTargetType"] = "Microsoft.Graph.managedDevice"
                    $write_error_params = Set-ErrorDetails @error_details_params

                    # Setting the error message
                    Write-Error @write_error_params
                    Break
                
                } 
            } 
            # Set the uri
            $uri = "https://graph.microsoft.com/beta/deviceManagement/managedDevices/$($deviceId)?`$select=$($select -join ",")"

            # Invoke the graph request
            $r = Invoke-MgGraphRequest -Uri $uri

        } Catch {
            # Write the error
            Write-Error $_ -ErrorAction Stop

        }
        # Add the properties to the output object
        Foreach ($property in @("UserPrincipalName","LastLogonDateTime","MultipleUsers")) {
            $r | Add-Member -Name $property -Value $null

        }
        # Convert the LastSyncDateTime to local time if the ConvertFromUtc parameter is set to true
        If ($convertFromUtc) {
            $r.LastSyncDateTime = $r.LastSyncDateTime.ToLocalTime()

        }

        # Check if there are multiple users logged on
        If ($r.usersLoggedOn.Count -gt 1) {
            $r.MultipleUsers = $true

        } Else {
            $r.MultipleUsers = $false

        }

        # Create an output object array
        # This seems inelegant, but it works
        $output_obj = Foreach ($u in $r.UsersLoggedOn) {
            # Get the user principal name for the userId
            $r.UserPrincipalName = (Get-GraphUser -UserId $u.UserId).UserPrincipalName

            # Get the last logon date time for the userId if it exists
            $r.LastLogonDateTime = If ($u.LastLogonDateTime) {
                # Convert the LastLogonDateTime to local time if the ConvertFromUtc parameter is set to true
                If ($convertFromUtc) {
                    $u.LastLogonDateTime.ToLocalTime()
        
                # Return the LastLogonDateTime if the ConvertFromUtc parameter is set to false
                } Else {
                    $u.LastLogonDateTime
                
                }
            } Else {
                $null
            
            }
            $r | Select-Object -ExcludeProperty UsersLoggedOn,"@odata.context"
            
        }
        # Return the output object
        $output_obj 

    } End {

    }
}
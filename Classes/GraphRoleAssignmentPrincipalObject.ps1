class GraphRoleAssignmentPrincipalObject {
    static [object]Create([psobject]$principal, [hashtable]$appRoleTable, [psobject]$member = $null) {
        $obj = [ordered]@{}
        $obj["DisplayName"] = if ($member) { 
            $member.displayName 
        
        } else { 
            $principal.principalDisplayName 
        
        }
        $obj["Id"] = if ($member) { 
            $member.id 
        
        } else { 
            $principal.principalId 
        
        }
        $obj["PrincipalType"] = if ($member) { 
            $odata_type = $member."@odata.type" 
            If ($odata_type) { 
                $text_info = (Get-Culture).TextInfo
                $text_info.ToTitleCase($odata_type -replace "#microsoft.graph.", "" ) 
                           
            } Else { 
                "User" 
            
            }        
        } else { 
            $principal.principalType 
        
        }
        $obj["AppRoleId"] = $principal.appRoleId
        $obj["AppRole"] = $appRoleTable[$principal.appRoleId]
        $obj["Assignment"] = if ($member) { 
            "Group ($($principal.principalDisplayName))" 
        
        } else {
            "Direct Assignment"
        }
        return [pscustomobject]$obj
    }
}
class GraphAppRoleTable {
    # This class is used to store the AppRole information from the Graph API
    hidden [System.Collections.IDictionary]$table

    # Constructor
    GraphAppRoleTable([array]$roles) {
        $this.table = @{}
        $this.table["00000000-0000-0000-0000-000000000000"] = "Default Access"
        $this.AddRoles($roles)
    
    }

    # Add roles to the table
    hidden [void]AddRoles([array]$roles) {
        foreach ($role in $roles) {
            $this.table[$role.id] = $role
        }
    }

    # Get the role name from the id
    [System.Collections.IDictionary]GetTable() {
        return $this.table
    
    }
}
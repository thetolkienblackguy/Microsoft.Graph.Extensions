class GraphLicenseGroupObject {
    static [object]Create([object]$g, [string]$skuId, [hashtable]$sku_table) {
        $obj = [ordered]@{}
        $obj["DisplayName"] = $g.DisplayName
        $obj["GroupId"] = $g.Id
        $obj["SkuId"] = $skuId -join ", "
        $obj["SkuPartNumber"] = $sku_table[$skuId].SkuPartNumber
        <#$obj["OnPremisesSyncEnabled"] = $g.OnPremisesSyncEnabled
        $obj["OnPremisesNetBiosName"] = $g.OnPremisesNetBiosName
        $obj["OnPremisesSID"] = $g.OnPremisesSecurityIdentifier
        $obj["OnPremisesDomainName"] = $g.OnPremisesDomainName#>
        return [pscustomobject]$obj

    }
}
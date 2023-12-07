class UTCDateTime {
    # Class to convert a datetime object to UTC and return it in the format required by the Graph API
    hidden [datetime]$_date
    utcdatetime([datetime]$date) {
        $this._date = $date.ToUniversalTime()
    
    }
    static [utcdatetime]Parse([string]$date) {
        return [utcdatetime]::new([datetime]::Parse($date))
    
    }
    [string] ToString() {
        return $this._date.ToString("o")
    
    }
}
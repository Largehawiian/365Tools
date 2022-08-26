class MailboxStatistics {
    [string]$DisplayName
    [PSCustomObject]$TotalItemSizeInGB
    hidden[array]$InputObject

    MailboxStatistics ([string]$DisplayName, $TotalItemSizeInGB) {
        $this.DisplayName = $DisplayName 
        $this.TotalItemSizeInGB =  [math]::Round(($TotalItemSizeInGB / 1GB),2) 
    }

    static [MailboxStatistics]MailboxReport([PSObject]$InputObject) {
        return [MailboxStatistics]::new($InputObject.DisplayName, $InputObject.TotalItemSize)
    }
}
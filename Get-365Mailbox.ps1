function Get-365Mailbox {
    param (
        [CmdletBinding()]
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $True)]
            [string]$PrimarySMTPAddress,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $True)]
            [string]$ProhibitSendReceiveQuota,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $True)]
            [string]$DisplayName,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $True)]
            [bool]$IsShared,
        [Parameter(ValueFromPipelineByPropertyName, Mandatory = $True)]
            [bool]$IsDirSynced
    )
    begin {
        class UserInfo {
            [string]$DisplayName
            [string]$EmailAddress
            [string]$MailboxSize
            [string]$MaxMailboxSize
            [bool]$SharedMB
            [datetime]$LastUserAction
            [bool]$DirectorySynced


            UserInfo () {}

            UserInfo ($DisplayName, $EmailAddress, $Mailboxsize, $MaxMailboxSize, $SharedMB, $LastUserAction, $DirectorySynced) {
                $this.DisplayName = $DisplayName
                $this.EmailAddress = $EmailAddress
                $this.MailboxSize = $Mailboxsize.ToString().Split("(")[0]
                $this.MaxMailboxSize = $MaxMailboxSize.ToString().Split("(")[0]
                $this.SharedMB = $SharedMB
                $this.LastUserAction = $LastUserAction
                $this.DirectorySynced = $DirectorySynced
            }
            static [UserInfo]MailboxReport ($DisplayName, $EmailAddress, $MailboxSize, $MaxMailboxSize, $SharedMB, $LastUserAction, $DirectorySynced) {
                try {
                    $MBStats = Get-Mailbox $EmailAddress | Get-MailboxStatistics
                    if (!$MBStats.LastUserActionTime){ $MBStats.LastUserActionTime = [datetime]::new(1970,1,1)}
                }
                catch {
                    $MBStats = [PSCustomObject]@{
                        TotalItemSize = "No Data"
                        LastUserActionTime = [datetime]::new(1970,1,1)
                    }
                }
                return [UserInfo]::New($DisplayName, $EmailAddress, $MBStats.TotalItemSize, $MaxMailboxSize, $SharedMB, $MBStats.LastUserActionTime, $DirectorySynced)
            }
        }
    }
    process {
        if (!$PrimarySMTPAddress) { continue }
        [UserInfo]::MailboxReport($DisplayName, $PrimarySMTPAddress, "", $ProhibitSendReceiveQuota, $IsShared, $LastUserActionTime, $IsDirSynced) |
        Select-Object @{L = "Display Name"; E = { $_.DisplayName } }, @{L = "Email Address"; E = { $_.EmailAddress } }, @{L= "Mailbox Size"; E={$_.MailboxSize}},
        @{L = "Prohibit Send At"; E = { $_.ProhibitSendReceiveQuota } }, @{L = "Shared Mailbox"; E = { $_.SharedMB } }, @{L = "Last User Action"; E = { $_.LastUserAction } },
        @{L = "Directory Synced"; E = { $_.DirectorySynced }}
    }
}

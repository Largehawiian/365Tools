<#
.SYNOPSIS
    Compares previous mailbox size with current mailbox size and returns the difference.
.DESCRIPTION
    Compares previous mailbox size with current mailbox size and returns the difference.
.NOTES
    
.LINK
    
.EXAMPLE
    $MailboxSize = Get-Mailbox | Get-MailboxStatistics | Get-MailboxSize
    ... Make Changes such as enabling autoarchiving ...
    Compare-MailboxSize $MailboxSize
#>
function Compare-MailboxSize {
    param (
        [Array]$InputObject
    )
    $CurrentMailboxSize = Get-Mailbox | Get-MailboxStatistics | Get-MailboxReport
    $CurrentMailboxIndex = $CurrentMailboxSize | Group-Object DisplayName -AsHashTable -AsString
    
    foreach ($i in $InputObject) {
        [PSCustomObject]@{
            DisplayName  = $i.DisplayName
            PreviousSize = $i.TotalItemSizeInGB
            CurrentSize  = $CurrentMailboxIndex[$i.DisplayName].TotalItemSizeInGB
            Difference   = [math]::Round($i.TotalItemSizeInGB - $CurrentMailboxIndex[$i.DisplayName].TotalItemSizeInGB, 2)
        }
    }
    
}
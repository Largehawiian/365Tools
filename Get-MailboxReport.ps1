using namespace System.Collections.Generic
<#
.SYNOPSIS
    Lists mailboxes used space
.DESCRIPTION
    Takes Pipine input from Get-Mailbox | Get-MailboxStatistics and outputs a list of mailboxes and their used space.
.NOTES
    
.LINK
    https://github.com/Largehawiian/365Tools
.EXAMPLE
    Returns mailbox name and space used in GB
    Get-Mailbox Bob | Get-MailboxStatistics | Get-MailboxReport
    
#>
function Get-MailboxReport {
    [CmdletBinding()]
    param(
        [parameter(ValueFromPipeline)][Object[]]$InputObject
    )
    begin {
        $return = [List[PSCustomObject]]::New()
    }
    process {
        foreach ($i in $InputObject) {
            $Output = [PSCustomObject]@{
                DisplayName = $i.DisplayName
                TotalItemSize = $i.TotalItemSize -replace '.+\(|\sbytes.+|,' -as [int64]
            }
            $return.Add([MailboxStatistics]::MailboxReport($Output))
        }
        
    }
    end {
        return $return
    }
}
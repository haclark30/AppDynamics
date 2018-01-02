<#
.SYNOPSIS
    Gets all business transaction details for a an application
.DESCRIPTION
    Gets all business transaction details for a an application.
.EXAMPLE
    PS C:\> Get-AppDBTs -AppId 6

    Returns business transaction information for Application 6
.EXAMPLE
    PS C:\> Get-AppDBTs -AppName 'MyApp'

    Returns business transaction information for MyApp
#>
function Get-AppDBTs {
    [CmdletBinding()]
    param(
        # Application ID.
        [Parameter(Mandatory=$false,ValueFromPipeline)]
        $AppId,

        # Use the name of the application if you do not know the AppId. Less efficient than using the ID
        [Parameter(Mandatory=$false)]
        $AppName
    )
    Begin
    {
        Write-AppDLog "$($MyInvocation.MyCommand)"

        $connectionInfo = New-AppDConnection
    }
    Process
    {
        # Get AppId if it is missing
        if (!$AppId -and $AppName) {
            $AppId = (Get-AppDApplication -AppName $AppName).Id
        }
        elseif (-not $AppId -and -not $AppName)
        {
            $AppId = (Get-AppDApplication).Id
        }

        foreach ($id in $AppId) {
            (Get-AppDResource -uri "controller/api/accounts/$($connectionInfo.accountId)/applications/$id/businesstransactions" -connectionInfo $connectionInfo).bts
        }
    }
}
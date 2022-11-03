function Test-ProductCampaign {
    [cmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $Campaigns
    )

    $response = @{
        Results = @()
    }

    $Campaigns | ForEach-Object {

        $status = @{
            Status = $false
            Messages = @()
        }


        if (Test-ValidKey $_.Id) {
            $status.Messages += 'Invalid Campaign'
        }

        if ($status.Messages.length -lt 1) {
            $status.Status = $true
        }
   }

   $response
}
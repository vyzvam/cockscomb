function Test-ProductPrices {
    [cmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $Prices
    )

    $response = @{
        Results = @()
    }

    $Prices | ForEach-Object {

        $status = @{
            Status = $false
            Messages = @()
        }


        if (Test-ValidKey $_.Key) {
            $status.Messages += 'Unrecognized price type'
        }
        if (Test-ValidValue $_.Value) {
            $status.Messages += 'Invalid price'
        }
        if (Test-ValidPriceRange $_.Value) {
            $status.Messages += 'Price must be inbetween 1 to 1,000,000,00.00'
        }

        if ($status.Messages.length -lt 1) {
            $status.Status = $true
        }
   }

   $response
}
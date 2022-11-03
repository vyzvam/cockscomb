function Test-ProductStock {
    [cmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [int]$Stock
    )

    $response = @{
        Status = $false
        Messages = @()
    }

    if (Test-ValidValue $stock) {
        $response.Messages += 'Invalid stock value'
    }
    if (Test-InvlidStockRange $stock) {
        $response.Message += 'Price must be inbetween 1 to 100,000,000,00.00'
    }

    if ($response.Messages.length -lt 1) {
        $response.Status = $true
    }
    $response
}
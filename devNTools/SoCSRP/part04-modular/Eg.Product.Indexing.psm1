function Invoke-NewProductIndex {
    [cmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $Product
    )

    try {

        $searchContext = Get-SearchEngine
        New-ProductIndex $Product, $productPrice $searchContext
        $response = 'Your product is being validated, you will be notified once it is available'
        $response
    }
    catch {
        Throw 'unable to index the product'
    }
}
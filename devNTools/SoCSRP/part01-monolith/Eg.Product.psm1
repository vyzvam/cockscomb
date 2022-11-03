function Invoke-ProductCreate {
    [cmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String]$Name,
        [Parameter(Mandatory = $true)]
        [String]$Description,
        [Parameter(Mandatory = $true)]
        $Images,
        [Parameter(Mandatory = $true)]
        $Prices,
        [Parameter(Mandatory = $true)]
        [Int]$Stock,
        [Parameter(Mandatory = $true)]
        $Campaigns
    )


    if (Test-IsIvalidLength $Name) {
        Throw 'Name length must be inbetween 10 to 100'
    }
    if (Test-HasInvalidContent $Name) {
        Throw 'Name contains invalid values'
    }

    if (Test-IsIvalidLength $Description) {
        Throw 'Description length must be inbetween 10 to 100'
    }
    if (Test-HasInvalidContent $Description) {
        Throw 'Description contains invalid values'
    }

    $Images | ForEach-Object {

        if (Test-ExceedSize $_) {
            Throw 'Image exceeds size limit'
        }

        if (Test-ImageFormat $_) {
            Throw 'Image is in unsupported format'
        }
    }

    $Prices | ForEach-Object {

        if (Test-ValidKey $_.Key) {
            Throw 'Unrecognized price type'
        }
        if (Test-ValidValue $_.Value) {
            Throw 'Invalid price'
        }
        if (Test-ValidPriceRange $_.Value) {
            Throw 'Price must be inbetween 1 to 1,000,000,00.00'
        }
    }

    if (Test-ValidValue $stock) {
        Throw 'Invalid stock value'
    }
    if (Test-InvlidStockRange $stock) {
        Throw 'Price must be inbetween 1 to 100,000,000,00.00'
    }

    $Campaigns | ForEach-Object {

        if (Test-ValidKey $_.Id) {
            Throw 'Invalid Campaign'
        }
    }


    $dbContext = Get-DbContext();

    $product = New-Product $Name $Description $dbContext


    $Prices | ForEach-Object {

        New-ProductPrice $product.Id $_ $dbContext
    }

    New-ProductStock $product.Id $Stock $dbContext

    $Images | ForEach-Object {

        New-Image $product.Id $_ $dbContext
        New-ImageForSearch $product.Id $_ $dbContext
        New-ImageForThumb $product.Id $_ $dbContext

    }

    $Campaigns | ForEach-Object {

        New-ProductCampaign $product.Id $_ $dbContext
    }


    $searchContext = Get-SearchEngine

    $indexStatus =  New-ProductIndex $product, $productPrice $searchContext

    $response = 'Your product is being validated, you will be notified once it is available'

    $response
}
function New-Product {
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

    try {

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

        $response = 'Product created.'

        $response

    }
    catch {
        Throw 'An error'
    }
}
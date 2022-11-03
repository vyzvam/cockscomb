Import-Module -Name 'Eg.Product.Validation.psm1' -Verbose -Force
Import-Module -Name 'Eg.Product.Create.psm1' -Verbose -Force
Import-Module -Name 'Eg.Product.Indexing.psm1' -Verbose -Force

function Invoke-NewProduct {
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

        $productParam = @{
            Name = $Name
            Description = $Description
            Images = $Images
            Prices = $Prices
            Stock = $Stock
            Campaigns = $Campaigns
        }

        Test-Product @productParam
        $product = New-Product $productParam
        Invoke-NewProductIndex -Product $product

        $true
    }
    catch {
        throw $_
    }
}

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
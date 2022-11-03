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
function Test-Product {
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

    $product = Test-ProductDetail -Name $Name -Description $Description
    $image = Test-ProductImage -Images $Images
    $prices = Test-ProductPricese -Stock $Stock
    $stock = Test-ProductStock -Stock $Stock
    $campaign = Test-ProductCampaign -Campaigns $Campaigns

    $summary = Build-ValidationSummary $product $image $prices $stock $campaign
    if ($summary.HasErrors) {
        Throw $summary.Details
    }
}
function Test-ProductDetail {
    [cmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [String]$Name,
        [Parameter(Mandatory = $true)]
        [String]$Description
    )

    $response = @{
        Status = $false
        Messages = @()
    }

    if (Test-IsIvalidLength $Name) {
        $response.Messages += 'Name length must be inbetween 10 to 100'
    }
    if (Test-HasInvalidContent $Name) {
        $response.Messages += 'Name contains invalid values'
    }

    if (Test-IsIvalidLength $Description) {
        $response.Messages += 'Description length must be inbetween 10 to 100'
    }
    if (Test-HasInvalidContent $Description) {
        $response.Messages += 'Description contains invalid values'
    }

    if ($response.Messages.length -lt 1) {
        $response.Status = $true
    }
    $response
}

function Test-ProductImage {
    [cmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        $Images
    )

    $response = @{
        Results = @()
    }

    $Images | ForEach-Object {

        $status = @{
            Status = $false
            Messages = @()
        }


        if (Test-ExceedSize $_) {
            $status.Messages += 'Image exceeds size limit'
        }

        if (Test-ImageFormat $_) {
            $status.Messages += 'Image is in unsupported format'
        }

        if ($status.Messages.length -lt 1) {
            $status.Status = $true
        }

        $response.Results += $status
    }
    $response
}

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
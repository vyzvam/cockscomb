Import-Module -Name 'Eg.Validation.Product.Details.psm1' -Verbose -Force
Import-Module -Name 'Eg.Validation.Product.Images.psm1' -Verbose -Force
Import-Module -Name 'Eg.Validation.Product.Prices.psm1' -Verbose -Force
Import-Module -Name 'Eg.Validation.Product.Stock.psm1' -Verbose -Force
Import-Module -Name 'Eg.Validation.Product.Campaigns.psm1' -Verbose -Force

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
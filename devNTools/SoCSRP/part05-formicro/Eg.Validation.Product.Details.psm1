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
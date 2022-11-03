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
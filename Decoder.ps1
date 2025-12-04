function Decode-PNG {
    param (
            [Parameter(Mandatory=$true, ValueFromPipeline=$true)] [string]$ImagePath
        )
    function ConvertTo-Hex {
        param([String]$TextToConvert)
        $hexBytes = $TextToConvert | Format-Hex | Select-Object -ExpandProperty Bytes
        $rawHexString = ($hexBytes | ForEach-Object { '{0:x2}' -f $_ }) -join ''
        $rawHexString
    }

    function ConvertFrom-Hex {
        param (
            [Parameter(Mandatory=$true, ValueFromPipeline=$true)] [string]$HexString
        )
        if ($HexString.Length % 2 -ne 0) {
            Write-Error "Hex string must have an even number of characters."
            return
        }
        $byteArray = New-Object byte[] ($HexString.Length / 2)
        for ($i = 0; $i -lt $HexString.Length; $i += 2) {
            $hexPair = $HexString.Substring($i, 2)
            $byteArray[$i / 2] = [Convert]::ToByte($hexPair, 16)
        }
        [System.Text.Encoding]::UTF8.GetString($byteArray)
    }


    Add-Type -AssemblyName System.Drawing
    $bitmap = New-Object System.Drawing.Bitmap($imagePath)
    $width = $bitmap.Width
    $height = $bitmap.Height
    $TotalPixels = $width*$height

    #Create an array that includes pixel data for the entire image
    $PixelData=@()
    for ($x = 0; $x -lt $bitmap.Width; $x++) {
        for ($y = 0; $y -lt $bitmap.Height; $y++) {
            if ($x -lt 200 -and $y -lt 50) {
                $currentPixelData = $bitmap.GetPixel($x, $y)
                $Pixel = [PSCustomObject]@{
                        X               = $x
                        Y               = $Y
                        R               = $currentPixelData.R
                        G               = $currentPixelData.G
                        B               = $currentPixelData.B
                        A               = $currentPixelData.A
                        IsKnownColor    = $currentPixelData.IsKnownColor
                        IsEmpty         = $currentPixelData.IsEmpty
                        IsNamedColor    = $currentPixelData.IsNamedColor
                        Name            = $currentPixelData.Name
                }
                $PixelData += $Pixel
            }        
        }    
    }

    $ToCheck = $PixelData | Where-Object {$_.A -lt 255}
    $Charray = @("N","0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f")
    $HexFound = @()
    $i=0
    foreach($pixel in $ToCheck){
        if($i % 2 -eq 0){
            $ADif = (255 - $pixel.A) -1
            $ADifNext = (255 - $tocheck[$i+1].A) -1
            $ADifCombined = "$ADif"+"$ADifNext"
            $AdifHex = $charray[$ADifCombined]
            $HexFound += $AdifHex
        }
        $i=$i+1
    }

    $HexConverted = $HexFound  -join ""  | ConvertFrom-Hex
    write-host $HexConverted
    $bitmap.Dispose()
 }

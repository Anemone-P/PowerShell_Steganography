function Encode-PNG {
        param (
            [Parameter(Mandatory=$true, ValueFromPipeline=$False)] [string]$ImagePath,
            [Parameter(Mandatory=$true, ValueFromPipeline=$False)] [string]$TextToEncode
        )
 function ConvertTo-Hex {
        param([String]$TextToConvert)
        $hexBytes = $TextToConvert | Format-Hex | Select-Object -ExpandProperty Bytes
        $rawHexString = ($hexBytes | ForEach-Object { '{0:x2}' -f $_ }) -join ''
        #$rawHexString
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

$TextAsHex = (ConvertTo-Hex $TextToEncode) -split "" | Where-Object {$_ -ine ""}
$Charray = @("N","0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f")

$TextNumEncoded = @()
foreach($char in $TextAsHex){
   $index = ([Array]::IndexOf($Charray, $char))
   write-host $index
   $digitCount = ($index | Out-String).Trim().Length
   if($digitCount-eq 1){$index = "0"+$index}
   $TextNumEncoded += $index

}

$ToEncode = $TextNumEncoded -split ""  | Where-Object {$_ -ine ""}

Add-Type -AssemblyName System.Drawing
    $bitmap = New-Object System.Drawing.Bitmap($imagePath)
    $width = $bitmap.Width
    $height = $bitmap.Height
    $TotalPixels = $width*$height

# Check if Pixel format is 32bit
# If not 32bit, create a new bitmap that is
# 32bit is require to store ARGB data
if($bitmap.PixelFormat -ine "Format32bppArgb"){
    $newPixelFormat = [System.Drawing.Imaging.PixelFormat]::Format32bppArgb
    $newPNG = New-Object System.Drawing.Bitmap($bitmap.Width, $bitmap.Height, $newPixelFormat)
    $PNGCreate = [System.Drawing.Graphics]::FromImage($newPNG)
    $PNGCreate.DrawImage($bitmap, 0, 0, $bitmap.Width, $bitmap.Height)
    $bitmap = $newPNG
    $width = $bitmap.Width
    $height = $bitmap.Height
    $TotalPixels = $width*$height

}
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
foreach($pixel in $pixeldata){$pixel.A = 255}

$i = 0
foreach($num in $ToEncode){
    $pixeltoChange = $PixelData[$i]
    $newColor = [System.Drawing.Color]::FromArgb(($pixeltoChange.A - $num -1),$pixeltoChange.R, $pixeltoChange.G, $pixeltoChange.B)
    $bitmap.SetPixel($pixeltoChange.X, $pixeltoChange.Y, $newColor)
$i = $i+1
}
$imagepath2 = $imagepath -replace ".png","_2.png"
$bitmap.Save($ImagePath2)
$bitmap.Dispose()

}

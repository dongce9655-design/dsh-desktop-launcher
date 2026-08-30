# Generate a simple original whale icon for the launcher (dark rounded square
# + geometric whale silhouette). Output: dsh-launcher.ico (256px PNG-compressed).
Add-Type -AssemblyName System.Drawing

$size = 256
$bmp = New-Object System.Drawing.Bitmap($size, $size)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.Clear([System.Drawing.Color]::Transparent)

# Dark rounded-rectangle background
$bg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 27, 30, 39))
$radius = 56
$path = New-Object System.Drawing.Drawing2D.GraphicsPath
$d = $radius * 2
$path.AddArc(0, 0, $d, $d, 180, 90)
$path.AddArc($size - $d, 0, $d, $d, 270, 90)
$path.AddArc($size - $d, $size - $d, $d, $d, 0, 90)
$path.AddArc(0, $size - $d, $d, $d, 90, 90)
$path.CloseFigure()
$g.FillPath($bg, $path)

# Whale silhouette: body ellipse + tail + fin + eye
$fg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 242, 243, 245))
$g.FillEllipse($fg, 44, 84, 150, 88)                          # body
$tail = [System.Drawing.Point[]]@(
    (New-Object System.Drawing.Point(186, 92)),
    (New-Object System.Drawing.Point(228, 128)),
    (New-Object System.Drawing.Point(186, 164))
)
$g.FillPolygon($fg, $tail)                                    # tail
$g.FillEllipse($fg, 92, 120, 44, 30)                          # fin
$eyeBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 27, 30, 39))
$g.FillEllipse($eyeBg, 70, 112, 12, 12)                       # eye

$g.Dispose()
$pngPath = Join-Path $PSScriptRoot 'dsh-launcher.png'
$icoPath = Join-Path $PSScriptRoot 'dsh-launcher.ico'
$bmp.Save($pngPath, [System.Drawing.Imaging.ImageFormat]::Png)

# Wrap the PNG in an ICO container (PNG-compressed 256x256 entry)
$pngBytes = [System.IO.File]::ReadAllBytes($pngPath)
$ms = New-Object System.IO.MemoryStream
$bw = New-Object System.IO.BinaryWriter($ms)
$bw.Write([byte]0); $bw.Write([byte]0)          # reserved
$bw.Write([byte]1); $bw.Write([byte]0)          # type: icon
$bw.Write([byte]1); $bw.Write([byte]0)          # count: 1
$bw.Write([byte]0)                              # width 256
$bw.Write([byte]0)                              # height 256
$bw.Write([byte]0)                              # palette
$bw.Write([byte]0)                              # reserved
$bw.Write([uint16]1)                            # planes
$bw.Write([uint16]32)                           # bpp
$bw.Write([uint32]$pngBytes.Length)             # size
$bw.Write([uint32]22)                           # offset
$bw.Write($pngBytes)
$bw.Flush()
[System.IO.File]::WriteAllBytes($icoPath, $ms.ToArray())
$bw.Dispose(); $ms.Dispose(); $bmp.Dispose()

Write-Host "Generated $icoPath ($([System.IO.File]::ReadAllBytes($icoPath).Length) bytes)"

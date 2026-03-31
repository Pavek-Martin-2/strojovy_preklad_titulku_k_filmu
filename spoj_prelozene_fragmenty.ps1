cls

<# 
program spoji fragmenty rozdelenych prelozenych souboru titulku opet v jeden celek
zavineno limitem poctu radku ktere zle zpracovat najednou pomoci Google prekladace :(
#>

$adresar_fragmenty = "prelozit_fragmenty"
$cekej = 5

# test existence adreasre "prelozit_fragmenty"
$fileExist = Test-Path $adresar_fragmenty
if ($fileExist -clike "False") {
Write-Warning "nanalezen soubor $adresar_fragmenty"
Write-Warning "spust napred program_A.ps1"
sleep 5
exit 1
}

$pole_file_list_fragmenty = @()
$pole_file_list_fragmenty += Get-ChildItem -Path $adresar_fragmenty -Include "*.txt" -Name
$d_pole_file_list_fragmenty = $pole_file_list_fragmenty.Length

# test existence obsahu v adresari "prelozit_fragmenty"
if ( $d_pole_file_list_fragmenty -eq 0 ){
Write-Warning "adresar $adresar_fragmenty neobsahuje zadne soubory fragmentu"
Write-Warning "spust napred program_A.ps1"
sleep 5
exit 1
}

Write-Host -ForegroundColor Cyan "v adrasari $adresar_fragmenty byly nalezeno(y) celkem $d_pole_file_list_fragmenty"
#sleep $cekej

$pole_spojene_fragmenty = @()

for ( $aa = 0; $aa -le $d_pole_file_list_fragmenty -1; $aa++ ) {
#echo $pole_file_list_fragmenty[$aa]
$file = ""
$file += $adresar_fragmenty
$file += "\"
$file += $pole_file_list_fragmenty[$aa]

# nacte vsechny soubory fragmentu a ulozi je do spolecneho pole
Write-Host -ForegroundColor Yellow "nacitam soubor $file"
sleep $cekej

$stream_reader = [System.IO.StreamReader]::new($file)

while (-not $stream_reader.EndOfStream) {
$line_read = [string]($stream_reader.ReadLine())
echo $line_read
$pole_spojene_fragmenty += $line_read
}

$stream_reader.close()
}

$d_pole_spojene_fragmenty = $pole_spojene_fragmenty.Length
Write-Host -ForegroundColor Yellow "celkem bylo ze vsech souboru fragmentu nacteno $d_pole_spojene_fragmenty radku titulku"

# ulozeni spojenych fragmentu do jednoho souboru
$file_spojene = "prelozene.txt"

Set-Content -Path $file_spojene -Encoding Unicode -Value $pole_spojene_fragmenty
# duleziti je tady Unicode ( diakritika ), takze ne Ascii
Write-Host -ForegroundColor Cyan "vsechno ulozeno do souboru $file_spojene"
sleep 10


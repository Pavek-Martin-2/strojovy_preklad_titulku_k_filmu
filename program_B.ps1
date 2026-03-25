cls

# sestavni prelozene titulky ze souboru "prelozene.txt"
$cekej = 5

# nacte soubor *puvodni.txt" coz je vlastne soubor "titulky.srt" jenom prejmenovany a zmenena pripona
# tak aby se vnem dalo dobre cist napr. pomoci poznamkoeho bloku apod. ktery si z priponou *.srt nerozumi
$file_titulky = "puvodni.txt" # titulky.srt.txt klidne dve pripony jako na Linuxu
$fileExist = Test-Path $file_titulky
if ($fileExist -clike "False") {
Write-Warning "nanalezen soubor $file_titulky"
sleep 5
exit 1
}

<# 
nacte soubor "prelozene.txt", coz je prelozeny soubor "prelozit.txt" pomoci napr. Google translatoru
"prelozit.txt" bude obsahovat cizojazycni tytulky a "prelozene.txt" bude obsahovat preklad do cestiny
je dulezite aby oba souboru meli stejny pocet radku, toto program take kontrolouje a paklize tam je rozdil
tak s epredcasne ukonci
#>
$file_prelozene = "prelozene.txt"
$fileExist_2 = Test-Path $file_prelozene
if ($fileExist_2 -clike "False") {
Write-Warning "nanalezen soubor $file_prelozene"
sleep 5
exit 1
}

$pole_casy = @()

# nacte soubor $file_titulky a vybere znej pouze casy od --> do
Write-Host -ForegroundColor Cyan "nactu soubor $file_titulky a vyberu znej pomoci regulerniho vyrazu pouze radky obsahujici casovy usek"
sleep $cekej
$stream_reader = [System.IO.StreamReader]::new($file_titulky)
while (-not $stream_reader.EndOfStream) {
$line_read = [string]($stream_reader.ReadLine())
#echo $line_read

# regularni vyraz pro rozpoznani casove znacky od --> do ( ma vzdy delku prave 29 znaku )
if (($line_read.Length -eq 29) -and ($line_read -match '^\d{2}:\d{2}:\d{2},\d{3}\s-->\s\d{2}:\d{2}:\d{2},\d{3}$')) {
echo $line_read
$pole_casy += $line_read
}

}
$stream_reader.close()

$d_pole_casy = $pole_casy.Length
Write-Host -ForegroundColor Cyan "bylo nacteno $d_pole_casy casovych useku ze souboru $file_titulky"
Write-Host -ForegroundColor Yellow "ted nactu soubor obsah souboru z prekladem $file_prelozene"
sleep $cekej

# nacte cely soubor $file_prelozene
$pole_prelozene_titulky = @()

$stream_reader_2 = [System.IO.StreamReader]::new($file_prelozene)
while (-not $stream_reader_2.EndOfStream) {
$line_read_2 = [string]($stream_reader_2.ReadLine())
echo $line_read_2
$pole_prelozene_titulky += $line_read_2
}

$stream_reader_2.close()

$d_pole_prelozene_titulky = $pole_prelozene_titulky.Length
#echo "pocet casovy useku  = $d_pole_casy"
Write-Host -ForegroundColor Yellow "bylo nacteno $d_pole_prelozene_titulky radku prelozeny titulku z souboru $file_prelozene"

# porovnani poctu radku obou nactenych souboru na shodu
if ( $d_pole_casy -ne $d_pole_prelozene_titulky ){
Write-Warning "chyba, soubory $file_titulky a $file_prelozene maji rozdilny pocet radku"
sleep 5
exit 1
}


# vnitrni struktura souboru titulku *.srt
<#
1
00:00:09,130 --> 00:00:14,550
[музыка]

2
00:00:13,740 --> 00:00:31,759
[аплодисменты]

3
00:00:14,550 --> 00:00:33,590
[музыка]

4
atd.
#>

# setaveni konecneho vystupniho souboru prellozenych titulku
$file_prelozene_titulky = "prelozene_titulky.txt" # prelozene_titulky.srt.txt
Write-Host -ForegroundColor Cyan "nyni sestavim vystupni soubor prelozenych titulku $file_prelozene_titulky "
sleep $cekej

$pole_final_output = @()
$pocitadlo_soubor_srt = 1

for ( $aa = 0; $aa -le $d_pole_casy -1; $aa++ ) {
$pole_final_output += [string] $pocitadlo_soubor_srt
$pocitadlo_soubor_srt++

$pole_final_output += $pole_casy[$aa]
$pole_final_output += $pole_prelozene_titulky[$aa]
$pole_final_output += ""
}

$pole_final_output += "" # pridan dole jeden radek navic, jako u puvodniho souboru
echo $pole_final_output

# ulozeni finalnich titulku do souboru
Set-Content -Path $file_prelozene_titulky -Encoding Unicode -Value $pole_final_output
# duleziti je tady Unicode ( diakritika ), takze ne Ascii
Write-Host -ForegroundColor Cyan "toto ulozeno do souboru $file_prelozene_titulky"
sleep 10


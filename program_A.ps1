cls

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


#$file_linux_dvd = "Авария – дочь мента 1989.txt"
$file_titulky = "puvodni.txt" # puvodni_cizojazycne_titulky.srt.txt
$fileExist = Test-Path $file_titulky
if ($fileExist -clike "False") {
Write-Warning "nanalezen soubor $file_titulky"
sleep 5
exit 1
}

$pole_soubor = @()
$pole_puvodni_zneni = @()
$cekej = 5

# nacte soubor $file_titulky do $pole_soubor
Write-Host -ForegroundColor Cyan "nactu soubor $file_titulky a vyberu znej pouze radky ktere obsahuji text titulku"
sleep $cekej
$stream_reader = [System.IO.StreamReader]::new($file_titulky)
while (-not $stream_reader.EndOfStream) {
$line_read = [string]($stream_reader.ReadLine())
#echo $line_read
$pole_soubor += $line_read
}

$stream_reader.close()

$d_pole_soubor = $pole_soubor.Length
#echo "radku = $d_pole_soubor"

for ( $aa = 0; $aa -le $d_pole_soubor; $aa++ ) {
# regularni vyraz pro rozpoznani casove znacky od --> do ( ma vzdy delku prave 29 znaku )
if (( $pole_soubor[$aa].Length -eq 29 ) -and ( $pole_soubor[$aa] -match '^\d{2}:\d{2}:\d{2},\d{3}\s-->\s\d{2}:\d{2}:\d{2},\d{3}$' )) {
echo $pole_soubor[$aa+1]
$pole_puvodni_zneni += $pole_soubor[$aa+1] # za radkem casoveho useku je vzdy radek titulku tzn. index pole [n+1]
}

}

$d_pole_puvodni_zneni = $pole_puvodni_zneni.Length

Write-Host -ForegroundColor Cyan "bylo nacteno $d_pole_puvodni_zneni radku titulku ze souboru $file_titulky"

$file_prelozit = "prelozit.txt"
Remove-Item $file_prelozit -ErrorAction SilentlyContinue
sleep 1

Set-Content -Path $file_prelozit -Encoding unicode -Value $pole_puvodni_zneni
sleep 1

Write-Host -ForegroundColor yellow "vse ulozeno do souboru $file_prelozit"
Write-Host -ForegroundColor cyan "soubor $file_prelozit bude nyni jeste rozdelen na nekolik fragmentu podle nasledujici tabulky :"
sleep (($cekej -2))


# ulozeni obsahu doi vice souboru pro Google Translator ( omezeny pocet znaku ) vzato ze souboru "modulo_7.ps1"
##############################################################################################################################
$rozdel_po = 200 # kolik bude radku z "preloz.txt" v kazdem souboru po rozdeleni pro Google Translator (omezeny pocet znaku)
#$rozdel_po = 867 # myslelo se na vsechno
##############################################################################################################################

#$celkem = $d_pole_puvodni_zneni # toto nechat jak je
$zbytek_po_deleni = 0 # celociselny zbytek po deleni, prozatim nastaven na nula

$fragmentu_1 = $d_pole_puvodni_zneni / $rozdel_po
#echo $fragmentu_1

$fragmentu_2 = [Math]::Floor($fragmentu_1) # zaokrouhli dolu (Floor)
# vzdycky zaokrouhlovat dolu a by byl zbytek po deleni desetineho cisla
# [Math]::Round($variable) toto by bylo pripadne bylo zaokrouhleni nahoru (Round)
#echo $fragmentu_2

if ( $fragmentu_1 -eq $fragmentu_2 ) { # paklize je stejne tak neni desetine cislo a tim padem ani zbytek po deleni
#echo "NENI zbytek po deleni "
} else {
# nene stejne a je zbytek po deleni pouzij jsete modulo pro zjisteni celociselneho zbytku radku
#echo "JE zbytek po deleni"
$zbytek_po_deleni = $d_pole_puvodni_zneni % $rozdel_po # modulo, puvodne nastaveno na hodnotu nula, zde se pripadne prepise jinym cislem
}

Write-Host -ForegroundColor yellow "celkovy pocet radku : $d_pole_puvodni_zneni"
Write-Host -ForegroundColor yellow "zvoleny pocet radku v jednom fragmentu : $rozdel_po"
Write-Host -ForegroundColor yellow "rozdelit na fragmentu : $fragmentu_2"
#echo (( $rozdel_po * $fragmentu_2 )) # kontrola

if ($zbytek_po_deleni -ne 0 ) { # myslelo se na vsechno
$fragmentu_2b = $fragmentu_2
$fragmentu_2b++
Write-Host -ForegroundColor yellow "zbyle radky : $zbytek_po_deleni ( fragment $fragmentu_2b )"
}

sleep $cekej

$poc_1 = 0
$prefix_fragmentu = 1

$adresar_fragmenty = "prelozit_fragmenty"
Remove-Item -Path $adresar_fragmenty -Recurse -Force -ErrorAction SilentlyContinue
sleep 1
$null = New-Item -Path $adresar_fragmenty -ItemType Directory -Force
sleep 1

for ( $bb = 1; $bb -le $fragmentu_2; $bb++ ) {

$pole_out = @()

for ( $cc = 1; $cc -le $rozdel_po; $cc++ ) {
#echo $cc
$pole_out += $pole_puvodni_zneni[$poc_1]
echo $pole_puvodni_zneni[$poc_1]
$poc_1++ # toto bude index $pole_titulky
}
Write-Host -ForegroundColor Yellow "------------------------- fragment $prefix_fragmentu" # zde zapsat pole fragmentu           
$nazev_fragmetu = $adresar_fragmenty + "\"
$nazev_fragmetu += [string] $prefix_fragmentu
$nazev_fragmetu += ".txt"

Set-Content -Path $nazev_fragmetu -Encoding unicode -Value $pole_out
$prefix_fragmentu++ # inkrementovat prefix nazvu fragmentu
sleep 1
}

if ( $zbytek_po_deleni -ne 0 ) { # toto jeste paklize bude nejaky zbytek po deleni
#echo "zde jeste zbytek  $zbytek_po_deleni"
$pole_out = @()

for ( $dd = $poc_1; $dd -le $d_pole_puvodni_zneni; $dd++) {
$pole_out += $pole_puvodni_zneni[$dd]
echo $pole_puvodni_zneni[$dd]

}
# zapis souboru "zbytku"
$nazev_fragmetu = $adresar_fragmenty + "\"
$nazev_fragmetu += [string] $prefix_fragmentu
$nazev_fragmetu += ".txt"

Set-Content -Path $nazev_fragmetu -Encoding unicode -Value $pole_out
Write-Host -ForegroundColor Yellow "------------------------- fragment $prefix_fragmentu"
sleep 1
}

if ($zbytek_po_deleni -ne 0 ) { # myslelo se na vsechno
Write-Host -ForegroundColor Cyan "do adresare $adresar_fragmenty\ byly ulozeny soubory 1.txt - $fragmentu_2b.txt"
}else{
Write-Host -ForegroundColor Cyan "do adresare $adresar_fragmenty\ byly ulozeny soubory 1.txt" 
}

sleep $cekej



#
# Скрипт скачивает последнюю версию flash player и размещает её в папке указаннов 
# в переменной $distr_folder
# Distr folder for flash player files
$distr_folder = "D:\Share\FlashPlayer\"

$urls = @()
$releases = 'http://fpdownload2.macromedia.com/get/flashplayer/update/current/xml/version_en_win_pl.xml'


$XML = New-Object  System.Xml.XmlDocument
$XML.load($releases)
$version = $XML.XML.update.version.replace(',', '.')
$major_version = ([version]$version).Major

$WebClient = New-Object System.Net.WebClient
$urls += "https://download.macromedia.com/get/flashplayer/pdc/${version}/install_flash_player_${major_version}_plugin.msi"
$WebClient.DownloadFile($urls[0],"${distr_folder}\install_flash_player_${major_version}_plugin.msi")
$urls += "https://download.macromedia.com/pub/flashplayer/pdc/${version}/install_flash_player_${major_Version}_active_x.msi"
$WebClient.DownloadFile($urls[1],"${distr_folder}\install_flash_player_${major_Version}_active_x.msi")
    
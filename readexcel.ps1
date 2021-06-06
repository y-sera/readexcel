﻿# 日報一括閲覧マクロ
# シェルスクリプト実行ポリシーについての記事
#https://www.atmarkit.co.jp/ait/articles/0805/16/news139.html
#

#日報の一覧を変数へ格納
$ReportList=dir -NAME | Select-String "^[0-9]{6}.*\.xlsx$" |sort

# 日付の取得
$month=Get-Date -Format MM | % { $_ -replace "^0", ""}
$day=Get-Date -Format dd| % { $_ -replace "^0", ""}
$weekday=Get-Date -Format ddd


#新規COMオブジェクト作成
	$excel = New-Object -ComObject Excel.Application
	#ウィンドウ起動しない
	$excel.Visible = $False
	#読み取り専用警告オフ
	$excel.DisplayAlerts = $False

# 一行ずつ処理する
foreach( $LINE in $ReportList ){
    #ファイルフルパスの取得
    $filepath=(get-item $LINE).DirectoryName
	

	Clear-Host
	#ブックの指定
	$workbook = $excel.Workbooks.Open($filepath+"\"+$LINE)
	#シート名
	$sheetname=$month +"月" +$day +"日"
	
    #シートを指定
    #今日の日付の分が無ければ一枚目のシートを指定
	try{
        $worksheet = $workbook.Sheets($sheetname)
    } catch{
	echo "※このファイルは, シート名が今日の日付ではありません"
        $worksheet = $excel.worksheets.Item(1)
    }

	##テスト用コード
	echo "名前:" $worksheet.Range("C2").Text 
	echo ""
    echo "今日の目標:" 	
	echo $worksheet.Range("B3").Text 
		

	#echo "名前:" $sheet.Range("Q4").Text 
	#echo "今日の目標:" 
	#echo $worksheet.Range("B7").Text 
	#echo
	#echo "目標達成に向けた行動:"
	#echo $worksheet.Range("B9").Text 
	#echo 
	#echo "学んだこと: "
	#echo $worksheet.Range("B11").Text 
	#echo 
	#echo "今後の課題:"
	#echo $worksheet.Range("B7").Text 
	#echo
	#echo "所感:"
	#echo $worksheet.Range("B26").Text

	# キー入力待ち　
	#参考url https://pig-log.com/powershell-input-pause/
	Write-Host "処理を継続する場合は何かキーを押してください．．．" -NoNewLine
	[Console]::ReadKey($true) > $null
	$workbook.Close()
    Clear-Host
}
$excel.Quit()

echo "読み込みを終了しました"
echo "オブジェクトの解放を行います"

#変数の破棄
#COMオブジェクトの解放の参考URL
# https://www.relief.jp/docs/powershell-save-excel-file.html
#
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($worksheet)
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook)
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel)

echo "enterキーを押してください"

#やらないといけないこと: フルパスの取得(コマンドプロンプト)
#日付による分岐(金曜日ならプラス2日)
#シートの作成
#オブジェクトの解放チェック
#文字コードの変更

# $newsheet=$tomrrowmonth + "月" + $tomorrowday + "日"
# シートHOGE1をコピーする
#$workbook.Worksheets.item($sheetname).copy($workbook.Worksheets.item($newsheet))
#月から木なら日付の数+1したシートを, 金曜日なら+3した日付のシートをコピーして作成
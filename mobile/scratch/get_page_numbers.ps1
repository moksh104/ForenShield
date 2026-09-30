$docPath = 'C:\Projects\ForenShield\mobile\ForenShield_Final_Project_Report.docx'
$word = New-Object -ComObject Word.Application
$word.Visible = $false
try {
    $doc = $word.Documents.Open($docPath)
    foreach ($p in $doc.Paragraphs) {
        $txt = $p.Range.Text.Trim()
        if ($txt -match '^(CHAPTER [1-7]|REFERENCES|1\.[1-4]|2\.[1-4]|3\.[1-7]|5\.[1-5]|6\.[1-3])') {
            $page = $p.Range.Information(3)
            Write-Host "$page`t$txt"
        }
    }
    $doc.Close([ref]$false)
} finally {
    $word.Quit()
}

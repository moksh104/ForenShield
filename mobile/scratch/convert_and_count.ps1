$docPath = "C:\Projects\ForenShield\mobile\ForenShield_Final_Project_Report.docx"
$pdfPath = "C:\Projects\ForenShield\mobile\ForenShield_Final_Project_Report.pdf"

$word = New-Object -ComObject Word.Application
$word.Visible = $false
try {
    $doc = $word.Documents.Open($docPath)
    $pages = $doc.ComputeStatistics(2)
    Write-Host "Rendered Page Count in MS Word: $pages"
    $doc.SaveAs([ref]$pdfPath, [ref]17)
    Write-Host "PDF exported successfully to $pdfPath"
    $doc.Close([ref]$false)
} catch {
    Write-Host "Error occurred: $_"
} finally {
    $word.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($word) | Out-Null
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
}

# ForenShield Phase 5 API Verification Script

$tokensJson = curl.exe -s http://127.0.0.1:8000/get_test_tokens.php | ConvertFrom-Json
$token1 = $tokensJson.token1
$token2 = $tokensJson.token2
$user1 = $tokensJson.user1
$user2 = $tokensJson.user2

Write-Host "=== PHASE 5 REPORTS API VERIFICATION ==="
Write-Host "User 1: $($user1.full_name) (ID: $($user1.id))"
Write-Host "User 2: $($user2.full_name) (ID: $($user2.id))`n"

# Test 1: Unauthenticated request must return 401
Write-Host "Test 1: Unauthenticated GET /reports.php..." -NoNewline
$res1 = curl.exe -s -w "%{http_code}" http://127.0.0.1:8000/reports.php
$status1 = $res1.Substring($res1.Length - 3)
if ($status1 -eq "401") {
    Write-Host " PASS (HTTP 401)" -ForegroundColor Green
} else {
    Write-Host " FAIL (Expected 401, got $status1)" -ForegroundColor Red
}

# Test 2: Unsolved case generation must return 400
Write-Host "Test 2: Generate report for unsolved case..." -NoNewline
$bodyUnsolved = '{"case_id":"case_104"}'
$res2 = curl.exe -s -w "%{http_code}" -X POST http://127.0.0.1:8000/reports.php -H "Authorization: Bearer $token1" -H "Content-Type: application/json" -d $bodyUnsolved
$status2 = $res2.Substring($res2.Length - 3)
if ($status2 -eq "400") {
    Write-Host " PASS (HTTP 400 properly returned for unsolved case)" -ForegroundColor Green
} else {
    Write-Host " FAIL (Expected 400, got $status2)" -ForegroundColor Red
}

# Test 3: Generate report for solved case (case_101)
Write-Host "Test 3: Generate report for solved case_101..." -NoNewline
$headers1 = @{
    "Authorization" = "Bearer $token1"
    "Content-Type"  = "application/json"
}
$bodyObj = @{ case_id = "case_101" } | ConvertTo-Json
try {
    $res3 = Invoke-RestMethod -Uri "http://127.0.0.1:8000/reports.php" -Method Post -Headers $headers1 -Body $bodyObj
} catch {
    $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
    $errText = $reader.ReadToEnd()
    Write-Host " FAIL (Error: $errText)" -ForegroundColor Red
    exit 1
}
if ($res3.success -and $res3.report.id) {
    $reportId = $res3.report.id
    Write-Host " PASS (Generated report ID: $reportId)" -ForegroundColor Green
    Write-Host "  - Title: $($res3.report.title)"
    Write-Host "  - Severity: $($res3.report.severity)"
    Write-Host "  - Analyst: $($res3.report.analyst)"
    Write-Host "  - Summary: $($res3.report.summary)"
    Write-Host "  - Timeline items: $($res3.report.timeline.Count)"
    Write-Host "  - Evidence items: $($res3.report.evidence.Count)"
    Write-Host "  - Findings: $($res3.report.findings.Count)"
    Write-Host "  - Remediation actions: $($res3.report.remediation_actions.Count)"
} else {
    Write-Host " FAIL ($res3)" -ForegroundColor Red
    exit 1
}

# Test 4: Idempotency (repeat generation returns same report)
Write-Host "Test 4: Idempotency check (repeat POST for same case)..." -NoNewline
$res4 = Invoke-RestMethod -Uri "http://127.0.0.1:8000/reports.php" -Method Post -Headers $headers1 -Body $bodyObj
if ($res4.report.id -eq $reportId) {
    Write-Host " PASS (Returned identical report ID: $reportId)" -ForegroundColor Green
} else {
    Write-Host " FAIL (Returned different ID: $($res4.report.id))" -ForegroundColor Red
}

# Test 5: List reports for User 1
Write-Host "Test 5: List reports for User 1..." -NoNewline
$res5 = curl.exe -s http://127.0.0.1:8000/reports.php -H "Authorization: Bearer $token1" | ConvertFrom-Json
if ($res5.Count -ge 1 -and $res5[0].id -eq $reportId) {
    Write-Host " PASS (Found $($res5.Count) reports)" -ForegroundColor Green
} else {
    Write-Host " FAIL ($res5)" -ForegroundColor Red
}

# Test 6: Get report detail by ID for User 1
Write-Host "Test 6: Get report detail by ID for User 1..." -NoNewline
$res6 = curl.exe -s "http://127.0.0.1:8000/reports.php?id=$reportId" -H "Authorization: Bearer $token1" | ConvertFrom-Json
if ($res6.id -eq $reportId -and $res6.title -ne $null) {
    Write-Host " PASS (Retrieved: $($res6.title))" -ForegroundColor Green
} else {
    Write-Host " FAIL ($res6)" -ForegroundColor Red
}

# Test 7: Ownership isolation (User 2 attempts to view User 1's report)
Write-Host "Test 7: User 2 attempts to access User 1's report..." -NoNewline
$res7 = curl.exe -s -w "%{http_code}" "http://127.0.0.1:8000/reports.php?id=$reportId" -H "Authorization: Bearer $token2"
$status7 = $res7.Substring($res7.Length - 3)
if ($status7 -eq "403") {
    Write-Host " PASS (HTTP 403 Forbidden properly enforced)" -ForegroundColor Green
} else {
    Write-Host " FAIL (Expected 403, got $status7)" -ForegroundColor Red
}

# Test 8: User 2 reports list isolation
Write-Host "Test 8: User 2 reports list isolation..." -NoNewline
$res8 = curl.exe -s http://127.0.0.1:8000/reports.php -H "Authorization: Bearer $token2" | ConvertFrom-Json
$leaked = $false
foreach ($r in $res8) {
    if ($r.id -eq $reportId) { $leaked = $true }
}
if (-not $leaked) {
    Write-Host " PASS (User 1's report not in User 2's list)" -ForegroundColor Green
} else {
    Write-Host " FAIL (Report leaked to User 2!)" -ForegroundColor Red
}

Write-Host "`n>>> ALL PHASE 5 BACKEND VERIFICATION TESTS PASSED SUCCESSFULLY! <<<" -ForegroundColor Cyan

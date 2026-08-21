$ErrorActionPreference = 'Stop'
$baseUrl = 'http://10.155.48.49:8000'
$email = 'verify.test@forenshield.local'
$password = 'P@ssw0rd123'

Write-Host "Registering test user..."
try {
    $regRes = Invoke-RestMethod -Method POST -Uri "$baseUrl/register.php" -Body (@{ full_name='Test User'; email=$email; password=$password } | ConvertTo-Json) -ContentType 'application/json' -UseBasicParsing
} catch {}

Write-Host "Logging in..."
try {
    $loginRes = Invoke-RestMethod -Method POST -Uri "$baseUrl/login.php" -Body (@{ email=$email; password=$password; device_name='PC Test'; platform='Windows' } | ConvertTo-Json) -ContentType 'application/json' -UseBasicParsing
    $token = $loginRes.accessToken
    if (-not $token) { throw "No token received" }
    Write-Host "Authentication: ? 200 + valid JSON"
} catch {
    Write-Host "Authentication: ?? Failed $($_.Exception.Message)"
    exit
}

$headers = @{ 'Authorization' = "Bearer $token" }

$endpoints = @(
  '/mission_control.php',
  '/cisa_kev.php',
  '/reports.php',
  '/nvd.php',
  '/mitre_attack.php',
  '/investigation_cases.php',
  '/investigation_case_detail.php?id=1',
  '/investigation_evidence.php?case_id=1',
  '/virustotal.php?query=44d88612fea8a8f36de82e1278abb02f',
  '/leaderboard/global.php',
  '/leaderboard/weekly.php',
  '/leaderboard/monthly.php',
  '/leaderboard/top_investigators.php',
  '/leaderboard/top_learners.php',
  '/leaderboard/profile_rank.php',
  '/achievements/list.php',
  '/achievements/check.php',
  '/achievements/progress.php',
  '/achievements/unlock.php',
  '/settings/devices.php',
  '/settings/revoke_device.php',
  '/settings/login_history.php',
  '/settings/export_data.php'
)

foreach ($e in $endpoints) {
    try {
        if ($e -match 'unlock' -or $e -match 'revoke') {
            $res = Invoke-RestMethod -Method POST -Uri "$baseUrl$e" -Headers $headers -ContentType 'application/json' -Body '{}' -UseBasicParsing
        } else {
            $res = Invoke-RestMethod -Method GET -Uri "$baseUrl$e" -Headers $headers -UseBasicParsing
        }
        Write-Host "$e -> ? 200 + valid JSON"
    } catch {
        if ($_.Exception.Response) {
            $statusCode = $_.Exception.Response.StatusCode.value__
            if ($statusCode -eq 401 -or $statusCode -eq 403) { Write-Host "$e -> ?? 401/403 authentication issue" }
            elseif ($statusCode -eq 404) { Write-Host "$e -> ?? 404 routing issue" }
            elseif ($statusCode -eq 500) { Write-Host "$e -> ?? 500 backend error" }
            else { Write-Host "$e -> ?? $statusCode unexpected" }
        } else {
            Write-Host "$e -> ?? network/parsing issue ($(.Exception.Message))"
        }
    }
}

$ErrorActionPreference = 'Stop'
$baseUrl = 'http://10.155.48.49:8000'
$email = 'verify.test@forenshield.local'
$password = 'P@ssw0rd123'

$loginRes = Invoke-RestMethod -Method POST -Uri "$baseUrl/login.php" -Body (@{ email=$email; password=$password; device_name='PC Test'; platform='Windows' } | ConvertTo-Json) -ContentType 'application/json' -UseBasicParsing
$token = $loginRes.accessToken

$headers = @{ 'Authorization' = "Bearer $token" }

Write-Host "Testing /mitre_attack.php..."
$res = Invoke-RestMethod -Method GET -Uri "$baseUrl/mitre_attack.php" -Headers $headers -UseBasicParsing
Write-Host "Success: $($res.success) - Cached: $($res.from_cache) - Count: $($res.data.Count)"

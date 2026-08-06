function Test-ApiEndpoint {
    param(
        [string]$Method,
        [string]$Url,
        [hashtable]$Body = @{}
    )

    Write-Host "Testing $Method $Url"
    try {
        $response = Invoke-RestMethod -Method $Method -Uri $Url -Body ($Body | ConvertTo-Json -Depth 5) -ContentType 'application/json' -UseBasicParsing
        Write-Host "Response:" -ForegroundColor Green
        $response | ConvertTo-Json -Depth 5 | Write-Host
    } catch {
        Write-Host "ERROR:" -ForegroundColor Red
        $_.Exception.Message
        if ($_.Exception.Response) {
            $body = $_.Exception.Response.GetResponseStream() | ForEach-Object { $_ | Get-Content -Raw }
            Write-Host $body
        }
    }
    Write-Host "`n"
}

$baseUrl = 'http://127.0.0.1:8000'

Test-ApiEndpoint -Method 'POST' -Url "$baseUrl/register.php" -Body @{ full_name = 'Agent Test'; email = 'agent.test@forenshield.local'; password = 'P@ssw0rd123' }
Test-ApiEndpoint -Method 'POST' -Url "$baseUrl/login.php" -Body @{ email = 'agent.test@forenshield.local'; password = 'P@ssw0rd123' }
Test-ApiEndpoint -Method 'POST' -Url "$baseUrl/verify_otp.php" -Body @{ email = 'agent.test@forenshield.local'; otp_code = '000000' }
Test-ApiEndpoint -Method 'POST' -Url "$baseUrl/refresh_token.php" -Body @{ refreshToken = 'replace_with_refresh_token' }
Test-ApiEndpoint -Method 'POST' -Url "$baseUrl/logout.php" -Body @{ refreshToken = 'replace_with_refresh_token' }
Test-ApiEndpoint -Method 'POST' -Url "$baseUrl/forgot_password.php" -Body @{ email = 'agent.test@forenshield.local' }

Write-Host 'NOTE: Replace refreshToken values in refresh_token.php and logout.php tests before running.' -ForegroundColor Yellow

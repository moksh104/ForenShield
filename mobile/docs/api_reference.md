# ForenShield API Reference

The ForenShield Backend is a stateless PHP application that uses JWT for authentication and outputs JSON.

## Base URL
`https://your-domain.com/api`

## Authentication
All protected endpoints require an `Authorization` header:
`Authorization: Bearer <JWT_ACCESS_TOKEN>`

## Endpoints

### Authentication
- `POST /login.php`
  - Parameters: `email`, `password`, `device_name` (optional)
  - Returns: `{ "accessToken", "refreshToken", "user": { ... } }`
- `POST /register.php`
  - Parameters: `email`, `password`, `displayName`
  - Returns: `{ "accessToken", "refreshToken", "user": { ... } }`

### Live Intelligence
- `GET /nvd.php`
  - Parameters: `keyword`, `startIndex`, `resultsPerPage`
  - Returns: JSON mirroring NVD API
- `GET /virustotal.php`
  - Parameters: `hash`
  - Returns: VirusTotal analysis object
- `GET /cisa_kev.php`
  - Returns: CISA Known Exploited Vulnerabilities catalog
- `GET /mitre_attack.php`
  - Returns: MITRE ATT&CK tactics and techniques

### Account & Achievements
- `GET /current_user.php`
  - Returns: Profile data
- `GET /achievements/list.php`
  - Returns: List of available achievements
- `POST /achievements/unlock.php`
  - Parameters: `achievement_id`
- `GET /leaderboard/global.php`
  - Returns: Global player rankings by XP

### Error Handling
Errors are returned as JSON with appropriate HTTP status codes (400, 401, 500) and an `error` field.
Example:
```json
{
  "error": "Invalid credentials."
}
```

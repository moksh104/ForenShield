# Cloudinary Setup Guide

ForenShield uses Cloudinary for robust image hosting, particularly for user avatars and threat investigation reports.

## Prerequisites
- A Cloudinary account from [cloudinary.com](https://cloudinary.com).

## Configuration
1. Retrieve your Cloudinary `Cloud Name`, `API Key`, and `API Secret` from the Cloudinary Console Dashboard.
2. In the `api/config.php` file, update the constants:

```php
define('CLOUDINARY_CLOUD_NAME', 'your_cloud_name');
define('CLOUDINARY_API_KEY', 'your_api_key');
define('CLOUDINARY_API_SECRET', 'your_api_secret');
```

## Image Uploads
The Flutter application uses `ImagePicker` to select images and compresses them using `flutter_image_compress` before transmitting them to the `upload_image.php` endpoint. 

### Security & Validations
- **Size Limit**: Enforced to 5MB on the server.
- **MIME Type Validation**: Strictly checks for `image/jpeg` or `image/png`.
- **Extension Validation**: Strictly enforces `.jpg`, `.jpeg`, `.png`.

Images are uploaded to Cloudinary's secure folders via the Cloudinary PHP SDK in `upload_image.php`, which returns the secure delivery URL to be saved in PostgreSQL.

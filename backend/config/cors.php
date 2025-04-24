<?php
// backend/config/cors.php

return [
    'paths' => ['api/*', 'sanctum/csrf-cookie', 'stora  ge/*'],
    'allowed_methods' => ['*'],
    'allowed_origins' => ['*'], // Atau spesifik domain flutter Anda
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['*'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => false,
];
<?php

require_once 'config.php';

try {
    $query = $pdo->query('SELECT NOW()');
    $result = $query->fetch();

    echo "Neon connection established successfully.\n";
    print_r($result);

} catch (Exception $e) {
    die($e->getMessage());
}
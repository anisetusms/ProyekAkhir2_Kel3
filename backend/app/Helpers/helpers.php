<?php

if (!function_exists('format_currency')) {
    function format_currency($amount, $currency = 'IDR')
    {
        if ($currency === 'IDR') {
            return 'Rp ' . number_format($amount, 0, ',', '.');
        }
        
        return number_format($amount, 2);
    }
}
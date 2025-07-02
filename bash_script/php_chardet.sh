#!/usr/bin/env php
<?php
$filePath = $_SERVER['argv'][1] ?? "";
if (empty($filePath)) {
    echo "参数错误, 请输入文件路径" . PHP_EOL;
    exit(1);
}
if (strpos($filePath, '/') === 0) {
    $filePath = 'file://' . $filePath;
}
$fileContent = file_get_contents($filePath);
if ($fileContent === false) {
    $error = error_get_last();
    echo "无法下载文件 {$error['message']}: $filePath" . PHP_EOL;
    exit(1);
}
$encoding = mb_detect_encoding($fileContent, ['UTF-8', 'GB18030', 'GBK', 'ASCII', 'GB2312', 'CP936', 'ISO-8859-1', 'CP936', 'ASCII']);

if (empty($_SERVER['argv'][2])) {
    echo "文件编码: $encoding" . PHP_EOL;
} else if ($_SERVER['argv'][2] == 'show') {
    echo $fileContent;
} elseif ($_SERVER['argv'][2] == 'change') {
    $fileContent = iconv($encoding, 'utf-8//TRANSLIT//IGNORE', $fileContent);
    echo $fileContent;
}

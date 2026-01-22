#!/usr/bin/env php
<?php

// 1. 修复帮助判断（放在最前面）
if (($argv[1] ?? '') === 'help' || ($argv[1] ?? '') === '--help') {
    echo "用法: php_chardet.sh <文件路径> [show|to_utf8|to_gbk|to_gb18030|info|help]" . PHP_EOL;
    echo "参数说明:" . PHP_EOL;
    echo "  show          显示文件内容" . PHP_EOL;
    echo "  to_utf8       转换为 UTF-8 编码并显示" . PHP_EOL;
    echo "  to_gbk        转换为 GBK 编码并显示" . PHP_EOL;
    echo "  to_gb18030    转换为 GB18030 编码并显示" . PHP_EOL;
    echo "  info          显示文件详细信息" . PHP_EOL;
    echo "  help          显示此帮助信息" . PHP_EOL;
    exit(0);
}

$filePath = $argv[1] ?? "";

if (empty($filePath)) {
    fwrite(STDERR, "错误: 请输入文件路径" . PHP_EOL);
    exit(1);
}

// 2. 添加文件检查
if (!file_exists($filePath)) {
    fwrite(STDERR, "错误: 文件不存在: $filePath" . PHP_EOL);
    exit(1);
}

if (!is_readable($filePath)) {
    fwrite(STDERR, "错误: 文件不可读: $filePath" . PHP_EOL);
    exit(1);
}

// 3. 读取文件
$fileContent = @file_get_contents($filePath);
if ($fileContent === false) {
    $error = error_get_last();
    fwrite(STDERR, "错误: 无法读取文件: " . ($error['message'] ?? '未知错误') . PHP_EOL);
    exit(1);
}

// 4. 检测编码（添加严格模式）
$encoding = mb_detect_encoding($fileContent, ['UTF-8', 'GB18030', 'GBK', 'GB2312', 'BIG5', 'ISO-8859-1', 'ASCII'], true);
if ($encoding === false) {
    fwrite(STDERR, "错误: 无法检测文件编码（可能是二进制文件）" . PHP_EOL);
    exit(1);
}

$action = $argv[2] ?? 'info';

// 5. 执行操作
switch ($action) {        
    case 'show':
        echo $fileContent;
        break;
        
    case 'to_utf8':
        $result = @iconv($encoding, 'UTF-8//TRANSLIT//IGNORE', $fileContent);
        $result = @iconv($encoding, 'UTF-8//IGNORE', $fileContent);

        if ($result === false) {
            fwrite(STDERR, "错误: 编码转换失败: $encoding -> UTF-8" . PHP_EOL);
            exit(1);
        }
        echo $result;
        break;
        
    case 'to_gbk':
        $result = @iconv($encoding, 'GBK//IGNORE', $fileContent);
        if ($result === false) {
            fwrite(STDERR, "错误: 编码转换失败: $encoding -> GBK" . PHP_EOL);
            exit(1);
        }
        echo $result;
        break;
        
    case 'to_gb18030':
        $result = @iconv($encoding, 'GB18030//IGNORE', $fileContent);
        if ($result === false) {
            fwrite(STDERR, "错误: 编码转换失败: $encoding -> GB18030" . PHP_EOL);
            exit(1);
        }
        echo $result;
        break;
        
    case 'info':
        echo "文件信息:" . PHP_EOL;
        echo "  路径: $filePath" . PHP_EOL;
        echo "  大小: " . filesize($filePath) . " 字节" . PHP_EOL;
        echo "  编码: $encoding" . PHP_EOL;
        echo "  行数: " . (substr_count($fileContent, "\n") + 1) . PHP_EOL;
        break;
        
    default:
        fwrite(STDERR, "错误: 未知命令: $action" . PHP_EOL);
        echo "使用 help 查看帮助信息" . PHP_EOL;
        exit(1);
}
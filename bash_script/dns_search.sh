#!/bin/bash
#https://github.com/mr-karan/doggo

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored text
print_color() {
    local color=$1
    local text=$2
    echo -e "${color}${text}${NC}"
}

domain=$1
command='doggo --time --timeout=400ms'

print_color $YELLOW "办公网wifi @10.8.250.104"
$command "${domain}" @10.8.250.104
echo ""

print_color $YELLOW "测试wifi @10.8.250.225"
$command "${domain}" @10.8.250.225
echo ""

print_color $YELLOW "灰度wifi @10.8.250.226"
$command "${domain}" @10.8.250.226
echo ""

print_color $YELLOW "测试k8s @10.53.0.10"
$command "${domain}" @10.53.0.10
echo ""

print_color $YELLOW "灰度k8s @10.20.88.66"
$command "${domain}" @10.20.88.66
echo ""

print_color $YELLOW "线上k8s @10.189.0.10"
$command "${domain}" @10.189.0.10
echo ""

print_color $YELLOW "线上kvm @100.100.2.136"
$command "${domain}" @100.100.2.136
echo ""

print_color $YELLOW "谷歌 @8.8.8.8"
$command "${domain}" @8.8.8.8
echo ""

print_color $YELLOW "域名${domain} 当前解析为:"
ping -c1 -t1 "${domain}" | grep PING
curl -v --head --connect-timeout 1 "${domain}" 2>&1 | tee | grep Trying
echo ""


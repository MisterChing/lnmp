function FindProxyForURL(url, host) {

    if (dnsDomainIs(host, ".xxx.com") || host === "xxx.com") {
        return "DIRECT";
    }

    if (dnsDomainIs(host, ".xxx.com") || host === "xxx.com") {
        return "DIRECT";
    }

    if (dnsDomainIs(host, ".google.com") || host === "google.com") {
        return "DIRECT";
    }
    // 其他流量直连
    return "DIRECT";
}

function FindProxyForURL(url, host) {
      // 内网/公司域名直连
      if (dnsDomainIs(host, ".aaa.com") || host === "aaa.com") {
          return "DIRECT";
      }
      if (dnsDomainIs(host, ".bbb.com") || host === "bbb.com") {
          return "DIRECT";
      }

      // 其他全部走 Clash 代理，Clash 未启动时自动降级直连
      return "PROXY 127.0.0.1:7890; DIRECT";
  }

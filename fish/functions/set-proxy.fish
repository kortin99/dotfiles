function set-proxy
    set -gx http_proxy http://agent.baidu.com:8891
    set -gx https_proxy http://agent.baidu.com:8891
    set -gx no_proxy 192.168.0.0/16,10.0.0.0/8,172.16.0.0/12,127.0.0.1,localhost,.local,timestamp.apple.com,sequoia.apple.com,seed-sequoia.siri.apple.com,.ly.com,.elong.com,.17usoft.com,.17u.cn,.40017.cn,.tcent.cn,.hopegoo.com,.azgotrip.net,.elonghotel.com,.bigdata.com,.handhand.net,.tsinghua.edu.cn,baidu-int.com,baidu.com
end

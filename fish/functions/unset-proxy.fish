function unset-proxy
  set -e http_proxy
  set -e https_proxy
  set -e all_proxy
  set -e HTTP_PROXY
  set -e HTTPS_PROXY
  set -e ALL_PROXY
end

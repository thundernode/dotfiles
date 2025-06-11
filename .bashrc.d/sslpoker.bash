sslpoker () {
  local OPTIND fqdn ip ips port
  while getopts s:a:p:: flag
    do
        case "${flag}" in
            s)  fqdn=${OPTARG};;
            a)  ips=${OPTARG};;
            p)  port=${OPTARG};;
        esac
    done
  if [ -z "$fqdn" ]; then
    echo "You must specify an fqdn with -s"
    return 1
  fi
  if [ -z "$port" ]; then
    port="443"
  fi
  if [ -z "$ips" ]; then
    ips=$(dig +short $fqdn| sed '/.*\.$/d')
    if [ -z "$ips" ]; then
      echo "No IP address found for $fqdn, please specify with -a"
      return 1
    fi
  fi
  for ip in $ips; do
    local certinfo=$(timeout 3 openssl s_client -connect $ip:$port -servername $fqdn </dev/null 2>&1)
    if [ "$certinfo" == "" ] || [[ "$certinfo" =~ 'errno=' ]]; then
     echo "Failed to connect to $fqdn:$port ($ip) $certinfo"
     continue
    fi
    local cert_issuer=$(echo "$certinfo" | openssl x509 -noout -issuer| head -n 1 |awk -F 'CN = ' ' { print $2 } ')
    if [[ "$cert_issuer" =~ 'pssfw' ]] ; then
      echo "Connection to $fqdn:$port ($ip) intercepted by pssfw"
      continue
    fi
    local cert_date=$(echo "$certinfo" | openssl x509 -noout -enddate | head -n 1 |awk -F= ' /notAfter/ { printf("%s\n",$NF); } ')
    local expiry_seconds="$(date --date="$cert_date" +%s)"
    local expiry_date=$[($expiry_seconds- $(date +%s)) / 86400]
    local cert_san=$(echo "$certinfo" | openssl x509 -noout -text | sed -nr '/^ {12}X509v3 Subject Alternative Name/{n;s/^ *//p}')
    echo -e "
    IP:        $ip
    Covers:    $cert_san
    Expires:   $cert_date ($expiry_date days)
    Issued by: $cert_issuer
    "
  done
  }

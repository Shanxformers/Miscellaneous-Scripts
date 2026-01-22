#!/bin/bash

# Usage check
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <HOST> <PORT(S)>"
    echo "Example: $0 example.com 80,443,8080"
    exit 1
fi

HOST=$1
PORTS=$2
USER_AGENT="Mozilla/5.0 (KPMG)"
OUTPUT_DIR="${HOST}_nmap_results"
mkdir -p "$OUTPUT_DIR"

echo "[*] Scanning ports: $PORTS on host: $HOST"

# 1. Default service + script scan
echo "[*] Running scan-tcp-sV-sC..."
nmap -Pn -vv -sV -sC --script-args http.useragent="$USER_AGENT" -p "$PORTS" "$HOST" -oA "$OUTPUT_DIR/scan-tcp-sV-sC"

# 2. SSL cipher enumeration
echo "[*] Running ssl-enum-ciphers..."
nmap -Pn -vv --script ssl-enum-ciphers --script-args http.useragent="$USER_AGENT" -p "$PORTS" "$HOST" -oA "$OUTPUT_DIR/ssl-enum-ciphers"

# 3. SSL certificate info
echo "[*] Running ssl-cert..."
nmap -Pn -vv --script ssl-cert --script-args http.useragent="$USER_AGENT" -p "$PORTS" "$HOST" -oA "$OUTPUT_DIR/ssl-cert"

# 4. HTTP script scan
echo "[*] Running http-* and safe scripts..."
nmap -Pn -vv --script "http-* and safe" --script-args http.useragent="$USER_AGENT" -p "$PORTS" "$HOST" -oA "$OUTPUT_DIR/http-safe"

echo "[+] All scans completed. Results saved in $OUTPUT_DIR/"

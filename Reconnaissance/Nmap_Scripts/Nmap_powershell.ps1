# Define variables
$HOST = "target.com"
$PORTS = "80,443"
$USER_AGENT = "CustomUserAgent"
$OUTPUT_DIR = "C:\nmap_results"  # change as needed, can include spaces

# Normalize path safely (compatible with PowerShell 5.1)
try {
    $ResolvedPath = Resolve-Path -LiteralPath $OUTPUT_DIR -ErrorAction Stop
    $OUTPUT_DIR = $ResolvedPath.Path
} catch {
    # Path doesn't exist yet; keep as-is
}

# Ensure output directory exists (works with spaces)
if (!(Test-Path -Path "$OUTPUT_DIR")) {
    New-Item -ItemType Directory -Path "$OUTPUT_DIR" -Force | Out-Null
}

# 1. Default service + script scan
Write-Host "[*] Running scan-tcp-sV-sC..."
nmap -Pn -vv -sV -sC --script-args "http.useragent=$USER_AGENT" -p $PORTS $HOST -oA "$OUTPUT_DIR\scan-tcp-sV-sC"

# 2. SSL cipher enumeration
Write-Host "[*] Running ssl-enum-ciphers..."
nmap -Pn -vv --script ssl-enum-ciphers --script-args "http.useragent=$USER_AGENT" -p $PORTS $HOST -oA "$OUTPUT_DIR\ssl-enum-ciphers"

# 3. SSL certificate info
Write-Host "[*] Running ssl-cert..."
nmap -Pn -vv --script ssl-cert --script-args "http.useragent=$USER_AGENT" -p $PORTS $HOST -oA "$OUTPUT_DIR\ssl-cert"

# 4. HTTP script scan
Write-Host "[*] Running http-* and safe scripts..."
nmap -Pn -vv --script "http-* and safe" --script-args "http.useragent=$USER_AGENT" -p $PORTS $HOST -oA "$OUTPUT_DIR\http-safe"

Write-Host "[+] All scans completed. Results saved in $OUTPUT_DIR"

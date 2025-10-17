#!/bin/bash

# Usage check
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <URL>"
    echo "Example: $0 https://example.com"
    exit 1
fi

URL=$1

# --- Step-by-step URL cleanup ---
# 1. Remove protocol (http:// or https://)
TEMP_URL=$(echo "$URL" | sed -E 's#https?://##')

# 2. Remove trailing slash if present
TEMP_URL=$(echo "$TEMP_URL" | sed 's#/$##')

# 3. Remove everything after the first slash (to isolate domain only)
DOMAIN=$(echo "$TEMP_URL" | cut -d'/' -f1)

# 4. Replace dots in domain with underscores (for safe directory naming)
SAFE_DOMAIN=$(echo "$DOMAIN" | tr '.' '_')

# 5. Define output directory
OUTPUT_DIR="${SAFE_DOMAIN}_meta"
mkdir -p "$OUTPUT_DIR"

echo "[+] Output directory: $OUTPUT_DIR"
echo

# --- Fetch metafiles ---

echo "# 1. Robots.txt Output"
curl -s -o "$OUTPUT_DIR/robots.txt" "$URL/robots.txt" && head -n5 "$OUTPUT_DIR/robots.txt"

echo "# 2. Sitemap.xml Output"
wget --no-verbose -O "$OUTPUT_DIR/sitemap.xml" "$URL/sitemap.xml" && head -n8 "$OUTPUT_DIR/sitemap.xml"

echo "# 3. Well-known Security.txt Output"
wget --no-verbose -O "$OUTPUT_DIR/security-wellknown.txt" "$URL/.well-known/security.txt" && cat "$OUTPUT_DIR/security-wellknown.txt"

echo "# 4. Root Security.txt Output"
wget --no-verbose -O "$OUTPUT_DIR/security-root.txt" "$URL/security.txt" && cat "$OUTPUT_DIR/security-root.txt"

echo "# 5. Humans.txt Output"
wget --no-verbose -O "$OUTPUT_DIR/humans.txt" "$URL/humans.txt" && cat "$OUTPUT_DIR/humans.txt"

echo
echo "[+] All metafiles have been saved in $OUTPUT_DIR/"


#!/usr/bin/env bash
# nginx-log-analyzer.sh — Analyze Nginx access logs
# Usage: ./nginx-log-analyzer.sh <logfile>

set -euo pipefail

LOG_FILE="${1:-}"

if [[ -z "$LOG_FILE" ]]; then
    echo "Usage: $0 <logfile>" >&2
    exit 1
fi

if [[ ! -f "$LOG_FILE" ]]; then
    echo "Error: file '$LOG_FILE' not found." >&2
    exit 1
fi

TOP=5

# ──────────────────────────────────────────────
# 1. Top 5 IP addresses with the most requests
# ──────────────────────────────────────────────
echo "Top $TOP IP addresses with the most requests:"
awk '{print $1}' "$LOG_FILE" \
    | sort \
    | uniq -c \
    | sort -rn \
    | head -n "$TOP" \
    | awk '{printf "%s - %s requests\n", $2, $1}'

echo ""

# ──────────────────────────────────────────────
# 2. Top 5 most requested paths
# ──────────────────────────────────────────────
echo "Top $TOP most requested paths:"
awk '{print $7}' "$LOG_FILE" \
    | sort \
    | uniq -c \
    | sort -rn \
    | head -n "$TOP" \
    | awk '{printf "%s - %s requests\n", $2, $1}'

echo ""

# ──────────────────────────────────────────────
# 3. Top 5 response status codes
# ──────────────────────────────────────────────
echo "Top $TOP response status codes:"
awk '{print $9}' "$LOG_FILE" \
    | sort \
    | uniq -c \
    | sort -rn \
    | head -n "$TOP" \
    | awk '{printf "%s - %s requests\n", $2, $1}'

echo ""

# ──────────────────────────────────────────────
# 4. Top 5 user agents
# ──────────────────────────────────────────────
echo "Top $TOP user agents:"
# The user agent spans from the last quoted field; extract it with awk
# Combined Log Format: field 12 onward until end of line (between the last pair of quotes)
awk -F'"' '{print $6}' "$LOG_FILE" \
    | sort \
    | uniq -c \
    | sort -rn \
    | head -n "$TOP" \
    | awk '{
        count = $1
        $1 = ""
        sub(/^ /, "")
        printf "%s - %s requests\n", $0, count
    }'

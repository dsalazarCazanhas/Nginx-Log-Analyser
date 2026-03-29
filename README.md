# Nginx-Log-Analyser

Shell script to analyze Nginx access logs from the command line. Parses the **Combined Log Format** and reports the top 5 results for:

- IP addresses with the most requests
- Most requested paths
- Response status codes
- User agents

## Usage

```bash
chmod +x nginx-log-analyzer.sh
./nginx-log-analyzer.sh /var/log/nginx/access.log
```

## Log format expected

Standard Nginx Combined Log Format:

```
IP - - [date] "METHOD /path HTTP/1.1" status size "referrer" "user-agent"
```

## Tools used

`awk` · `sort` · `uniq` · `head`

---
> A journey to grow up from [Roadmap.sh](https://roadmap.sh/projects/nginx-log-analyser)
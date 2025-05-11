#!/bin/bash
 # Author: [Yehia Tarek Selim ](https://github.com/cyberwire666)
LOG_FILE="access.log"  
# 1. Request Counts
total_requests=$(wc -l < "$LOG_FILE")
get_requests=$(grep '"GET' "$LOG_FILE" | wc -l)
post_requests=$(grep '"POST' "$LOG_FILE" | wc -l)

# 2. Unique IP Addresses
unique_ips=$(awk '{print $1}' "$LOG_FILE" | sort | uniq)
unique_ip_count=$(echo "$unique_ips" | wc -l)

# Count GET/POST per IP
echo "GET/POST requests per unique IP:"
for ip in $unique_ips; do
  ip_get=$(grep "^$ip " "$LOG_FILE" | grep '"GET' | wc -l)
  ip_post=$(grep "^$ip " "$LOG_FILE" | grep '"POST' | wc -l)
  echo "$ip - GET: $ip_get, POST: $ip_post"
done

# 3. Failure Requests
failures=$(awk '$9 ~ /^[45]/ {count++} END {print count}' "$LOG_FILE")
fail_percent=$(awk -v f="$failures" -v t="$total_requests" 'BEGIN {printf "%.2f", (f/t)*100}')

# 4. Top User
top_user=$(awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -1)

# 5. Daily Request Averages
days=$(awk -F'[:[]' '{print $2}' "$LOG_FILE" | cut -d: -f1 | sort | uniq | wc -l)
daily_avg=$(awk -v t="$total_requests" -v d="$days" 'BEGIN {printf "%.2f", t/d}')

# 6. Failure Analysis by Day
echo "Failure requests per day:"
awk '$9 ~ /^[45]/ {split($4, d, ":"); gsub("\\[", "", d[1]); fail[d[1]]++} END {for (i in fail) print i, fail[i]}' "$LOG_FILE" | sort

# Request by Hour
echo "Requests per hour:"
awk -F'[:[]' '{print $2":"$3}' "$LOG_FILE" | sort | uniq -c | sort -k2

# Status Code Breakdown
echo "Status code breakdown:"
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr

# Most Active User by Method
top_get_ip=$(grep '"GET' "$LOG_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr | head -1)
top_post_ip=$(grep '"POST' "$LOG_FILE" | awk '{print $1}' | sort | uniq -c | sort -nr | head -1)

# Patterns in Failure Requests
echo "Failures by hour:"
awk '$9 ~ /^[45]/ {split($4, d, ":"); print d[2]}' "$LOG_FILE" | sort | uniq -c | sort -nr

# Final Output
echo ""
echo "-------------------- Summary --------------------"
echo "Total Requests: $total_requests"
echo "GET Requests: $get_requests"
echo "POST Requests: $post_requests"
echo "Unique IPs: $unique_ip_count"
echo "Failed Requests: $failures ($fail_percent%)"
echo "Top User: $top_user"
echo "Daily Request Average: $daily_avg"
echo "Top GET IP: $top_get_ip"
echo "Top POST IP: $top_post_ip"

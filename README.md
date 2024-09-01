```bash
#                              _     
#    ___  ___ __ _ _ __    ___| |__  
#   / __|/ __/ _` | '_ \  / __| '_ \ 
#   \__ \ (_| (_| | | | |_\__ \ | | |
#   |___/\___\__,_|_| |_(_)___/_| |_|
#                                    
# 
```
# scan.sh - NMAP Vulnerability scan script
## SCANNING FOR SERVER VULNERABILITIES VIA DOMAIN-NAME

Features:
- scan domainname
- use .txt list
- output as TXT or XML
- run with CI (non-interactive)

## Usage

    ./scan.sh [OPTIONS]

### Environment Variables

- `NOINTERACTION=true`: Disables interaction during script execution.
- `OUTPUT_FORMAT=[xml/txt]`: Sets the output file format.

### Options

- `-h | --help`: Show this help message.
- `-d | --domain`: Specify a domain or IP address to scan.
- `-f | --file`: Specify a file containing domains or IP addresses to scan.

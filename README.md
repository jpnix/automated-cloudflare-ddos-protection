This script uses the cloudflare API and services as well as AWS CLI for snp messaging. 
It is ran as cron job that checks the status of the website every 5 minutes and detects potential DDoS attacks by querying number of connection requests and initiating cloudflares 'im under attack' service. 

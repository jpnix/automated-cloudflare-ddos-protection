#!/bin/bash

TRAFFIC_COUNT=$(netstat -an | grep :443 | wc -l)
TODAYS_DATE=$(TZ=EST date)

#Activates 'Under Attack' firewall option inside CloudFlare via API
CLOUDFLARE_ATTACK_MODE()
{
  $(curl -sX PATCH "https://api.cloudflare.com/client/v4/zones/<redacted>/settings/security_level" -H "X-Auth-Email: email@email.com" -H "X-Auth-Key: <redacted>" -H "Content-Type: application/json" --data '{"value":"under_attack"}')
}

#Sends alert to sysadmins via AWS SNS message describing connection count and incident date/time
SEND_SNS_MESSAGE()
{
  /usr/bin/aws sns publish --topic-arn "arn:aws:sns:us-east-1:<redacted>:Amazon_Alerts" --message "Website being hit with $TRAFFIC_COUNT connections: Activating cloudflare attack mode! $TODAYS_DATE"
}

if [ "$TRAFFIC_COUNT" -ge 400 ]; then
  CLOUDFLARE_ATTACK_MODE
  SEND_SNS_MESSAGE
  sleep 20s
  service httpd restart
else
        exit
fi

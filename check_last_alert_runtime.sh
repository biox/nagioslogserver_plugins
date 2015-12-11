#!/bin/bash
# This plugin can be used to check the last alert runtime from the Nagios Log Server subsystem. By default, it checks the last alert runtime against the current time - if the difference is greater than 300 seconds, it's critical.

latestalerttime=$(curl -s -XGET 'localhost:9200/nagioslogserver_log/_search?q=type:alert' -d '{
  "query": {
    "match_all": {}
  },
  "size": 1,
  "sort": [
    {
      "created": {
        "order": "desc"
      }
    }
  ]
}' | cut -d":" -f17 | cut -d"," -f1 | cut -c 1-10)

currenttime=$(date +%s)

echo $latestalerttime
echo $currenttime

#diff current time vs last alert runtime
diff=$(($currenttime - $latestalerttime))
echo $diff
if [ $diff -gt 300 ]; then
        exit 2
else
        exit 0
fi

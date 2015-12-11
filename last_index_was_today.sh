#!/bin/bash
# This script is used to ensure that the most recent index generated is equal to todays date. Using this plugin will help make you aware of any soft crashes that may have prevented indices from being generated in the future.


year=$(date --rfc-3339=date | cut -d'-' -f1)
month=$(date --rfc-3339=date | cut -d'-' -f2)
day=$(date --rfc-3339=date | cut -d'-' -f3)

mostrecentindex=$(curl -s -XGET "localhost:9200/logstash-$year.$month.$day/_search?" -d '{
  "query": {
    "match_all": {}
  },
  "size": 1,
  "sort": [
    {
      "@timestamp": {
        "order": "desc"
      }
    }
  ]
}' | awk 'gsub(/.*_index|\",.*/,"")' | cut -d\" -f3)

today="logstash-$year.$month.$day"

if [ "$mostrecentindex" == "$today" ]
        then
        exit 0
        else
        exit 2
fi

#!/bin/bash

# Retrieve ALB DNS Name
ALB_DNS_NAME=$(kubectl get ingress "myhelmapp" -n dev -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}')

# Create DNS Record in Route 53
aws route53 change-resource-record-sets --hosted-zone-id Z09515952I4RH0I9XMIZX --change-batch '{
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "test.pandora.com",
        "Type": "CNAME",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "'"$ALB_DNS_NAME"'"
          }
        ]
      }
    }
  ]
}'

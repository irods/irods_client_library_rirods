#!/bin/sh

# token
SECRETS=$(echo -n rods:rods | base64)
TOKEN=$(curl -X POST -H "Authorization: Basic ${SECRETS}" http://localhost/irods-rest/0.9.3/auth)

# create user bobby
curl -X POST -H "Authorization: ${TOKEN}" 'http://localhost/irods-rest/0.9.3/admin?action=add&target=user&arg2=bobby&arg3=rodsuser&arg4=&arg5=&arg6=&arg7=' -o /dev/null

# list to show result
curl -X GET -H "Authorization: ${TOKEN}" 'http://localhost/irods-rest/0.9.3/list?logical-path=%2FtempZone%2Fhome&stat=0&permissions=0&metadata=0&offset=0&limit=100'  | jq

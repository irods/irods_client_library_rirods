#!/bin/sh

# token
SECRETS=$(echo -n rods:rods | base64)
TOKEN=$(curl -X POST -H "Authorization: Basic ${SECRETS}" http://localhost:80/irods-rest/0.9.2/auth)

# create user bobby
curl -X POST -H "Authorization: ${TOKEN}" 'http://localhost/irods-rest/0.9.2/admin?action=add&target=user&arg2=bobby&arg3=rodsuser&arg4=&arg5=&arg6=&arg7='

# alternatively use icommands
# docker exec irods_demo_irods-client-icommands_1 iadmin mkuser bobby rodsuser

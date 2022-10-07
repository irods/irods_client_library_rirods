# to start
docker-compose up

# get token
SECRETS=$(echo -n rods:rods | base64)
TOKEN=$(curl -X POST -H "Authorization: Basic ${SECRETS}" http://localhost:80/irods-rest/0.9.2/auth)

# create user bobby
curl -X POST -H "Authorization: ${TOKEN}" 'http://localhost/irods-rest/0.9.2/admin?action=add&target=user&arg2=bobby&arg3=rodsuser&arg4=&arg5=&arg6=&arg7='

# check new user bobby
curl -X GET -H "Authorization: ${TOKEN}" 'http://localhost/irods-rest/0.9.2/list?logical-path=%2FtempZone%2Fhome&stat=0&permissions=1&metadata=0&offset=0&limit=100' | jq

# delete user bobby
curl -X POST -H "Authorization: ${TOKEN}" 'http://localhost/irods-rest/0.9.2/admin?action=remove&target=user&arg2=bobby&arg3=&arg4=&arg5=&arg6=&arg7='

# to stop
docker-compose down




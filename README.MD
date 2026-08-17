Please take note:
once complete the terraform apply,

save the raw certificate to certs directory: 

terraform output -raw certificate_pem > certs/certificate.pem.crt
terraform output -raw public_key > certs/public.pem.key
terraform output -raw private_key > certs/private.pem.key

go to node-red: localhost:1880

go to "MQTT" node to edit as follows:

1. server: a19iwwhi2w6u01-ats.iot.us-east-1.amazonaws.com (that's the iot_endpoint)

2. Topic: alex_nodered, QoS : 1 Retain: true

2. change port to 8883

3. USE TLS TLS configuration 

4. click the "pencil icon" to edit and input the certificate, Private key and CA Certificate

5. Protocol: MQTT V5

login to aws -> IoT core -> MQTT test Client -> Subscribe to a topic

Enter the topic filter : alex_nodered

click "Subscribe"



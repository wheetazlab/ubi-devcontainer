nohup sudo aws ssm start-session \
--target i-0a28f48f98341b58d \
--document-name AWS-StartPortForwardingSessionToRemoteHost \
--parameters '{"portNumber":["6443"],"localPortNumber":["6443"],"host":["api.ocp-sandbox.non-prod.mas9.nexteramaximo.ibm.com"]}' \
--profile FPL-MAS9-NONPROD &

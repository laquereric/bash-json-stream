#!/bin/sh

curl -v -X POST  --anyauth -u admin:admin \ 
--header "Content-Type:application/json" \ 
-d '{"rest-api": { "name": "TutorialModuleServer", "port": "8010", "database": "TutorialModulesDB" } }' \  "modules-database": "TutorialMModulesDB" } }' \ 
http://MarkLogic-ElasticL-1SGR431M4OQ8S-511413344.us-east-1.elb.amazonaws.com:8002/v1/rest-apis

curl -v -X POST  --anyauth -u admin:admin \ 
--header "Content-Type:application/json" \ 
-d '{"rest-api": { "name": "TutorialServer", "port": "8010", "database": "TutorialDocumentDB" } }' \ 
http://MarkLogic-ElasticL-1SGR431M4OQ8S-511413344.us-east-1.elb.amazonaws.com:8002/v1/rest-apis 

curl -v -X PUT --anyauth -u admin:admin \ 
--header "Content-Type:application/json" \ 
-d '{"collection-lexicon":true}' \ 
http://MarkLogic-ElasticL-1SGR431M4OQ8S-511413344.us-east-1.elb.amazonaws.com:8002/manage/v2/databases/TutorialDB/properties 

curl -v -X POST  --anyauth -u admin:admin \ 
--header "Content-Type:application/json" \ 
-d '{"user-name":"rest-writer", "password": "x", "role": ["rest-writer"]}' \ 
http://MarkLogic-ElasticL-1SGR431M4OQ8S-511413344.us-east-1.elb.amazonaws.com:8002/manage/v2/users 

curl -v -X POST  --anyauth -u admin:admin \ 
--header "Content-Type:application/json" \ 
-d '{"user-name":"rest-admin", "password": "x", "role": ["rest-admin"]}' \ 
http://MarkLogic-ElasticL-1SGR431M4OQ8S-511413344.us-east-1.elb.amazonaws.com:8002/manage/v2/users 

curl -v -X PUT \ 
--digest --user rest-writer:x \ 
-d'{"recipe":"Apple pie", "fromScratch":true, "ingredients":"The Universe"}' \ 
-H "Content-type: application/json" \ 
'http://MarkLogic-ElasticL-1SGR431M4OQ8S-511413344.us-east-1.elb.amazonaws.com:8010/v1/documents?uri=/example/recipe.json' 

curl -X GET \ 
--anyauth --user rest-writer:x \ 
'http://MarkLogic-ElasticL-1SGR431M4OQ8S-511413344.us-east-1.elb.amazonaws.com:8011/v1/search?q=chicken&format=json' 


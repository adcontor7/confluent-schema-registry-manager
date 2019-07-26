# Confluent Schema registry Manager

##Export all latest Schemas
./manager.sh -registry http://my-registry.com:8081 -export

## Export Specific schema
./manager.sh -registry http://my-registry.com:8081 -export eschema1

## Export schema version
./manager.sh -registry http://my-registry.com:8081 -export eschema1 -version 2


##Import all latest Schemas
./manager.sh -registry http://my-registry.com:8081 -import

## Import Specific schema
./manager.sh -registry http://my-registry.com:8081 -import eschema1



 
 



# Confluent Schema registry Manager
Export/import schemas from Confluent Schema Registritry
Linux and Windows compatibility.

OPTIONS:

| Option  | Description | Config Name  | Default Value  | Example |
|---|---|---|---|---|
|  -registry | REGISTRY |  Schema registry URL | -  | `-registry http://my-registry.com:8081`|  
|  -export | - | <SCHEME_NAME> |  Export (Download) all schemas or specific by name | -  |  `-export schema.test` | 
|  -import | - | <SCHEME_NAME> |  Import (Upload) all schemas or specific by name | -  |  `-import schema.test` | 
|  -version | VERSION | Schemas version to Export/Import | `latest`  |  `-version 2` |
|  -config | - | Config file by initializing options |  |  `-config ./config-sample.config` |


## Export all latest Schemas
./manager.sh -registry http://my-registry.com:8081 -export
./manager.sh -config config-sample.config -export

## Export Specific schema
./manager.sh -registry http://my-registry.com:8081 -export eschema1
./manager.sh -config config-sample.config -export eschema1

## Export schema version
./manager.sh -registry http://my-registry.com:8081 -export eschema1 -version 2


##Import all latest Schemas
./manager.sh -registry http://my-registry.com:8081 -import
./manager.sh -config config-sample.config -import

## Import Specific schema
./manager.sh -registry http://my-registry.com:8081 -import eschema1
./manager.sh -config config-sample.config -import eschema1



 
 



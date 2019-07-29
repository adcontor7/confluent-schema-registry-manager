#!/bin/bash

SCHEMAS=(
	"test"
)
REGISTRY_URL=localhost:8081
SCHEMA_VERSION=latest
SCHEMA_DIR=schemas-latest
ACTION=
SCHEMA_NAME=
SCHEMA_PATH="."



# jq must be installed sudo apt-get install jq
export_schema () {
	export TOPIC=$1
	echo "$SCHEMA_PATH/$SCHEMA_DIR/$TOPIC.avsc exporting ..."
	if [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    	curl $REGISTRY_URL/subjects/$TOPIC/versions/$SCHEMA_VERSION | jq -r '.schema|fromjson' > $SCHEMA_PATH/$SCHEMA_DIR/$TOPIC.avsc	
	elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
		echo "MINGW32_NT"
		curl $REGISTRY_URL/subjects/$TOPIC/versions/$SCHEMA_VERSION | ./jq-win32.exe -r '.schema|fromjson' > $SCHEMA_PATH/$SCHEMA_DIR/$TOPIC.avsc
	elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
		echo "MINGW64_NT"
		curl $REGISTRY_URL/subjects/$TOPIC/versions/$SCHEMA_VERSION | ./jq-win64.exe -r '.schema|fromjson' > $SCHEMA_PATH/$SCHEMA_DIR/$TOPIC.avsc
	fi
}

export_all_schemas () {
	for i in "${SCHEMAS[@]}"
	do
		export_schema $i
	done
}

import_schema () {
	echo "$TOPIC Schema will be overwritten. Are you sure? (Y|N)"
	read sure
	if [ -z "$sure" ] || ([ $sure != "Y" ] && [ $sure != "y" ])
	then
	   echo "Nothing will be imported."
	   return 0
	fi

	export TOPIC=$1
	export SCHEMA=$(jq tostring $SCHEMA_PATH/$SCHEMA_DIR/$TOPIC.avsc)
	
	if [ -z "$SCHEMA" ]
	then
	   echo "$SCHEMA_PATH/$SCHEMA_DIR/$TOPIC.avsc File not found"
	else
		echo "$SCHEMA_PATH/$SCHEMA_DIR/$TOPIC.avsc importing ..."
		echo "{\"schema\":$SCHEMA}"
		curl -XPOST -H "Content-Type: application/vnd.schemaregistry.v1+json" -d"{\"schema\":$SCHEMA}" $REGISTRY_URL/subjects/$TOPIC/versions
	fi
}

import_all_schemas () {
	for i in "${SCHEMAS[@]}"
	do
		import_schema $i
	done
}

schema_exists () { 
    local name=$1
    local in=1
    for i in "${SCHEMAS[@]}"
	do
		if [[ $i == $name ]]; then
            in=0
            break
        fi
    done   
    return $in
}




while [ -n "$1" ]; do # while loop starts
 
    case "$1" in
	
	-config) 
        . ${2}
        shift
        ;;
    -path) 
        SCHEMA_PATH=${2}
        shift
        ;;
    -registry) 
        REGISTRY_URL=${2}
        shift
        ;;    
    -version) 
        SCHEMA_VERSION=${2}
        SCHEMA_DIR="schema-v$SCHEMA_VERSION"
        shift
        ;;
    -export) 
        ACTION=export
        if [ ! -z "${2}" ] && schema_exists ${2};
		then
		     SCHEMA_NAME=${2}
		fi
        shift
        ;;
    -import)
        ACTION=import
        if [ ! -z "${2}" ] && schema_exists ${2};
		then
		     SCHEMA_NAME=${2}
		fi
        shift
        ;;
 
    *) . ${1} ;;
 
    esac
 
    shift
 
done


echo "REGISTRY_URL: $REGISTRY_URL"
echo "ACTION: $ACTION"
echo "SCHEMA_NAME: $SCHEMA_NAME"
echo "SCHEMA_VERSION: $SCHEMA_VERSION"
echo "SCHEMAS_DIR: $SCHEMA_PATH/$SCHEMA_DIR"
echo "SCHEMAS: ${SCHEMAS[@]}"


mkdir -p $SCHEMA_PATH/$SCHEMA_DIR


if [[ $ACTION == "export" ]]
then
    if [ -z "$SCHEMA_NAME" ]
	then
	      export_all_schemas
	else
	      export_schema $SCHEMA_NAME
	fi
elif [[ $ACTION == "import" ]]
then
    if [ -z "$SCHEMA_NAME" ]
	then
	      import_all_schemas
	else
	      import_schema $SCHEMA_NAME
	fi
else
	echo "¡¡¡ ACTION REQUIRED !!!"
fi

#!/usr/bin/env bash

HOST=http://localhost:9999
CONTEXT=bigdata

while getopts h:c:n:l:s option
do
  case "${option}"
  in
    h) HOST=${OPTARG};;
    c) CONTEXT=${OPTARG};;
    n) NAMESPACE=${OPTARG};;
    l) LANGS=${OPTARG};;
    s) SKIPSITE=1;;
  esac
done

if [ -z "$NAMESPACE" ]
then
  echo "Usage: $0 -n <namespace> [-h <host>] [-c <context>]"
  exit 1
fi

if [ -z "$LANGS" ]; then
    ARGS=
else
    ARGS="--labelLanguage $LANGS --singleLabel $LANGS"
fi

if [ ! -z "SKIPSITE" ]; then
    ARGS="$ARGS --skipSiteLinks"
fi

CP=lib/wikidata-query-tools-*-jar-with-dependencies.jar
MAIN=org.wikidata.query.rdf.tool.Update
SPARQL_URL=$HOST/$CONTEXT/namespace/$NAMESPACE/sparql
echo "Updating via $SPARQL_URL"
java -cp $CP $MAIN $ARGS --sparqlUrl $SPARQL_URL

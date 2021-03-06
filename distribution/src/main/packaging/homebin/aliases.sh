# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Elassandra useful aliases (packaged version)
#

export CASSANDRA_HOME=/usr/share/cassandra

# Please set the following variable in your environnement (multihoming support)
export NODE="127.0.0.1"
export NODETOOL_JMX_PORT="7199"

echo "CASSANDRA_HOME=$CASSANDRA_HOME"
echo "NODE=$NODE"
echo "NODETOOL_JMX_PORT=$NODETOOL_JMX_PORT"

# for debug purpose only
export JVM_DEBUG_PORT="4242"
export JVM_DEBUG_WAIT="n"

export CASSANDRA_CONF=/etc/cassandra
export CASSANDRA_DATA=/var/lib/cassandra
export CASSANDRA_LOGS=/var/log/cassandra

export PROTOCOL="${PROTOCOL:-http}"
export CQLSH_OPTS=""
[ "x$CASSANDRA_SSL" != "x" ] && CQLSH_OPTS="$CQLSH_OPTS --ssl"

export CASSANDRA_EXEC=cassandra
export NODETOOL_EXEC=nodetool

# Kill cassandra process
function ckill() {
   kill `ps ax | grep java | grep $CASSANDRA_HOME | awk '{ print $1}'`
}

function cstatus() {
   ps ax | grep java | grep $CASSANDRA_HOME
}

function cleanall() {
   read -r -p "Do you really want to remove data and logs ? [y/n]" response
   if [[ $response =~ ^(yes|y| ) ]]; then
      rm -rf $CASSANDRA_DATA/*
      rm -rf $CASSANDRA_LOGS/*
      echo "Done."
   fi
}

function cleanlogs() {
	rm -rf $CASSANDRA_HOME/logs/*.log*
}

function get() {
   curl -XGET  $CREDENTIAL  "$PROTOCOL://$NODE:9200/$1" $2 $2 $4 $5
}
function put() {
   curl -XPUT -H Content-Type:application/json $CREDENTIAL "$PROTOCOL://$NODE:9200/$1" -d "$2"
}
function post() {
   curl -XPOST -H Content-Type:application/json $CREDENTIAL "$PROTOCOL://$NODE:9200/$1" -d "$2"
}
function delete() {
   curl -XDELETE -H Content-Type:application/json $CREDENTIAL "$PROTOCOL://$NODE:9200/$1" -d "$2"
}

function close() {
curl -XPOST  $CREDENTIAL "$PROTOCOL://$NODE:9200/$1/_close?pretty"
}

function open() {
curl -XPOST  $CREDENTIAL "$PROTOCOL://$NODE:9200/$1/_open?pretty"
}

function forcemerge() {
   if [ "x$2" == "x" ]; then
    curl -XPOST  $CREDENTIAL "$PROTOCOL://$NODE:9200/$1/_forcemerge?pretty"
   else
    curl -XPOST  $CREDENTIAL "$PROTOCOL://$NODE:9200/$1/_forcemerge?max_num_segments=$2&pretty"
   fi
}

function rebuild() {
   if [ "x$2" == "x" ]; then
      curl -XPOST  $CREDENTIAL "$PROTOCOL://$NODE:9200/$1/_rebuild"
   else
      curl -XPOST  $CREDENTIAL "$PROTOCOL://$NODE:9200/$1/_rebuild?num_threads=$2"
   fi
}

function clearcache() {
curl -XPOST  $CREDENTIAL "$PROTOCOL://$NODE:9200/$1/_cache/clear?pretty"
}

function flush() {
curl -XPOST  $CREDENTIAL "$PROTOCOL://$NODE:9200/$1/_flush?pretty"
}

function refresh() {
curl -XPOST  $CREDENTIAL "$PROTOCOL://$NODE:9200/$1/_refresh?pretty"
}

# Cassandra aliases
alias cstart='cassandra'
alias cdebug='cassandra -d'
alias cstop='nodetool -p $NODETOOL_JMX_PORT -h $NODE stopdaemon'
alias clog='less $CASSANDRA_LOGS/system.log'
alias cqlsh='cqlsh $NODE'
alias nodetool='nodetool -p $NODETOOL_JMX_PORT'

# Start Elassandra
alias elstart='cassandra -e'
alias eldebug='cassandra -d -e'

# Elasticsearch aliases
alias health='curl -XGET  $CREDENTIAL $PROTOCOL://$NODE:9200/_cluster/health/?pretty=true'
alias state='curl -XGET  $CREDENTIAL $PROTOCOL://$NODE:9200/_cluster/state/?pretty=true'
alias blocks='curl -XGET  $CREDENTIAL $PROTOCOL://$NODE:9200/_cluster/state/blocks/?pretty=true'
alias metadata='curl -XGET  $CREDENTIAL $PROTOCOL://$NODE:9200/_cluster/state/metadata/?pretty=true'
alias stats='curl -XGET  $CREDENTIAL $PROTOCOL://$NODE:9200/_stats?pretty=true'
alias shards='curl -s -XGET  $CREDENTIAL $PROTOCOL://$NODE:9200/_cat/shards?v | sort'
alias indices='curl -s -XGET  $CREDENTIAL $PROTOCOL://$NODE:9200/_cat/indices?v | sort'
alias allocation='curl -s -XGET  $CREDENTIAL $PROTOCOL://$NODE:9200/_cat/allocation?v'
alias fielddata='curl -XGET  $CREDENTIAL $PROTOCOL://$NODE:9200/_cat/fielddata/body,text?v'
alias threads='curl -XGET  $CREDENTIAL $PROTOCOL://$NODE:9200/_cat/thread_pool?v'
alias hotthreads='curl -XGET  $CREDENTIAL $PROTOCOL://$NODE:9200/_nodes/hot_threads'
alias pending_tasks='curl -XGET  $CREDENTIAL $PROTOCOL://$NODE:9200/_cat/pending_tasks?v'
alias segments='curl -XGET  $CREDENTIAL $PROTOCOL://$NODE:9200/_cat/segments?v'
alias nodec='curl -XGET  $CREDENTIAL $PROTOCOL://$NODE:9200/_cat/nodes?h=id,ip,heapPercent,ramPercent,fileDescriptorPercent,segmentsCount,segmentsMemory'
alias nodes='curl -XGET  $CREDENTIAL "$PROTOCOL://$NODE:9200/_nodes?pretty"'
alias settings='curl -XGET  $CREDENTIAL $PROTOCOL://$NODE:9200/_cluster/settings?pretty'
alias tasks='curl  $CREDENTIAL $PROTOCOL://$NODE:9200/_tasks?pretty'
alias aliases='curl  $CREDENTIAL $PROTOCOL://$NODE:9200/_cat/aliases?v'
alias templates='curl  $CREDENTIAL $PROTOCOL://$NODE:9200/_template?pretty'
alias pipelines='curl  $CREDENTIAL $PROTOCOL://$NODE:9200/_ingest/pipeline?pretty'

alias nodes='curl -XGET $CREDENTIAL "$PROTOCOL://$NODE:9200/_nodes?pretty"'

alias open='open'
alias close='close'
alias forcemerge='forcemerge'
alias clearcache='clearcache'
alias flush='flush'
alias refresh='refresh'
alias rebuild='rebuild'

alias get='get'
alias delete='delete'

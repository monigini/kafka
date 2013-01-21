#!/bin/bash
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

scala_version="2.9.2"


base_dir=$(dirname $0)/../..

for file in $base_dir/project/boot/scala-$scala_version/lib/*.jar;
do
  if [ ${file##*/} != "sbt-launch.jar" ]; then
    CLASSPATH=$CLASSPATH:$file
  fi
done

for file in $base_dir/core/lib_managed/scala_$scala_version/compile/*.jar;
do
  CLASSPATH=$CLASSPATH:$file
done

for file in $base_dir/core/lib/*.jar;
do
  CLASSPATH=$CLASSPATH:$file
done

for file in $base_dir/core/target/scala_$scala_version/*.jar;
do
  CLASSPATH=$CLASSPATH:$file
done

for file in $base_dir/examples/target/scala_$scala_version/*.jar;
do
  CLASSPATH=$CLASSPATH:$file
done

echo $CLASSPATH

if [ -z "$KAFKA_PERF_OPTS" ]; then
  KAFKA_OPTS="-Xmx512M -server -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=3333 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false"
fi

if [ -z "$JAVA_HOME" ]; then
  JAVA="java"
else
  JAVA="$JAVA_HOME/bin/java"
fi

$JAVA $KAFKA_OPTS -cp $CLASSPATH kafka.examples.KafkaConsumerProducerDemo $@



# To run docker without sudo:
sudo usermod -aG docker $USER 
newgrp docker # no need for log out - to test, otherwise log out and log back in



# Install maven for building Apache Spark on the main VM
sudo apt install maven


# download and build the copy of Apache Spark. (Spark 3.1, which is stable release on Dec 2020, consider updating though, seems to work on 3.5)
# By running with -Pkubernetes as follows, this copy of Spark will be compiled with Kubernetes support.
# Latest: 
# git clone https://github.com/apache/spark
git clone https://github.com/apache/spark.git --branch v3.1.3 --single-branch

cd spark
./build/mvn -Pkubernetes -DskipTests clean package






# start pyspark console (to get the list of dependencies list and versions needed for azure-hadoop and azure-storage when deploying docker image)
./bin/pyspark \
  --conf spark.hadoop.fs.azure.account.key.<StorageAccountName>.blob.core.windows.net=<StorageAccountAccessKey> \
  --packages org.apache.hadoop:hadoop-azure:3.2.0,com.microsoft.azure:azure-storage:8.6.3

# Check the list of packages and dependencies needed for the docker image creation:
ls ~/.ivy2/jars/
# com.fasterxml.jackson.core_jackson-core-2.9.4.jar
# com.google.guava_guava-20.0.jar
# com.microsoft.azure_azure-keyvault-core-1.0.0.jar
# com.microsoft.azure_azure-storage-8.6.3.jar
# commons-codec_commons-codec-1.11.jar
# commons-logging_commons-logging-1.1.3.jar
# org.apache.commons_commons-lang3-3.4.jar
# org.apache.hadoop_hadoop-azure-3.2.0.jar
# org.apache.httpcomponents_httpclient-4.5.2.jar
# org.apache.httpcomponents_httpcore-4.4.4.jar
# org.codehaus.jackson_jackson-core-asl-1.9.13.jar
# org.codehaus.jackson_jackson-mapper-asl-1.9.13.jar
# org.eclipse.jetty_jetty-util-9.3.24.v20180605.jar
# org.eclipse.jetty_jetty-util-ajax-9.3.24.v20180605.jar
# org.slf4j_slf4j-api-1.7.12.jar
# org.wildfly.openssl_wildfly-openssl-1.0.4.Final.jar








# Copy original pyspark Dockerfile in resource-managers/kubernetes/docker/src/main/dockerfiles/spark/bindings/python/ and modify this file as follows:

# Install wget by apt command
# Install numpy package by pip3 command
# Download all dependencies’ jars for Azure storage integration with wget command



# SAMPLE UPDATED DOCKER FILE BELOW:

# ARG base_img

# FROM $base_img
# WORKDIR /

# # Reset to root to run installation tasks
# USER 0

# RUN mkdir ${SPARK_HOME}/python
# RUN apt-get update && \
#     apt install -y wget python3 python3-pip && \
#     pip3 install --upgrade pip setuptools && \
#     pip3 install numpy && \
#     rm -r /root/.cache && rm -rf /var/cache/apt/*

# COPY python/pyspark ${SPARK_HOME}/python/pyspark
# COPY python/lib ${SPARK_HOME}/python/lib

# WORKDIR /opt/spark/work-dir

# # Download hadoop-azure, azure-storage, and dependencies (See above)
# RUN wget --quiet https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-azure/3.2.0/hadoop-azure-3.2.0.jar -O /opt/spark/jars/hadoop-azure-3.2.0.jar
# RUN wget --quiet https://repo1.maven.org/maven2/com/microsoft/azure/azure-storage/8.6.3/azure-storage-8.6.3.jar -O /opt/spark/jars/azure-storage-8.6.3.jar
# RUN wget --quiet https://repo1.maven.org/maven2/org/apache/httpcomponents/httpclient/4.5.2/httpclient-4.5.2.jar -O /opt/spark/jars/httpclient-4.5.2.jar
# RUN wget --quiet https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-util-ajax/9.3.24.v20180605/jetty-util-ajax-9.3.24.v20180605.jar -O /opt/spark/jars/jetty-util-ajax-9.3.24.v20180605.jar
# RUN wget --quiet https://repo1.maven.org/maven2/org/codehaus/jackson/jackson-mapper-asl/1.9.13/jackson-mapper-asl-1.9.13.jar -O /opt/spark/jars/jackson-mapper-asl-1.9.13.jar
# RUN wget --quiet https://repo1.maven.org/maven2/org/codehaus/jackson/jackson-core-asl/1.9.13/jackson-core-asl-1.9.13.jar -O /opt/spark/jars/jackson-core-asl-1.9.13.jar
# RUN wget --quiet https://repo1.maven.org/maven2/org/wildfly/openssl/wildfly-openssl/1.0.4.Final/wildfly-openssl-1.0.4.Final.jar -O /opt/spark/jars/wildfly-openssl-1.0.4.Final.jar
# RUN wget --quiet https://repo1.maven.org/maven2/org/apache/httpcomponents/httpcore/4.4.4/httpcore-4.4.4.jar -O /opt/spark/jars/httpcore-4.4.4.jar
# RUN wget --quiet https://repo1.maven.org/maven2/commons-logging/commons-logging/1.1.3/commons-logging-1.1.3.jar -O /opt/spark/jars/commons-logging-1.1.3.jar
# RUN wget --quiet https://repo1.maven.org/maven2/commons-codec/commons-codec/1.11/commons-codec-1.11.jar -O /opt/spark/jars/commons-codec-1.11.jar
# RUN wget --quiet https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-util/9.3.24.v20180605/jetty-util-9.3.24.v20180605.jar -O /opt/spark/jars/jetty-util-9.3.24.v20180605.jar
# RUN wget --quiet https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-core/2.9.4/jackson-core-2.9.4.jar -O /opt/spark/jars/jackson-core-2.9.4.jar
# RUN wget --quiet https://repo1.maven.org/maven2/org/slf4j/slf4j-api/1.7.12/slf4j-api-1.7.12.jar -O /opt/spark/jars/slf4j-api-1.7.12.jar
# RUN wget --quiet https://repo1.maven.org/maven2/org/apache/commons/commons-lang3/3.4/commons-lang3-3.4.jar -O /opt/spark/jars/commons-lang3-3.4.jar
# RUN wget --quiet https://repo1.maven.org/maven2/com/microsoft/azure/azure-keyvault-core/1.0.0/azure-keyvault-core-1.0.0.jar -O /opt/spark/jars/azure-keyvault-core-1.0.0.jar
# RUN wget --quiet https://repo1.maven.org/maven2/com/google/guava/guava/20.0/guava-20.0.jar -O /opt/spark/jars/guava-20.0.jar

# ENTRYPOINT [ "/opt/entrypoint.sh" ]

# # Specify the User that the actual main process will run as
# ARG spark_uid=185
# USER ${spark_uid}

# https://tsmatz.wordpress.com/2020/12/08/apache-spark-on-azure-kubernetes-service-aks/








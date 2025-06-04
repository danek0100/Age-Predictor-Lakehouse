#!/bin/bash

# Запуск Spark Master
$SPARK_HOME/sbin/start-master.sh

# Ждем запуска master
echo "Ожидаем запуска Spark Master..."
sleep 10

# Запуск Spark Worker
$SPARK_HOME/sbin/start-worker.sh spark://spark-standalone:7077

# Ждем запуска worker
echo "Ожидаем запуска Spark Worker..."
sleep 10

echo "Spark Standalone кластер запущен!"
echo "Master UI: http://localhost:8080"
echo "Worker подключен к: spark://spark-standalone:7077"

# Держим контейнер запущенным
tail -f $SPARK_HOME/logs/* 
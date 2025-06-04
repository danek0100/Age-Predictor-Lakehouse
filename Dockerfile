# Используем официальный образ Python
FROM python:3.11-slim

# Устанавливаем системные зависимости
RUN apt-get update && apt-get install -y \
    openjdk-17-jdk \
    wget \
    curl \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем переменные окружения для Java
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH=$PATH:$JAVA_HOME/bin

# Устанавливаем Spark
ENV SPARK_VERSION=3.5.0
ENV HADOOP_VERSION=3
ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

RUN wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    && tar xzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    && mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} ${SPARK_HOME} \
    && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

# Создаем необходимые директории
RUN mkdir -p /opt/spark-apps /opt/data /opt/notebooks /opt/logs

# Копируем файлы зависимостей
COPY requirements.txt /opt/spark-apps/

# Устанавливаем Python зависимости
RUN pip install --no-cache-dir -r /opt/spark-apps/requirements.txt

# Копируем конфигурационные файлы
COPY spark-defaults.conf ${SPARK_HOME}/conf/
COPY start-spark.sh /opt/spark-apps/
COPY hadoop.env /opt/spark-apps/
RUN chmod +x /opt/spark-apps/start-spark.sh

# Устанавливаем рабочую директорию
WORKDIR /opt/spark-apps

# Открываем порты
EXPOSE 8080 4040 7077

# Устанавливаем переменные окружения
ENV PYTHONPATH=/opt/spark-apps
ENV PYSPARK_PYTHON=python3

# Команда по умолчанию - запуск Spark Standalone
CMD ["/opt/spark-apps/start-spark.sh"] 
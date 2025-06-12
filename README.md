# Age Predictor - Spark Lakehouse Project

Проект представляет собой полноценную систему обработки данных и машинного обучения, построенную на основе Apache Spark и Delta Lake. Основная цель проекта — предсказание возраста пользователей на основе данных об их устройствах и поведении.

## 📊 Датасет

Проект использует датасет, созданный на основе данных, предоставленных [MTS](https://www.kaggle.com/datasets/nfedorov/mts-ml-cookies/data?select=dataset_full.feather). 

**Оригинальный датасет:**
- `target_train.feather` - содержит целевые переменные (возраст, пол, user_id)
- `dataset_full.feather` - содержит признаки устройств и поведения пользователей 320+ миллионов строк

**Обработанный датасет:**
- Более 100,000 строк данных
- 6+ признаков различных типов (числовые, категориальные, строковые)
- Удалены дубликаты записей одного пользователя
- Готов для анализа и машинного обучения

## 🏗️ Архитектура проекта

Проект реализует современную архитектуру Lakehouse с использованием Delta Lake:

```
data/
├── bronze/          # Сырые данные в формате Delta Table
├── silver/          # Очищенные и обработанные данные
└── gold/            # Агрегированные данные для ML
```

## 🚀 Быстрый запуск

### Требования
- Docker и Docker Compose

### Запуск проекта
docker-compose up --build -d

# Ожидание запуска сервисов (30-60 секунд)
sleep 60


### Доступ к интерфейсам
- **Spark UI**: http://localhost:8080
- **Jupyter Notebook**: http://localhost:8888
- **MLflow UI**: http://localhost:5000

## 📁 Структура проекта

```
.
├── data/                    # Данные Lakehouse
│   ├── bronze/             # Сырые данные (Delta Tables)
│   ├── silver/             # Очищенные данные
│   └── gold/               # Агрегированные данные для ML
├── notebooks/              # Jupyter notebooks
│   ├── etl_pipeline.ipynb  # ETL pipeline разработка
│   ├── gold_layer.ipynb    # Gold слой и агрегации
│   └── ml_model.ipynb      # Машинное обучение
├── logs/                   # Логи выполнения
├── mlflow/                 # MLflow артефакты и модели
├── docker-compose.yml      # Конфигурация Docker
├── Dockerfile             # Образ приложения
├── requirements.txt       # Зависимости Python
└── README.md
```

## 🔧 Технические особенности

### 1. Spark Standalone Cluster
- Локальный Spark Standalone кластер в Docker
- Оптимизированные настройки для производительности
- Поддержка Delta Lake

### 2. Delta Lake Integration
- **Bronze слой**: Сырые данные в формате Delta Table
- **Silver слой**: Очищенные данные с валидацией
- **Gold слой**: Агрегированные данные для ML

### 3. Оптимизации Spark
- Использование `.repartition()` для оптимального распределения данных
- `.partitionBy()` для эффективного чтения/записи
- Адаптивные запросы (`spark.sql.adaptive.enabled`)
- Kryo сериализация для производительности

### 4. ETL Pipeline
```python
# Пример оптимизированной обработки
df = spark.read.format("delta").load(bronze_path)
df = df.repartition(200).partitionBy("category")
df.write.format("delta").mode("overwrite").save(silver_path)
```

### 5. Машинное обучение
- **Алгоритм**: Random Forest
- **Метрики**: RMSE, MAE, R²
- **MLflow**: Логирование экспериментов и моделей
- **Автоматический выбор лучшей модели**

## 📈 Результаты

### Качество моделей
- **Лучшая модель**: Random Forest
- **RMSE**: 11 лет
- **R²**: 0.108
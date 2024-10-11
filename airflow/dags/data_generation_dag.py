from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
from zoneinfo import ZoneInfo
import random
import uuid
from airflow.utils.dates import days_ago

# Import necessary functions and variables from your original script
from plugins.db_init.generate_mockup_data import (
    SAMPLE_QUESTIONS, SAMPLE_ANSWERS, MODELS, RELEVANCE
   
)
from plugins.db_init.db import save_conversation, save_feedback, get_db_connection

# Set the timezone to CET (Europe/Berlin)
tz = ZoneInfo("Europe/Berlin")

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': days_ago(1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'data_generation_dag',
    default_args=default_args,
    description='Generate historical and live data',
    schedule_interval=timedelta(seconds=10),
    catchup=False,
)

def generate_synthetic_data(start_time, end_time):
    current_time = start_time
    conversation_count = 0
    while current_time < end_time:
        conversation_id = str(uuid.uuid4())
        question = random.choice(SAMPLE_QUESTIONS)
        answer = random.choice(SAMPLE_ANSWERS)
        model = random.choice(MODELS)
        relevance = random.choice(RELEVANCE)

        openai_cost = 0
        if model.startswith("openai/"):
            openai_cost = random.uniform(0.001, 0.1)

        answer_data = {
            "answer": answer,
            "response_time": random.uniform(0.5, 5.0),
            "relevance": relevance,
            "relevance_explanation": f"This answer is {relevance.lower()} to the question.",
            "model_used": model,
            "prompt_tokens": random.randint(50, 200),
            "completion_tokens": random.randint(50, 300),
            "total_tokens": random.randint(100, 500),
            "eval_prompt_tokens": random.randint(50, 150),
            "eval_completion_tokens": random.randint(20, 100),
            "eval_total_tokens": random.randint(70, 250),
            "openai_cost": openai_cost,
        }

        save_conversation(conversation_id, question, answer_data, current_time)

        if random.random() < 0.7:
            feedback = 1 if random.random() < 0.8 else -1
            save_feedback(conversation_id, feedback, current_time)

        current_time += timedelta(minutes=random.randint(1, 15))
        conversation_count += 1

    return f"Generated {conversation_count} historical conversations"

def generate_live_data(**kwargs):
    execution_date = kwargs['execution_date']
    end_time = execution_date + timedelta(hours=1)
    current_time = execution_date
    conversation_count = 0

    while current_time < end_time:
        conversation_id = str(uuid.uuid4())
        question = random.choice(SAMPLE_QUESTIONS)
        answer = random.choice(SAMPLE_ANSWERS)
        model = random.choice(MODELS)
        relevance = random.choice(RELEVANCE)

        openai_cost = 0
        if model.startswith("openai/"):
            openai_cost = random.uniform(0.001, 0.1)

        answer_data = {
            "answer": answer,
            "response_time": random.uniform(0.5, 5.0),
            "relevance": relevance,
            "relevance_explanation": f"This answer is {relevance.lower()} to the question.",
            "model_used": model,
            "prompt_tokens": random.randint(50, 200),
            "completion_tokens": random.randint(50, 300),
            "total_tokens": random.randint(100, 500),
            "eval_prompt_tokens": random.randint(50, 150),
            "eval_completion_tokens": random.randint(20, 100),
            "eval_total_tokens": random.randint(70, 250),
            "openai_cost": openai_cost,
        }

        save_conversation(conversation_id, question, answer_data, current_time)

        if random.random() < 0.7:
            feedback = 1 if random.random() < 0.8 else -1
            save_feedback(conversation_id, feedback, current_time)

        current_time += timedelta(minutes=random.randint(1, 5))
        conversation_count += 1

    return f"Generated {conversation_count} live conversations"

# Task to generate historical data
generate_historical_data = PythonOperator(
    task_id='generate_historical_data',
    python_callable=generate_synthetic_data,
    op_kwargs={
        'start_time': datetime.now(tz) - timedelta(hours=6),
        'end_time': datetime.now(tz),
    },
    dag=dag,
)

# Task to generate live data
generate_live_data_task = PythonOperator(
    task_id='generate_live_data',
    python_callable=generate_live_data,
    provide_context=True,
    dag=dag,
)

generate_historical_data >> generate_live_data_task
# Dockerfile
FROM python:3.8-slim

WORKDIR /app

COPY requirements.txt /app/requirements.txt
RUN pip install -r requirements.txt

COPY . /app

# Make port 5003 available to the world outside this container
EXPOSE 5003

CMD ["python", "app.py"]
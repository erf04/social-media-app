FROM python:3.10-slim AS backend
WORKDIR /backend
COPY ./requirements.txt .
COPY . /backend/
RUN pip3 install --no-cache-dir -r requirements.txt
RUN python3 manage.py makemigrations & python3 manage.py migrate

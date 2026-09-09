# Container-build alternative to the AgentCore CodeZip deploy.
# Build for ARM64 (AgentCore Runtime):  docker buildx build --platform linux/arm64 -t chaser .
FROM --platform=linux/arm64 python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    CHASER_DB_PATH=/tmp/chaser.db \
    CHASER_SESSIONS_DIR=/tmp/sessions \
    DEMO_TODAY=2026-09-12

WORKDIR /app

COPY requirements.txt pyproject.toml ./
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py ./
COPY src ./src
COPY data ./data
RUN pip install --no-cache-dir --no-deps -e .

RUN useradd --create-home --uid 10001 chaser && chown -R chaser:chaser /app
USER chaser

EXPOSE 8080
CMD ["python", "main.py"]

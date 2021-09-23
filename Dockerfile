FROM alpine:3.14

RUN apk update && apk add ffmpeg python3 curl

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -

ENV PATH="/root/.poetry/bin:${PATH}"

COPY ./stream.py /app/stream.py
COPY ./pyproject.toml /app/pyproject.toml
COPY ./poetry.toml /app/poetry.toml

WORKDIR /app

RUN poetry install

ENV PATH="/app/.venv/bin:${PATH}"

ENTRYPOINT ["python", "/app/stream.py"]

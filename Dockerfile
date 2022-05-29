FROM python:3
ARG ENV

ENV ENV=${ENV} PYTHONFAULTHANDLER=1 PYTHONUNBUFFERED=1 PYTHONHASHSEED=random PIP_NO_CACHE_DIR=off PIP_DISABLE_PIP_VERSION_CHECK=on PIP_DEFAULT_TIMEOUT=100

RUN mkdir /todo
WORKDIR /todo

COPY poetry.lock pyproject.toml /todo/
RUN pip install --upgrade pip
RUN pip install poetry
RUN poetry config virtualenvs.create false \
  && poetry install $(test "$ENV" == production && echo "--no-dev") --no-interaction --no-ansi

COPY . /todo/

EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "todo.wsgi"]

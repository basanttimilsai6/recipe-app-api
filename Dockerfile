# FROM python:3.9-alpine3.13
# LABEL maintainer="londonappdeveloper.com"

# ENV PYTHONUNBUFFERED 1

# COPY ./requirements.txt /tmp/requirements.txt
# COPY ./requirements.dev.txt /tmp/requirements.dev.txt
# COPY ./app /app
# WORKDIR /app
# EXPOSE 8000

# ARG DEV=false

# RUN python -m venv /py && \
#     /py/bin/pip install -r /tmp/requirements.txt && \
#     apk add --update --no-cache postgresql-client && \
#     apk add --update --no-cache --virtual .tmp-build-deps \
#         build-base postgresql-dev musl-dev && \
#     /py/bin/pip install --upgrade pip && \
#     if [ $DEV = "true" ]; \
#         then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
#     fi && \
#     rm -rf /tmp && \
#     apk del .tmp-build-deps && \
#     adduser \
#         --disabled-password \
#         --no-create-home \
#         django-user

# ENV PATH="/py/bin:$PATH"
# USER django-user





# Use Python 3.9 with Alpine Linux as the base image
FROM python:3.9-alpine3.13

# Set the maintainer label
LABEL maintainer="londonappdeveloper.com"

# Set environment variable to ensure Python output is unbuffered
ENV PYTHONUNBUFFERED 1

# Copy requirements files to the /tmp directory in the image
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Copy the entire app directory to /app in the image
COPY ./app /app

# Set the working directory to /app
WORKDIR /app

# Expose port 8000
EXPOSE 8000

# Set a build-time argument for development dependencies
ARG DEV=false

# Install dependencies and configure the environment
RUN set -eux \
    && apk add --update --no-cache \
        postgresql-client \
        libpq \
    && apk add --update --no-cache --virtual .tmp-build-deps \
        build-base \
        postgresql-dev \
        musl-dev \
    && python -m venv /py \
    && /py/bin/pip install --upgrade pip \
    && /py/bin/pip install -r /tmp/requirements.txt \
    && if [ "$DEV" = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi \
    && rm -rf /tmp \
    && apk del .tmp-build-deps \
    && adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Add /py/bin to the PATH environment variable
ENV PATH="/py/bin:$PATH"

# Switch to the non-root user django-user
USER django-user

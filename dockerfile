# syntax=docker/dockerfile:1
FROM python:3.10-bullseye

# Set curring working directory
WORKDIR /app

# Install dependencies
COPY requirements.in requirements.in
COPY makefile makefile
RUN make pip-init && make build

# Copy the rest of the package
COPY . .

# Expose container port
# Access the application e.g. localhost:8000
# EXPOSE 8000

# Run the backend
# Expose application port
CMD ["python3", "src/main.py"]

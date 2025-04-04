# Use an official Python image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy application files
COPY requirements.txt .
COPY app.py .

# Install dependencies
RUN pip install -r requirements.txt

# Expose the port
EXPOSE 5000

# Run the application
CMD ["python", "app.py"]

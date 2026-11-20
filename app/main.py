from fastapi import FastAPI

app = FastAPI(
    title="DevSecOps Assessment API",
    description="A sample microservice for demonstrating a secure CI/CD pipeline.",
    version="1.0.0"
)


@app.get("/")
def home():
    return {
        "message": "DevSecOps microservice is running",
        "status": "healthy"
    }


@app.get("/health")
def health_check():
    return {
        "status": "healthy"
    }

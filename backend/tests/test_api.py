from fastapi.testclient import TestClient
from app.main import app
from app.config import settings

client = TestClient(app)

def test_health():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}

def test_missing_headers():
    response = client.post("/chat", json={
        "goal": "exam_prep",
        "level": "beginner",
        "explanation_language": "en",
        "messages": [{"role": "user", "text": "Hi"}]
    })
    # Should fail due to missing X-App-Token and X-Device-Id
    assert response.status_code == 401
    assert "error" in response.json()

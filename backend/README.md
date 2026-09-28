# English Tutor - Backend

This is the FastAPI backend for the English Tutor app, designed to run on Vercel as a Serverless Function.

## Prerequisites

- Python 3.11+
- `pip`

## Running Locally

1. Create a virtual environment and activate it:
   ```bash
   cd backend
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Create the environment file:
   ```bash
   cp .env.example .env
   ```
   *Edit `.env` and insert your actual `GEMINI_API_KEY` and define a custom `APP_TOKEN`.*

4. Run the development server:
   ```bash
   uvicorn app.main:app --reload
   ```

   The API will be available at `http://127.0.0.1:8000`. You can view the automatic interactive API documentation at `http://127.0.0.1:8000/docs`.

## Testing

To run the unit tests:

```bash
cd backend
pytest tests/
```

## Deployment to Vercel

The backend includes a `vercel.json` file. You can deploy it using the Vercel CLI:

```bash
npm i -g vercel
cd backend
vercel
```

Make sure to configure the Environment Variables (`GEMINI_API_KEY`, `GEMINI_MODEL`, `DAILY_LIMIT`, `APP_TOKEN`) in your Vercel project dashboard.

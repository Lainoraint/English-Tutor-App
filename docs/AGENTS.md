# AGENTS.md - Rules for the AI developer

You are building the English Tutor MVP described in `README.md`. Follow these rules.

## Working style

1. Read `README.md`, `ARCHITECTURE.md`, `API_CONTRACT.md`, `PROMPTS.md`, then `TASKS.md`.
2. Work on **one task group at a time**, in the order given in `TASKS.md`. Tick the checkboxes as tasks are completed.
3. **MVP first.** If a feature is listed under "out of scope" in `README.md`, do not build it, and do not add hooks "for later" that add complexity.
4. Prefer the simplest solution that meets the acceptance criteria. No premature abstraction, no extra layers, no unrequested packages.
5. If something is ambiguous or conflicts with these docs, **ask the owner** instead of guessing. Do not change an item listed under "Assumptions" without asking.
6. After finishing a task group, summarize what changed and how to run/test it.

## Hard rules

- **Never** put the Gemini API key (or any secret) in the Flutter app, in git, or in logs. Backend reads it from the `GEMINI_API_KEY` environment variable. Provide a `.env.example` with placeholder values only.
- The Flutter app talks **only** to our FastAPI backend, never directly to Gemini.
- The backend must validate all Gemini output against Pydantic models and return a clean error if the output is invalid. Never pass raw model text to the app as structured data.
- Every request from the app carries `goal`, `level`, and `explanation_language` (see `API_CONTRACT.md`).
- Keep all user-facing error messages friendly and short. The app must never show stack traces.
- Do not send audio anywhere. Speech-to-text runs on the device; only the transcript text is sent.
- Do not add analytics, ads, or tracking SDKs.

## Code conventions

**Backend (Python)**
- Python 3.11+, FastAPI, Pydantic v2, `uvicorn`.
- Use the official Google Gen AI Python SDK. Check its **current** documentation for the correct package name, client setup, and structured-output (JSON schema) usage before writing code.
- Type hints everywhere. Small modules, no global mutable state except the best-effort in-memory rate limiter. The backend runs as a **serverless function on Vercel**: no background threads, no reliance on local disk or long-lived state.
- Config through environment variables only.

**Flutter (Dart)**
- Null safety, `flutter_riverpod` for state, `speech_to_text` for the mic, `http` (or `dio`) for API calls, `shared_preferences` for settings.
- Feature-first folder layout (see `ARCHITECTURE.md`).
- All API calls go through one `ApiClient` class. Widgets never call HTTP directly.
- Every screen handles three states: loading, error (with retry), and success. Use a longer timeout (60 s) and a "Connecting to the server..." message because the serverless backend may have cold starts.
- Keep UI clean and simple: Material 3, light and dark theme following the system.

## Testing expectations

- Backend: at least one test per endpoint using a mocked Gemini client (no real API calls in tests). Also test schema validation failure handling.
- Flutter: at minimum, a working manual test path per feature and unit tests for the JSON models (parsing the contract examples).
- Before marking a task done, make sure the app builds (`flutter build apk --debug`) and the backend starts locally.

## What to do when blocked

State clearly what is blocked, what you tried, and the options you see. Do not silently work around requirements.

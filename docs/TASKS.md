# TASKS.md

Work top to bottom. Tick `[x]` when done. Do not start a phase until the previous one meets its acceptance criteria. Tasks marked **(owner)** must be done by the human owner, not the AI.

## Phase 0 - Setup

- [ ] **(owner)** Create a Gemini API key in Google AI Studio and keep it private.
- [ ] **(owner)** Create a GitHub repo and a Vercel account (Hobby plan; sign up with GitHub).
- [ ] Create the repo structure from `ARCHITECTURE.md` (`docs/`, `backend/`, `app/`), with `.gitignore` covering `.env`, build outputs, and IDE files.
- [ ] Copy these docs into `docs/`.

**Done when:** repo exists with the folder skeleton and no secrets committed.

## Phase 1 - Backend

- [ ] FastAPI project, `requirements.txt`, `config.py` reading env vars, `.env.example`.
- [ ] `GET /health`.
- [ ] Header checks (`X-App-Token`, `X-Device-Id`) and a best-effort in-memory daily rate limiter.
- [x] `gemini.py`: one function that sends system instruction + content and returns JSON validated against a Pydantic model, with one retry.
- [x] Pydantic models from `API_CONTRACT.md` with the quiz validators.
- [x] Prompt builders from `PROMPTS.md`.
- [x] `POST /chat`, `POST /quiz`, `POST /speaking/prompt`, `POST /speaking/feedback`.
- [x] Standard error format and handlers (`unauthorized`, `rate_limited`, `bad_request`, `ai_unavailable`, `ai_invalid_output`).
- [x] Tests with a mocked Gemini client for each endpoint, including invalid-output and rate-limit cases.
- [x] `README` section in `backend/` with run instructions.

**Done when:** all endpoints work locally with a real key (manual check with curl/Postman using the examples in `API_CONTRACT.md`), and tests pass.

## Phase 2 - Deploy backend

- [ ] Make the backend deployable on Vercel per the official FastAPI guide (see `ARCHITECTURE.md`, "Hosting on Vercel"): entrypoint that exposes `app`, `requirements.txt`, Python version pinned as documented. Verify locally with `vercel dev`.
- [ ] **(owner)** Import the GitHub repo in Vercel, set **Root Directory** to `backend`, add environment variables `GEMINI_API_KEY`, `GEMINI_MODEL` (`gemini-3.5-flash-lite`), `DAILY_LIMIT`, `APP_TOKEN` for the Production environment, then deploy.
- [ ] Note any cold-start delay and confirm the 60 s limit is not hit by `/quiz` (10 questions).
- [ ] Verify `/health` and one AI endpoint on the deployed URL. Note the cold-start delay.

**Done when:** the public Vercel URL answers `/health` and `/chat` correctly.

## Phase 3 - Flutter foundation

- [ ] Create the Flutter project (Android target), Material 3 light/dark theme.
- [ ] `flutter_riverpod`, `shared_preferences`, `speech_to_text`, `http` (or `dio`) added.
- [ ] `ApiClient` with base URL from `--dart-define`, headers, 60 s timeout, error mapping to the contract error codes.
- [ ] Dart models mirroring `API_CONTRACT.md`, with unit tests that parse the example JSON.
- [ ] Settings store (goal, level, explanation language, device id).
- [ ] Onboarding (3 steps) shown only on first launch.
- [ ] Home screen with three cards and a settings icon; Settings screen to change the three values.
- [ ] Background `GET /health` on app start.
- [ ] Shared widgets: loading indicator with a "Connecting to the server..." message after a few seconds, error view with retry.

**Done when:** the app runs on an Android device/emulator, onboarding saves values, and the home screen navigates to placeholder screens.

## Phase 4 - Conversation

- [ ] Chat UI: message list, input box, send button, in-memory history.
- [ ] Quick topic chips (fixed list from `README.md`) shown on an empty chat, following the goal.
- [ ] Call `POST /chat` with the last 10 messages; show reply bubble.
- [ ] Correction card under the AI bubble (original, fixed, explanation); "No errors" indicator when `corrections` is empty.
- [ ] Loading and error states, disable send while waiting, enforce 1000-char limit.

**Done when:** a full conversation works on device with corrections shown correctly for both erroneous and correct messages.

## Phase 5 - Vocabulary Quiz

- [ ] Fetch 10 questions with `POST /quiz`, send `used_words` for the session.
- [ ] Question screen: sentence with blank, 4 option buttons, immediate correct/wrong feedback with explanation, "Next".
- [ ] Running score and a result screen (e.g. 7/10) with "Play again" (which sends the accumulated `used_words`) and "Home".
- [ ] Loading and error states.

**Done when:** a full round can be played and the score is correct.

## Phase 6 - Speaking Practice

- [ ] Theme picker using the fixed speaking themes for the user's goal.
- [ ] Call `POST /speaking/prompt`; show prompt and tips.
- [ ] Mic button with permission handling, locale `en_US`, live partial text, stop button.
- [ ] Editable transcript with "Re-record" and "Submit".
- [ ] Call `POST /speaking/feedback`; feedback screen with sections: what was good, what to improve (correction cards), polished version, small scores labeled as estimates.
- [ ] Buttons: "Try again" (same prompt) and "Next prompt".
- [ ] Handle: permission denied, speech engine unavailable, empty transcript.

**Done when:** the full speaking flow works end to end on a real Android device.

## Phase 7 - Polish and release prep

- [ ] App name, icon, splash screen.
- [ ] Friendly error copy for each error code; offline handling.
- [ ] Test on at least two Android versions/devices.
- [ ] Check the backend rate limit and quota behavior when limits are hit (the app shows a clear message).
- [ ] **(owner)** Decide monetization and how to handle Gemini quota at scale.
- [ ] **(owner)** Write a privacy policy (mention that user text is processed by an AI service).
- [ ] Release build settings: signing, `flutter build appbundle`.
- [ ] **(owner)** Google Play Console listing, content rating, data safety form, closed testing.

**Done when:** a signed app bundle is ready for upload.

## Backlog (not in the MVP - do not build yet)

- Login and cloud sync
- Word tracking and spaced repetition (repeat words the user gets wrong)
- Persistent conversation history
- Pronunciation scoring with audio
- Streaks and notifications
- iOS support
- Monetization

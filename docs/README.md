# English Tutor (working title)

An Android app that helps Indonesian learners practice English with an AI tutor powered by Google Gemini. This is an **MVP**: keep everything as simple as possible.

> Read this file first, then `AGENTS.md`. Work through `TASKS.md` in order.

## Docs index

| File | Purpose |
|---|---|
| `README.md` | Product overview, decisions, fixed content (this file) |
| `AGENTS.md` | Rules the AI developer must follow |
| `ARCHITECTURE.md` | System design, folder layout, security, storage |
| `API_CONTRACT.md` | Exact request/response JSON for every backend endpoint |
| `PROMPTS.md` | Gemini system prompts and how to build them |
| `TASKS.md` | Ordered task checklist with acceptance criteria |

## Target users

Indonesian students and university students preparing for TOEFL/IELTS, up to working professionals who need English for their careers. The UI copy is bilingual-friendly; the language of explanations is a user setting.

## Platform and stack

- **Mobile:** Flutter, **Android only for now** (iOS postponed). End goal: release on Google Play Store.
- **Backend:** Python FastAPI, hosted on **Render free tier** (no credit card). The free tier sleeps after inactivity, so the first request can take 30-50 s. The app must show a friendly "Waking up the server..." state.
- **AI:** Google Gemini via the Gemini API. The API key lives **only** on the backend, never in the app.
- **Speech-to-text:** on-device engine (Flutter `speech_to_text` package). Audio is never sent to the backend.
- **Cost goal:** zero running cost except the Google Play developer fee. Use a Flash-Lite class Gemini model by default to stay within free-tier quotas.

## User setup (onboarding)

On first launch the user chooses:

1. **Goal:** `exam_prep` (TOEFL/IELTS) or `career` (work/professional).
2. **Level:** `beginner`, `intermediate`, `advanced`.
3. **Explanation language:** `id` (Indonesian) or `en` (English). Changeable later in Settings.

These three values are sent with every AI request and change the content and tone of the AI output.

## MVP features

### 1. Conversation
- Free chat in English. The AI replies naturally.
- After each user message, the AI also returns grammar **corrections** for that message. Corrections are shown as a **separate card under the AI reply bubble** (original sentence, corrected version, short explanation). If the message has no errors, show a small "No errors" indicator instead of a card.
- **Quick topic** chips are shown on an empty chat. The list is **fixed and hardcoded** per goal (see Fixed content). Tapping a chip sends it as the first message.

### 2. Vocabulary Quiz
- The AI generates fill-in-the-blank questions with a realistic sentence context, 4 options, one correct answer, and a short explanation.
- A score is shown during and at the end of a round (e.g. 7/10).
- Questions are based on the user's goal and level. To reduce repeats, the app sends the list of target words already used **in the current session**. No persistent word tracking in the MVP.

### 3. Speaking Practice
- Flow: choose a theme -> AI gives one speaking prompt -> user records their answer with the mic -> transcript appears and is **editable** (with a re-record button) -> submit -> feedback.
- Feedback contains: what was good, what to improve (with corrections), a polished version of the answer, and small scores.
- One prompt per round. Buttons: "Try again" (same prompt) and "Next prompt".

## Fixed content (hardcode in the app)

### Quick topics for Conversation

`exam_prep`:
- Education and school life
- Technology in daily life
- Environment and climate
- Health and lifestyle
- Travel and culture

`career`:
- Introducing yourself at work
- Job interview practice
- Talking to a client
- Meeting and project updates
- Writing and discussing emails

### Speaking themes

`exam_prep`:
- Describe a person you admire
- Describe a place you visited
- Opinion: technology and education
- Opinion: environmental problems

`career`:
- Tell me about yourself (interview)
- Describe a challenge at work
- Give a short project update
- Persuade a client

## Explicitly out of scope for the MVP

Do **not** build these unless the owner asks:

- Login, accounts, cloud sync
- Payments, subscriptions, ads, monetization
- Persistent word tracking or spaced repetition
- Pronunciation scoring or sending audio to Gemini
- Streaks, leaderboards, notifications
- Conversation history persistence after the app is closed
- iOS build and iOS-specific work
- Multiple correction modes (only one correction style exists)

## Assumptions (made by the planning assistant, not yet confirmed by the owner)

The owner can change any of these; ask before changing them yourself.

- Three levels only: beginner, intermediate, advanced.
- State management: `flutter_riverpod`.
- Conversation history is kept **in memory only** during a session.
- Settings (goal, level, explanation language) are stored locally with `shared_preferences`.
- Backend rate limit default: 60 AI requests per device per day (configurable by env var).
- Quiz round length: 10 questions per round.
- Speaking scores use a 0-10 scale for grammar, vocabulary, and coherence.
- Default Gemini model is set by env var `GEMINI_MODEL`; choose a current Flash-Lite model that is available on the free tier (check Google AI Studio).

## Decision log

- Audience: Indonesian students (TOEFL/IELTS) to professionals.
- Explanation language is user-selectable in Settings.
- Android first, Flutter, Play Store release is the final goal.
- Monetization is undecided; it will be decided when preparing the Play Store release.
- Speaking uses the built-in on-device speech-to-text for now.
- Vocabulary Quiz v1: AI freely generates questions from level and goal.
- Quick topics are a fixed list following the goal.
- Hosting: Render free tier, FastAPI proxy holds the Gemini key.
- Keep everything MVP-simple.

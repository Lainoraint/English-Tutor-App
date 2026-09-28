# API_CONTRACT.md

Base URL: set per environment. All endpoints accept and return JSON (`Content-Type: application/json`).

## Common

### Headers (all endpoints except `/health`)

```
X-Device-Id: <uuid>
X-App-Token: <shared token>
```

### Shared enums

| Field | Values |
|---|---|
| `goal` | `exam_prep`, `career` |
| `level` | `beginner`, `intermediate`, `advanced` |
| `explanation_language` | `id`, `en` |

### Common request fields

Every AI endpoint request includes:

```json
{
  "goal": "exam_prep",
  "level": "intermediate",
  "explanation_language": "id"
}
```

### Error response

See `ARCHITECTURE.md`. Status codes: 400, 401, 429, 502.

---

## GET /health

Response `200`:

```json
{ "status": "ok" }
```

---

## POST /chat

Send the conversation so far. The app sends only the **last 10 messages** to keep tokens small. The AI replies to the last user message and also corrects that message.

Request:

```json
{
  "goal": "exam_prep",
  "level": "intermediate",
  "explanation_language": "id",
  "messages": [
    { "role": "user", "text": "Hello, I want talk about my school." },
    { "role": "assistant", "text": "Sure! What would you like to share about your school?" },
    { "role": "user", "text": "Yesterday I go to school and take a exam." }
  ]
}
```

- `role`: `user` or `assistant`.
- `messages`: 1 to 10 items, last item must be `user`.
- `text`: max 1000 characters.

Response `200`:

```json
{
  "reply": "That sounds stressful! How did the exam go?",
  "corrections": [
    {
      "original": "Yesterday I go to school and take a exam.",
      "fixed": "Yesterday I went to school and took an exam.",
      "explanation": "Gunakan past tense (went, took) karena kejadiannya kemarin. Gunakan 'an' sebelum kata berawalan vokal (an exam)."
    }
  ]
}
```

- `reply`: natural English reply, always in English, matched to the user's level.
- `corrections`: empty array `[]` if the last user message has no errors. Otherwise one item per corrected sentence (max 3). `explanation` is written in `explanation_language`.

---

## POST /quiz

Generate a batch of fill-in-the-blank questions.

Request:

```json
{
  "goal": "career",
  "level": "beginner",
  "explanation_language": "id",
  "count": 10,
  "used_words": ["deadline", "schedule"]
}
```

- `count`: 1 to 10 (default 10).
- `used_words`: target words already used in this session (may be empty). The AI must not reuse them.

Response `200`:

```json
{
  "questions": [
    {
      "target_word": "postpone",
      "sentence": "We had to ____ the meeting because the manager was sick.",
      "options": ["postpone", "improve", "borrow", "arrive"],
      "correct_index": 0,
      "explanation": "'Postpone' artinya menunda ke waktu yang lain."
    }
  ]
}
```

Rules (validate on the backend):
- Exactly `count` questions.
- `sentence` contains exactly one blank written as `____`.
- `options` has exactly 4 distinct items; `correct_index` is 0-3.
- The correct option is the `target_word` in the form that fits the blank.
- `target_word` values are unique and not in `used_words`.
- `explanation` is in `explanation_language`.
- The app shuffles nothing itself: the backend/AI should already vary the position of the correct answer.

Scoring is done in the app (count of correct answers). No score is sent to the backend.

---

## POST /speaking/prompt

Generate one speaking prompt for the chosen theme.

Request:

```json
{
  "goal": "exam_prep",
  "level": "intermediate",
  "explanation_language": "id",
  "theme": "Describe a place you visited"
}
```

- `theme`: one of the fixed speaking themes from `README.md` (free text up to 100 chars).

Response `200`:

```json
{
  "prompt": "Describe a place you visited that left a strong impression on you. You should say where it was, when you went there, what you did, and explain why it was memorable.",
  "tips": [
    "Use past tense to describe your trip.",
    "Try to speak for about one minute."
  ]
}
```

- `prompt`: English only.
- `tips`: 1-2 short tips in `explanation_language`.

---

## POST /speaking/feedback

Evaluate the transcript of the user's spoken answer.

Request:

```json
{
  "goal": "exam_prep",
  "level": "intermediate",
  "explanation_language": "id",
  "theme": "Describe a place you visited",
  "prompt": "Describe a place you visited that left a strong impression on you...",
  "transcript": "Last year I go to Bali with my family. It is very beautiful and I like the beach."
}
```

- `transcript`: 1 to 1500 characters, comes from on-device speech-to-text and may contain recognition errors. The AI should not penalize obvious speech-recognition artifacts (punctuation, capitalization).

Response `200`:

```json
{
  "good": [
    "You clearly answered the question and gave a personal detail (family trip).",
    "Good use of simple, clear sentences."
  ],
  "improve": [
    {
      "original": "Last year I go to Bali with my family.",
      "fixed": "Last year I went to Bali with my family.",
      "explanation": "Kejadian tahun lalu memakai past tense: 'went'."
    }
  ],
  "polished": "Last year, I went to Bali with my family. It was absolutely beautiful, and I especially enjoyed the beach.",
  "scores": { "grammar": 6, "vocabulary": 6, "coherence": 7 }
}
```

- `good`: 1-3 short items in `explanation_language`.
- `improve`: 0-4 items (`original`, `fixed`, `explanation` in `explanation_language`).
- `polished`: an improved version of the user's answer in natural English, keeping the user's meaning and roughly the same length; suited to the level.
- `scores`: integers 0-10. These are rough estimates and the UI should label them as such.

---

## Pydantic model hints (backend)

```python
class Correction(BaseModel):
    original: str
    fixed: str
    explanation: str

class ChatResponse(BaseModel):
    reply: str
    corrections: list[Correction]

class QuizQuestion(BaseModel):
    target_word: str
    sentence: str
    options: list[str]      # exactly 4
    correct_index: int      # 0..3
    explanation: str

class QuizResponse(BaseModel):
    questions: list[QuizQuestion]

class SpeakingPromptResponse(BaseModel):
    prompt: str
    tips: list[str]

class Scores(BaseModel):
    grammar: int
    vocabulary: int
    coherence: int

class SpeakingFeedbackResponse(BaseModel):
    good: list[str]
    improve: list[Correction]
    polished: str
    scores: Scores
```

Add validators for the quiz rules above.

from pydantic import BaseModel, Field, model_validator
from typing import List
from enum import Enum

class Goal(str, Enum):
    EXAM_PREP = "exam_prep"
    CAREER = "career"

class Level(str, Enum):
    BEGINNER = "beginner"
    INTERMEDIATE = "intermediate"
    ADVANCED = "advanced"

class ExplanationLanguage(str, Enum):
    ID = "id"
    EN = "en"

class BaseAIRequest(BaseModel):
    goal: Goal
    level: Level
    explanation_language: ExplanationLanguage

class Message(BaseModel):
    role: str
    text: str = Field(..., max_length=1000)

class ChatRequest(BaseAIRequest):
    messages: List[Message] = Field(..., min_length=1, max_length=10)

class Correction(BaseModel):
    original: str
    fixed: str
    explanation: str

class ChatResponse(BaseModel):
    reply: str
    corrections: List[Correction]

class QuizRequest(BaseAIRequest):
    count: int = Field(default=10, ge=1, le=10)
    used_words: List[str] = Field(default_factory=list)

class QuizQuestion(BaseModel):
    target_word: str
    sentence: str
    options: List[str]      # exactly 4
    correct_index: int      # 0..3
    explanation: str

class QuizResponse(BaseModel):
    questions: List[QuizQuestion]

    @model_validator(mode='after')
    def validate_quiz(self) -> 'QuizResponse':
        for q in self.questions:
            if len(q.options) != 4:
                raise ValueError("Each question must have exactly 4 options.")
            if not (0 <= q.correct_index <= 3):
                raise ValueError("correct_index must be between 0 and 3.")
            if q.sentence.count("____") != 1:
                raise ValueError("sentence must contain exactly one blank '____'.")
        return self

class SpeakingPromptRequest(BaseAIRequest):
    theme: str = Field(..., max_length=100)

class SpeakingPromptResponse(BaseModel):
    prompt: str
    tips: List[str]

class SpeakingFeedbackRequest(BaseAIRequest):
    theme: str
    prompt: str
    transcript: str = Field(..., min_length=1, max_length=1500)

class Scores(BaseModel):
    grammar: int = Field(..., ge=0, le=10)
    vocabulary: int = Field(..., ge=0, le=10)
    coherence: int = Field(..., ge=0, le=10)

class SpeakingFeedbackResponse(BaseModel):
    good: List[str]
    improve: List[Correction]
    polished: str
    scores: Scores

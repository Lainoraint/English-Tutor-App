from fastapi import APIRouter, Depends
from ..models import QuizRequest, QuizResponse
from ..prompts import build_quiz_prompt
from ..gemini import call_gemini
from ..dependencies import verify_request

router = APIRouter(prefix="/quiz", dependencies=[Depends(verify_request)])

@router.post("", response_model=QuizResponse)
async def quiz_endpoint(req: QuizRequest):
    sys_inst = build_quiz_prompt(
        req.level, req.goal, req.explanation_language, req.count, req.used_words
    )
    
    return call_gemini(
        system_instruction=sys_inst,
        user_content="Generate the quiz now.",
        response_model=QuizResponse,
        temperature=0.4
    )

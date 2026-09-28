from fastapi import APIRouter, Depends
from ..models import SpeakingPromptRequest, SpeakingPromptResponse, SpeakingFeedbackRequest, SpeakingFeedbackResponse
from ..prompts import build_speaking_prompt, build_speaking_feedback_prompt
from ..gemini import call_gemini
from ..dependencies import verify_request

router = APIRouter(prefix="/speaking", dependencies=[Depends(verify_request)])

@router.post("/prompt", response_model=SpeakingPromptResponse)
async def speaking_prompt_endpoint(req: SpeakingPromptRequest):
    sys_inst = build_speaking_prompt(req.level, req.goal, req.explanation_language, req.theme)
    
    return call_gemini(
        system_instruction=sys_inst,
        user_content="Generate the speaking prompt.",
        response_model=SpeakingPromptResponse,
        temperature=0.7
    )

@router.post("/feedback", response_model=SpeakingFeedbackResponse)
async def speaking_feedback_endpoint(req: SpeakingFeedbackRequest):
    sys_inst = build_speaking_feedback_prompt(req.level, req.goal, req.explanation_language, req.prompt)
    
    return call_gemini(
        system_instruction=sys_inst,
        user_content=f"Transcript:\n{req.transcript}",
        response_model=SpeakingFeedbackResponse,
        temperature=0.4
    )

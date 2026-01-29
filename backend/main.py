from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import google.genai as genai
import os
from dotenv import load_dotenv
from datetime import datetime

load_dotenv()

app = FastAPI(title="MediHora IA API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Cliente Gemini
client = genai.Client(api_key=os.getenv("GOOGLE_API_KEY"))

SYSTEM_PROMPT = """
És um assistente de saúde virtual especializado em medicação e consultas médicas.

Regras importantes:
1. Sempre alerta que NÃO substituis um médico
2. Em caso de emergência, recomenda ligar 112 ou SNS 24 (808 24 24 24)
3. Não diagnostiques doenças - sugere consultar um profissional
4. Dá informações gerais sobre medicamentos (posologia, efeitos secundários comuns)
5. Sê claro, conciso e empático
6. Se não souberes algo, admite e sugere consultar um médico

És português e usas português de Portugal.
"""

class PerguntaRequest(BaseModel):
    pergunta: str
    contexto: str = ""

class RespostaResponse(BaseModel):
    resposta: str
    timestamp: str

@app.get("/")
async def root():
    return {
        "message": "MediHora IA API (Google Gemini 2.5)",
        "status": "online",
        "version": "1.0.0"
    }

@app.post("/chat", response_model=RespostaResponse)
async def chat(request: PerguntaRequest):
    try:
        prompt = f"{SYSTEM_PROMPT}\n\n"
        
        if request.contexto:
            prompt += f"Contexto do utilizador: {request.contexto}\n\n"
        
        prompt += f"Utilizador: {request.pergunta}\n\nAssistente:"
        
        # Usa Gemini 2.5 Flash (mais recente!)
        response = client.models.generate_content(
            model='models/gemini-2.5-flash',
            contents=prompt
        )
        
        return RespostaResponse(
            resposta=response.text,
            timestamp=datetime.now().isoformat()
        )
        
    except Exception as e:
        print(f"ERRO: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/health")
async def health_check():
    return {"status": "healthy", "model": "gemini-2.5-flash"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
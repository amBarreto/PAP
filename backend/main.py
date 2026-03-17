from fastapi import FastAPI, HTTPException #criar API
from fastapi.middleware.cors import CORSMiddleware #flutter com API
from pydantic import BaseModel #confirmaçao de dados
import google.genai as genai
import os #venv
from dotenv import load_dotenv
from datetime import datetime

load_dotenv()

app = FastAPI(title="MediHora IA API")

#CORS cross origin resource sharing
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
És um assistente de saúde especializado em medicamentos.
Dá informações precisas, claras e concisas.
Sempre alerta que não substituis um médico.
Em caso de dúvidas, recomenda consultar um profissional de saúde.
Usa português de Portugal.
"""
PROMPTS = {
    
   "para_que_serve": """
Explica para que serve o medicamento {medicamento}.
Sê breve e objetivo. Máximo 150 palavras.
Formato:
- Lista os usos principais
- Menciona indicações terapêuticas
""",

    "como_tomar": """
Explica como tomar o medicamento {medicamento}.
Inclui:
- Dose habitual para adultos
- Frequência (de quantas em quantas horas)
- Com ou sem alimentos
- Duração típica do tratamento
Máximo 150 palavras.
""",

    "efeitos_secundarios": """
Lista os efeitos secundários mais comuns do medicamento {medicamento}.
Organiza por:
- Frequentes (mais de 10%)
- Pouco frequentes (1-10%)
- Raros (menos de 1%)
Máximo 150 palavras.
""",

    "contraindicacoes": """
Lista as contraindicações do medicamento {medicamento}.
Inclui:
- Quem NÃO deve tomar
- Condições de saúde que impedem o uso
- Situações especiais (gravidez, amamentação)
Máximo 150 palavras.
""",
    
    "interacoes": """
Lista as principais interações medicamentosas do {medicamento}.
Inclui:
- Medicamentos que NÃO devem ser tomados juntos
- Alimentos/bebidas a evitar
- Suplementos que podem interferir
Máximo 150 palavras.
""",
}

class MedicamentoRequest(BaseModel):
    medicamento: str 
    tipo_consulta: str 

class RespostaResponse(BaseModel):
    resposta: str 
    medicamento: str 
    tipo_consulta: str 
    timestamp: str

@app.get("/")
async def root():
    return {
        "message": "MediHora IA API (Google Gemini 2.5)",
        "status": "online",
        "version": "1.0.0",
        "endpoints": {
            "/medicamento": "POST - Obter informações sobre medicamentos",
            "/health": "GET - Verificar estado da API"
        }
    }

@app.post("/medicamento", response_model=RespostaResponse)
async def consultar_medicamento(request: MedicamentoRequest):
    try:
        #Valida tipo de consulta
        if request.tipo_consulta not in PROMPTS:
            raise HTTPException(
                status_code=400,
                detail=f"Tipo de consulta inválido. Opções: {','.join(PROMPTS.keys())}"
            )
        
        prompt_template = PROMPTS[request.tipo_consulta]
        prompt = f"{SYSTEM_PROMPT}\n\n{prompt_template.format(medicamento=request.medicamento)}"
           

        # Usa Gemini 2.0 Flash (mais recente!)
        response = client.models.generate_content(
            model='gemini-2.5-flash-preview-04-17',
            contents=prompt 
        )
        
        return RespostaResponse(
            resposta=response.text,
            medicamento=request.medicamento,
            tipo_consulta=request.tipo_consulta,
            timestamp=datetime.now().isoformat()
        )
    except HTTPException: 
        raise
    except Exception as e:
        print(f"ERRO: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

# Health check endpoint
@app.get("/health") 
async def health_check():
    return {"status": "healthy", 
    "model": "gemini-2.5-flash-preview-04-17",
    "timestamp": datetime.now().isoformat()
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
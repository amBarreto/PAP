# 💊 MediHora

MediHora é uma aplicação móvel desenvolvida em Flutter com o objetivo de auxiliar na gestão de medicação, permitindo registar, visualizar e organizar tomas de medicamentos de forma simples e intuitiva.

Este projeto foi desenvolvido no âmbito da PAP (Prova de Aptidão Profissional).

---

## 🎯 Objetivo da Aplicação âmbito da **PAP**

A aplicação permite ao utilizador:
- Registar medicamentos associados a um utente;
- Definir a hora da toma;
- Selecionar os dias da semana;
- Indicar se a medicação é **permanente** ou **temporária**;
- Visualizar e remover medicações registadas;
- Alternar entre **modo claro e modo escuro**;

---

## 🧩 Funcionalidades Principais

- 📋 Registo de medicação;
- 👤 Associação a um utente;
- ⏰ Definição da hora da toma;
- ⏰ Alarmes 
- 📅 Seleção de dias da semana;
- ♾️ Opção de medicação permanente (sem período);
- 📆 Medicação temporária com período definido;
- 🔁 Medicação recorrente com intervalo definido (ex.: de 8 em 8 horas);
- 🌓 Tema claro / escuro;
- 🗑️ Remoção de registos;
- 📱 Interface simples e responsiva;

---

## 🛠️ Tecnologias Utilizadas

## Frontend (Flutter)

- **Framework:** Flutter/Dart
- **Base de dados:** Isar (NoSQL local)
- **Notificações:** flutter_local_notifications
- **HTTP:** package http

## Backend (Python)

- **Framework:** FastAPI
- **IA:** Google Gemini 2.5 Flash
- **Deploy:** Render (plano Free)
- **Autenticação:** API Key (variável de ambiente)
---

## Arquitetura da App

````
┌─────────────────┐
│  Flutter App    │ ← Interface (Android/iOS)
│  (Frontend)     │
└────────┬────────┘
         │ HTTP POST/GET
         ↓
┌─────────────────┐
│  Render         │ ← Servidor (24/7 online)
│  (Hosting)      │
└────────┬────────┘
         │
         ↓
┌─────────────────┐
│  main.py        │ ← Backend Python (FastAPI)
│  (API)          │
└────────┬────────┘
         │ API Call
         ↓
┌─────────────────┐
│  Google Gemini  │ ← IA (respostas de saúde)
│  API            │
└─────────────────┘

## 📂 Estrutura do Projeto

```text
MediHora/
|
├── backend/                                    # Backend Python (Google Gemini API)
│   ├── venv/                                   # Ambiente virtual Python
│   ├── main.py                                 # API FastAPI (endpoints /chat, /health)
│   ├── .env                                    # Chave da Google Gemini API
│   ├── requirements.txt                        # Dependências Python
│   └── .gitignore                              # Ignora venv e .env
│
├── lib/
│   ├── main.dart                               # Entrada principal, configuração Isar, tema claro/escuro
│   ├── home_page.dart                          # Navegação com Bottom Navigation (Consultas, Medicamentos, IA Chat)
│   ├── drawer.dart                             # Menu lateral (modo escuro, alarmes, linha SNS 24, SOS)
│   │
│   ├── models/
│   │   ├── medicamento.dart                    # Modelo Medicamento (nome, dosagem, hora, dias, recorrente, ativo)
│   │   ├── medicamento.g.dart                  # Gerado pelo Isar (build_runner)
│   │   ├── consulta.dart                       # Modelo Consulta (utente, médico, especialidade, data, notificações)
│   │   ├── consulta.g.dart                     # Gerado pelo Isar (build_runner)
│   │   └── mensagem.dart                       # Modelo Mensagem (texto, isUser, timestamp) - Chat IA
│   │
│   ├── services/
│   │   ├── notification_service.dart           # Serviço de notificações (agendar, cancelar, permissões)
│   │   └── ia_service.dart                     # Comunicação com backend Python (POST /chat, GET /health)
│   │
│   ├── pages/
│   │   ├── consultas_page.dart                 # Gestão de consultas (adicionar, editar, remover, notificações)
│   │   ├── chat_ia_page.dart                   # Chat com IA (Google Gemini, Markdown, modo escuro)
│   │   └── sos_page.dart                       # Modo emergência (112, SNS 24, info medicamentos/consultas)
│   │
│   └── widgets/
│       └── time_numpad.dart                    # Teclado numérico personalizado para hora
│
├── android/                                    # Configuração Android
├── ios/                                        # Configuração iOS
│
├── pubspec.yaml                                # Dependências Flutter
├── .gitignore                                  # Ignora arquivos gerados e sensíveis
└── README.md                                   # Documentação do projeto



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

- **Flutter**
- **Dart**
- **Material Design**
- **ISAR Database** – persistência local 
- **Git & GitHub** - para controlo de versões

---

## 📂 Estrutura do Projeto

```text
lib/
 ├── main.dart                           # Entrada principal da aplicação
 ├── models/
 │    ├── medicamento.dart               # Modelo de dados Medicamento (utente, medicamento, dosagem, hora, dias da semana, recorrente, permanente, período)
 │    └── medicamento.g.dart             # Ficheiro gerado automaticamente pelo Isar para persistência local
 ├── services/
 │    └── notification_service.dart      # Serviço de notificações e alarmes (agendamento, cancelamento, permissões)
 └── drawer.dart                         # Drawer com tema claro/escuro, ver alarmes agendados, linha de apoio SNS 24

pubspec.yaml                             # Dependências (isar, flutter_local_notifications, timezone, permission_handler, path_provider)
README.md                                # Documentação do projeto


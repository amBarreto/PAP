# 💊 MediHora

MediHora é uma aplicação móvel desenvolvida em Flutter com o objetivo de auxiliar na gestão de medicação, permitindo registar, visualizar e organizar tomas de medicamentos de forma simples e intuitiva.

Este projeto foi desenvolvido no âmbito da PAP (Prova de Aptidão Profissional).

---

## 🎯 Objetivo da Aplicaçãoâmbito da **PAP

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
- ⏰ Alarmes *(em desenvolvimento, incluindo recorrência)*;
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
- **ISAR Database** – persistência local *(em fase de testes)*
- **Git & GitHub** - para controlo de versões

---

## 📂 Estrutura do Projeto

```text
lib/
 ├── main.dart                           # Entrada principal da aplicação
 ├── models/
 │    ├── medicamento.dart               # Modelo de dados Medicamento (com campos recorrente, permanente, período)
 │    └── medicamento.g.dart             # Ficheiro gerado automaticamente pelo Isar para persistência local
 ├── theme_drawer.dart                   # Drawer com seleção de tema claro/escuro
 └── ...                                 # Outros widgets e páginas
pubspec.yaml                             # Dependências e configuração do projeto
README.md                                # Documentação do projeto



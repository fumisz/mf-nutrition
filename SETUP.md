# MF Nutrition — Guia de instalação (passo a passo)

App de acompanhamento alimentar para você (treinador) e seus alunos.
Tudo **100% gratuito**: GitHub Pages (hospedagem) + Supabase (login, banco e fotos, plano free).

---

## Visão geral (5 passos)

1. Criar projeto no Supabase (grátis)
2. Rodar o `schema.sql` (cria o banco)
3. Desligar confirmação de e-mail (opcional, recomendado p/ facilitar)
4. Colar suas chaves em `config.js`
5. Publicar no GitHub Pages

---

## 1) Criar projeto no Supabase

1. Acesse **https://supabase.com** → **Start your project** → entre com o GitHub/Google.
2. **New project**. Dê um nome (ex: `mf-nutrition`), crie uma senha de banco
   (guarde-a) e escolha a região **South America (São Paulo)**.
3. Espere ~2 minutos até o projeto ficar pronto.

## 2) Rodar o schema (cria as tabelas)

1. No menu lateral do Supabase: **SQL Editor** → **New query**.
2. Abra o arquivo `schema.sql` (que está nesta pasta), copie **tudo** e cole no editor.
3. Clique **Run** (canto inferior direito). Deve aparecer *Success*.
   - Pode rodar de novo quando quiser; é seguro.

## 3) Desligar confirmação de e-mail (recomendado)

Assim seus alunos entram na hora, sem precisar confirmar e-mail.

1. Menu lateral: **Authentication** → **Sign In / Providers** (ou **Providers**).
2. Em **Email**, **desligue** a opção *Confirm email* e salve.
   - Se preferir manter ligado, tudo bem — só avise os alunos para confirmarem
     pelo e-mail antes do primeiro login.

## 4) Pegar suas chaves e colar no app

1. Menu lateral: **Project Settings** (engrenagem) → **API**.
2. Copie:
   - **Project URL** (ex: `https://abcd1234.supabase.co`)
   - **anon public** (a chave longa em *Project API keys*)
3. Abra o arquivo **`config.js`** desta pasta e preencha:

```js
window.MFN_CONFIG = {
  SUPABASE_URL: "https://abcd1234.supabase.co",
  SUPABASE_ANON_KEY: "eyJhbGciOi....(chave anon)"
};
```

> A chave **anon** é pública por natureza — pode ir pro GitHub sem problema.
> A segurança fica nas regras (RLS) que o `schema.sql` já configurou.

## 5) Testar localmente (opcional)

No Windows, dentro da pasta:

```powershell
powershell -ExecutionPolicy Bypass -File serve.ps1
```

Abra **http://localhost:5500**. Crie uma conta como **treinador**,
veja seu código, depois crie outra conta como **aluno** usando esse código.

## 6) Publicar no GitHub Pages

1. Crie um repositório no GitHub (ex: `mf-nutrition`) e suba todos os arquivos
   desta pasta **exceto** `serve.ps1` (opcional ignorar).
2. No repositório: **Settings** → **Pages** → *Branch: main / root* → **Save**.
3. Em ~1 minuto o app fica em `https://SEU-USUARIO.github.io/mf-nutrition/`.
4. **Importante:** no Supabase, em **Authentication → URL Configuration**, adicione
   essa URL em *Site URL* / *Redirect URLs*.

---

## Como funciona o fluxo

- **Você (treinador):** cria conta como *treinador* → recebe um **código** (ex: `A1B2C3`).
  Compartilha o código por WhatsApp.
- **Aluno:** cria conta como *aluno*, digita seu código → fica vinculado a você.
- Você monta o **plano alimentar** dele (refeições, alimentos, kcal, macros e
  substituições). O aluno vê no celular, **dá check** em cada refeição, acompanha
  **kcal/macros/água**, registra **cardio** e **peso**, manda **fotos** e conversa
  com você pelo **chat**.

## Funcionalidades

**Aluno**
- 🍽️ Plano do dia com check por refeição
- 🔥 Contador de kcal + macros (proteína/carbo/gordura) consumidos vs meta
- 💧 Controle de água
- 🔄 Tabela de substituições
- 🏃 Registro de cardio (tipo, duração, calorias)
- 📈 Progresso: peso (com gráfico) e fotos
- 📷 Envio de foto da refeição direto pro treinador
- 💬 Chat com o treinador

**Treinador**
- 👥 Lista de alunos
- 🍽️ Editor de plano (refeições, alimentos, macros, substituições)
- 📊 Registros do aluno: aderência, fotos, cardio, peso
- 💬 Chat com cada aluno
- 🔗 Código de convite para vincular alunos

---

## Dúvidas comuns

- **"Falta configurar o Supabase"** na tela → preencha o `config.js` (passo 4).
- **Aluno não vincula / código inválido** → confira se digitou o código certo
  (maiúsculas) e se você criou a conta como *treinador*.
- **Foto não envia** → confirme que o `schema.sql` rodou por completo (ele cria o
  bucket `photos`).
- **Não chega o login** → desligue *Confirm email* (passo 3).

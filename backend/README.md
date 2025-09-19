# Backend PET Saúde

## 📋 Descrição
Backend API para sistema PET Saúde que conecta Flutter Web com MySQL.

## 🚀 Como executar

### 1. Instalar dependências
```bash
cd backend
npm install
```

### 2. Executar servidor
```bash
npm start
```

### 3. Testar API
Acesse: http://localhost:3000

## 📡 Endpoints da API

### Base URL: `http://localhost:3000`

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| GET | `/` | Teste da API |
| POST | `/api/create-table` | Criar tabela no MySQL |
| POST | `/api/cadastros` | Inserir novo paciente |
| GET | `/api/cadastros` | Listar todos os pacientes |
| GET | `/api/cadastros/:cpf` | Buscar paciente por CPF |
| PUT | `/api/cadastros/:cpf` | Atualizar paciente |
| DELETE | `/api/cadastros/:cpf` | Deletar paciente |
| GET | `/api/cadastros/count` | Contar total de pacientes |
| GET | `/api/cadastros/search/:nome` | Buscar pacientes por nome |

## 🔧 Configuração MySQL
- Host: 127.0.0.1
- Porta: 3036
- Usuário: root
- Senha: 123456
- Banco: PET-TEC

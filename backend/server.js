// Backend API para sistema PET Saúde
// server.js: Servidor principal que conecta Flutter Web com MySQL
// Usa Express.js para criar API REST
// Conecta com MySQL usando mysql2

const express = require('express'); // Framework web para Node.js
const mysql = require('mysql2/promise'); // Driver MySQL para Node.js
const cors = require('cors'); // Middleware para CORS (permitir requisições do Flutter)
const bodyParser = require('body-parser'); // Middleware para parsear JSON

const app = express(); // Cria instância do Express
const PORT = 3000; // Porta do servidor (3000)

// Configuração do banco de dados MySQL
const dbConfig = {
  host: '127.0.0.1', // Endereço do MySQL
  port: 3306, // Porta do MySQL (sua configuração)
  user: 'root', // Usuário do MySQL
  password: '123456', // Senha do MySQL
  database: 'pet_tec', // Nome do banco
  waitForConnections: true, // Aguarda conexões disponíveis
  connectionLimit: 10, // Máximo 10 conexões simultâneas
  queueLimit: 0 // Sem limite na fila
};

// Cria pool de conexões com MySQL
const pool = mysql.createPool(dbConfig);

// Middlewares (funcionalidades que executam antes das rotas)
app.use(cors()); // Permite requisições de qualquer origem (Flutter web)
app.use(bodyParser.json()); // Converte JSON para objeto JavaScript
app.use(bodyParser.urlencoded({ extended: true })); // Converte form data

// Rota de teste para verificar se API está funcionando
app.get('/', (req, res) => {
  res.json({ 
    message: 'API PET Saúde funcionando!', 
    status: 'online',
    timestamp: new Date().toISOString()
  });
});

// Rota para criar tabela no banco
app.post('/api/create-table', async (req, res) => {
  try {
    const connection = await pool.getConnection(); // Obtém conexão do pool
    
    // Query para criar tabela cadastro
    const createTableQuery = `
      CREATE TABLE IF NOT EXISTS cadastro (
        cpf VARCHAR(14) PRIMARY KEY,
        nome_completo VARCHAR(255) NOT NULL,
        data_nascimento DATE NOT NULL,
        sexo ENUM('M', 'F') NOT NULL,
        telefone VARCHAR(20) NOT NULL,
        quarto_leito VARCHAR(50) NOT NULL,
        queixa_principal TEXT NOT NULL,
        observacoes TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
      )
    `;
    
    await connection.execute(createTableQuery); // Executa query
    connection.release(); // Libera conexão
    
    res.json({ success: true, message: 'Tabela criada com sucesso!' });
  } catch (error) {
    console.error('Erro ao criar tabela:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Rota para inserir novo paciente
app.post('/api/cadastros', async (req, res) => {
  try {
    const { cpf, nomeCompleto, dataNascimento, sexo, telefone, quartoLeito, queixaPrincipal, observacoes } = req.body;
    
    const connection = await pool.getConnection(); // Obtém conexão
    
    // Query para inserir paciente
    const insertQuery = `
      INSERT INTO cadastro (cpf, nome_completo, data_nascimento, sexo, telefone, quarto_leito, queixa_principal, observacoes)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    `;
    
    await connection.execute(insertQuery, [
      cpf, nomeCompleto, dataNascimento, sexo, telefone, quartoLeito, queixaPrincipal, observacoes
    ]);
    
    connection.release(); // Libera conexão
    res.json({ success: true, message: 'Paciente cadastrado com sucesso!' });
  } catch (error) {
    console.error('Erro ao inserir paciente:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Rota para buscar todos os pacientes
app.get('/api/cadastros', async (req, res) => {
  try {
    const connection = await pool.getConnection(); // Obtém conexão
    
    // Query para buscar todos os pacientes
    const selectQuery = `
      SELECT cpf, nome_completo, data_nascimento, sexo, telefone, quarto_leito, 
             queixa_principal, observacoes, created_at, updated_at
      FROM cadastro 
      ORDER BY created_at DESC
    `;
    
    const [rows] = await connection.execute(selectQuery); // Executa query
    connection.release(); // Libera conexão
    
    res.json({ success: true, data: rows });
  } catch (error) {
    console.error('Erro ao buscar pacientes:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Rota para buscar paciente por CPF
app.get('/api/cadastros/:cpf', async (req, res) => {
  try {
    const { cpf } = req.params; // Pega CPF da URL
    
    const connection = await pool.getConnection(); // Obtém conexão
    
    // Query para buscar paciente específico
    const selectQuery = `
      SELECT cpf, nome_completo, data_nascimento, sexo, telefone, quarto_leito, 
             queixa_principal, observacoes, created_at, updated_at
      FROM cadastro 
      WHERE cpf = ?
    `;
    
    const [rows] = await connection.execute(selectQuery, [cpf]); // Executa query
    connection.release(); // Libera conexão
    
    if (rows.length > 0) {
      res.json({ success: true, data: rows[0] });
    } else {
      res.status(404).json({ success: false, message: 'Paciente não encontrado' });
    }
  } catch (error) {
    console.error('Erro ao buscar paciente:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Rota para atualizar paciente
app.put('/api/cadastros/:cpf', async (req, res) => {
  try {
    const { cpf } = req.params; // Pega CPF da URL
    const { nomeCompleto, dataNascimento, sexo, telefone, quartoLeito, queixaPrincipal, observacoes } = req.body;
    
    const connection = await pool.getConnection(); // Obtém conexão
    
    // Query para atualizar paciente
    const updateQuery = `
      UPDATE cadastro SET 
        nome_completo = ?, data_nascimento = ?, sexo = ?, telefone = ?, 
        quarto_leito = ?, queixa_principal = ?, observacoes = ?
      WHERE cpf = ?
    `;
    
    await connection.execute(updateQuery, [
      nomeCompleto, dataNascimento, sexo, telefone, quartoLeito, queixaPrincipal, observacoes, cpf
    ]);
    
    connection.release(); // Libera conexão
    res.json({ success: true, message: 'Paciente atualizado com sucesso!' });
  } catch (error) {
    console.error('Erro ao atualizar paciente:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Rota para deletar paciente
app.delete('/api/cadastros/:cpf', async (req, res) => {
  try {
    const { cpf } = req.params; // Pega CPF da URL
    
    const connection = await pool.getConnection(); // Obtém conexão
    
    // Query para deletar paciente
    const deleteQuery = `DELETE FROM cadastro WHERE cpf = ?`;
    
    await connection.execute(deleteQuery, [cpf]); // Executa query
    connection.release(); // Libera conexão
    
    res.json({ success: true, message: 'Paciente deletado com sucesso!' });
  } catch (error) {
    console.error('Erro ao deletar paciente:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Rota para contar total de pacientes
app.get('/api/cadastros/count', async (req, res) => {
  try {
    const connection = await pool.getConnection(); // Obtém conexão
    
    // Query para contar pacientes
    const countQuery = `SELECT COUNT(*) as total FROM cadastro`;
    
    const [rows] = await connection.execute(countQuery); // Executa query
    connection.release(); // Libera conexão
    
    res.json({ success: true, total: rows[0].total });
  } catch (error) {
    console.error('Erro ao contar pacientes:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Rota para buscar pacientes por nome
app.get('/api/cadastros/search/:nome', async (req, res) => {
  try {
    const { nome } = req.params; // Pega nome da URL
    
    const connection = await pool.getConnection(); // Obtém conexão
    
    // Query para buscar por nome
    const searchQuery = `
      SELECT cpf, nome_completo, data_nascimento, sexo, telefone, quarto_leito, 
             queixa_principal, observacoes, created_at, updated_at
      FROM cadastro 
      WHERE nome_completo LIKE ?
      ORDER BY nome_completo ASC
    `;
    
    const [rows] = await connection.execute(searchQuery, [`%${nome}%`]); // Executa query
    connection.release(); // Libera conexão
    
    res.json({ success: true, data: rows });
  } catch (error) {
    console.error('Erro ao buscar por nome:', error);
    res.status(500).json({ success: false, error: error.message });
  }
});

// Inicia o servidor
app.listen(PORT, () => {
  console.log(`🚀 Servidor rodando em http://localhost:${PORT}`);
  console.log(`📊 API PET Saúde conectada ao MySQL`);
  console.log(`🌐 Pronto para receber requisições do Flutter Web`);
});

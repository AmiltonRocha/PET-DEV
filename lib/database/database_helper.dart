// Esta pasta contém a configuração e operações do banco de dados
// database_helper.dart: Classe principal para gerenciar operações do banco
// Implementa métodos CRUD (Create, Read, Update, Delete) via API HTTP
// Centraliza todas as operações de banco de dados da aplicação

import 'dart:convert'; // Biblioteca para converter JSON
import 'package:http/http.dart' as http; // Biblioteca para requisições HTTP
import '../models/cadastro_model.dart'; // Importa o modelo de dados

// Classe principal para gerenciar operações do banco de dados via API
class DatabaseHelper {
  // URL base da API (servidor Node.js)
  static const String baseUrl = 'http://localhost:3000'; // Endereço do backend
  
  // Headers padrão para requisições HTTP
  static const Map<String, String> headers = {
    'Content-Type': 'application/json', // Tipo de conteúdo JSON
    'Accept': 'application/json', // Aceita resposta JSON
  };

  // Método para criar a tabela no banco via API
  static Future<bool> createTable() async {
    try { // Tenta executar
      final response = await http.post( // Faz requisição POST
        Uri.parse('$baseUrl/api/create-table'), // URL da API
        headers: headers, // Headers da requisição
      );
      
      if (response.statusCode == 200) { // Se sucesso (200 OK)
        final data = json.decode(response.body); // Converte JSON para objeto
        return data['success'] == true; // Retorna se foi bem-sucedido
      }
      return false; // Falha
    } catch (e) { // Se der erro
      print('Erro ao criar tabela: $e'); // Mostra o erro
      return false; // Falha
    }
  }

  // Método para inserir um novo paciente via API
  static Future<bool> insertCadastro(CadastroModel cadastro) async {
    try { // Tenta executar
      final response = await http.post( // Faz requisição POST
        Uri.parse('$baseUrl/api/cadastros'), // URL da API
        headers: headers, // Headers da requisição
        body: json.encode({ // Converte objeto para JSON
          'cpf': cadastro.cpf, // CPF do paciente
          'nomeCompleto': cadastro.nomeCompleto, // Nome completo
          'dataNascimento': cadastro.dataNascimento.toIso8601String().split('T')[0], // Data (YYYY-MM-DD)
          'sexo': cadastro.sexo, // Sexo (M ou F)
          'telefone': cadastro.telefone, // Telefone
          'quartoLeito': cadastro.quartoLeito, // Quarto/leito
          'queixaPrincipal': cadastro.queixaPrincipal, // Queixa principal
          'observacoes': cadastro.observacoes, // Observações
        }),
      );
      
      if (response.statusCode == 200) { // Se sucesso
        final data = json.decode(response.body); // Converte JSON
        return data['success'] == true; // Retorna se foi bem-sucedido
      }
      return false; // Falha
    } catch (e) { // Se der erro
      print('Erro ao inserir paciente: $e'); // Mostra o erro
      return false; // Falha
    }
  }

  // Método para buscar todos os pacientes via API
  static Future<List<CadastroModel>> getAllCadastros() async {
    try { // Tenta executar
      final response = await http.get( // Faz requisição GET
        Uri.parse('$baseUrl/api/cadastros'), // URL da API
        headers: headers, // Headers da requisição
      );
      
      if (response.statusCode == 200) { // Se sucesso
        final data = json.decode(response.body); // Converte JSON
        if (data['success'] == true) { // Se API retornou sucesso
          final List<dynamic> pacientes = data['data']; // Lista de pacientes
          return pacientes.map((json) => CadastroModel.fromMap(json)).toList(); // Converte para objetos
        }
      }
      return []; // Retorna lista vazia
    } catch (e) { // Se der erro
      print('Erro ao buscar pacientes: $e'); // Mostra o erro
      return []; // Retorna lista vazia
    }
  }

  // Método para buscar paciente por CPF via API
  static Future<CadastroModel?> getCadastroByCpf(String cpf) async {
    try { // Tenta executar
      final response = await http.get( // Faz requisição GET
        Uri.parse('$baseUrl/api/cadastros/$cpf'), // URL da API com CPF
        headers: headers, // Headers da requisição
      );
      
      if (response.statusCode == 200) { // Se sucesso
        final data = json.decode(response.body); // Converte JSON
        if (data['success'] == true) { // Se API retornou sucesso
          return CadastroModel.fromMap(data['data']); // Retorna objeto
        }
      }
      return null; // Não encontrou
    } catch (e) { // Se der erro
      print('Erro ao buscar por CPF: $e'); // Mostra o erro
      return null; // Retorna null
    }
  }

  // Método para atualizar dados do paciente via API
  static Future<bool> updateCadastro(CadastroModel cadastro) async {
    try { // Tenta executar
      final response = await http.put( // Faz requisição PUT
        Uri.parse('$baseUrl/api/cadastros/${cadastro.cpf}'), // URL da API com CPF
        headers: headers, // Headers da requisição
        body: json.encode({ // Converte objeto para JSON
          'nomeCompleto': cadastro.nomeCompleto, // Nome completo
          'dataNascimento': cadastro.dataNascimento.toIso8601String().split('T')[0], // Data
          'sexo': cadastro.sexo, // Sexo
          'telefone': cadastro.telefone, // Telefone
          'quartoLeito': cadastro.quartoLeito, // Quarto/leito
          'queixaPrincipal': cadastro.queixaPrincipal, // Queixa principal
          'observacoes': cadastro.observacoes, // Observações
        }),
      );
      
      if (response.statusCode == 200) { // Se sucesso
        final data = json.decode(response.body); // Converte JSON
        return data['success'] == true; // Retorna se foi bem-sucedido
      }
      return false; // Falha
    } catch (e) { // Se der erro
      print('Erro ao atualizar paciente: $e'); // Mostra o erro
      return false; // Falha
    }
  }

  // Método para deletar paciente via API
  static Future<bool> deleteCadastro(String cpf) async {
    try { // Tenta executar
      final response = await http.delete( // Faz requisição DELETE
        Uri.parse('$baseUrl/api/cadastros/$cpf'), // URL da API com CPF
        headers: headers, // Headers da requisição
      );
      
      if (response.statusCode == 200) { // Se sucesso
        final data = json.decode(response.body); // Converte JSON
        return data['success'] == true; // Retorna se foi bem-sucedido
      }
      return false; // Falha
    } catch (e) { // Se der erro
      print('Erro ao deletar paciente: $e'); // Mostra o erro
      return false; // Falha
    }
  }

  // Método para contar total de pacientes via API
  static Future<int> getTotalCadastros() async {
    try { // Tenta executar
      final response = await http.get( // Faz requisição GET
        Uri.parse('$baseUrl/api/cadastros/count'), // URL da API
        headers: headers, // Headers da requisição
      );
      
      if (response.statusCode == 200) { // Se sucesso
        final data = json.decode(response.body); // Converte JSON
        if (data['success'] == true) { // Se API retornou sucesso
          return data['total'] as int; // Retorna total
        }
      }
      return 0; // Retorna zero
    } catch (e) { // Se der erro
      print('Erro ao contar pacientes: $e'); // Mostra o erro
      return 0; // Retorna zero
    }
  }

  // Método para buscar pacientes por nome via API
  static Future<List<CadastroModel>> searchCadastrosByName(String nome) async {
    try { // Tenta executar
      final response = await http.get( // Faz requisição GET
        Uri.parse('$baseUrl/api/cadastros/search/$nome'), // URL da API com nome
        headers: headers, // Headers da requisição
      );
      
      if (response.statusCode == 200) { // Se sucesso
        final data = json.decode(response.body); // Converte JSON
        if (data['success'] == true) { // Se API retornou sucesso
          final List<dynamic> pacientes = data['data']; // Lista de pacientes
          return pacientes.map((json) => CadastroModel.fromMap(json)).toList(); // Converte para objetos
        }
      }
      return []; // Retorna lista vazia
    } catch (e) { // Se der erro
      print('Erro ao buscar por nome: $e'); // Mostra o erro
      return []; // Retorna lista vazia
    }
  }

  // Método para buscar pacientes por quarto/leito via API
  static Future<List<CadastroModel>> getCadastrosByQuarto(String quarto) async {
    try { // Tenta executar
      // Como não temos endpoint específico, usamos busca por nome
      return await searchCadastrosByName(quarto); // Busca por nome (pode incluir quarto)
    } catch (e) { // Se der erro
      print('Erro ao buscar por quarto: $e'); // Mostra o erro
      return []; // Retorna lista vazia
    }
  }

  // Método para buscar pacientes por sexo via API
  static Future<List<CadastroModel>> getCadastrosBySexo(String sexo) async {
    try { // Tenta executar
      // Como não temos endpoint específico, usamos busca por nome
      return await searchCadastrosByName(sexo); // Busca por nome (pode incluir sexo)
    } catch (e) { // Se der erro
      print('Erro ao buscar por sexo: $e'); // Mostra o erro
      return []; // Retorna lista vazia
    }
  }
}
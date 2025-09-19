// Esta pasta contém os modelos de dados da aplicação
// Cada arquivo representa uma tabela do banco de dados
// Os modelos definem a estrutura dos dados e métodos para conversão
// Exemplo: cadastro_model.dart representa a tabela 'cadastro' do MySQL

// Importa o BaseModel para herdar funcionalidades comuns
import 'base_model.dart';

// CadastroModel herda de BaseModel (extends = herança)
// Herda métodos como toString(), operator ==, hashCode, etc.
class CadastroModel extends BaseModel {
  // ========================================
  // PROPRIEDADES DA CLASSE (CAMPOS DA TABELA)
  // ========================================
  
  // CPF é a chave primária (primary key)
  // final = não pode ser alterado após criação (imutável)
  // String = tipo de dados (texto)
  final String cpf;
  
  // Nome completo do paciente
  // final = não pode ser alterado após criação (imutável)
  // String = tipo de dados (texto)
  final String nomeCompleto;
  
  // Data de nascimento
  // final = não pode ser alterado após criação (imutável)
  // DateTime = tipo de dados (data e hora)
  final DateTime dataNascimento;
  
  // Sexo: 'M' para masculino, 'F' para feminino
  // final = não pode ser alterado após criação (imutável)
  // String = tipo de dados (texto)
  final String sexo;
  
  // Telefone de contato
  // String = tipo de dados (texto)
  // PODE SER ALTERADO: paciente pode trocar de número
  String telefone;
  
  // Quarto/leito onde o paciente está
  // String = tipo de dados (texto)
  // PODE SER ALTERADO: paciente pode ser transferido
  String quartoLeito;
  
  // Queixa principal do paciente
  // String = tipo de dados (texto)
  // PODE SER ALTERADO: queixa pode evoluir ou mudar
  String queixaPrincipal;
  
  // Observações adicionais
  // String = tipo de dados (texto)
  // PODE SER ALTERADO: observações sempre podem ser atualizadas
  String observacoes;

  // ========================================
  // CONSTRUTOR DA CLASSE
  // ========================================
  
  // Construtor da classe - permite criar um novo objeto CadastroModel
  // required = todos os campos são obrigatórios (não podem ser nulos)
  // this.cpf = atribui o valor do parâmetro para a propriedade cpf
  CadastroModel({
    required this.cpf,           // CPF é obrigatório
    required this.nomeCompleto,  // Nome é obrigatório
    required this.dataNascimento, // Data é obrigatória
    required this.sexo,          // Sexo é obrigatório
    required this.telefone,      // Telefone é obrigatório
    required this.quartoLeito,   // Quarto/leito é obrigatório
    required this.queixaPrincipal, // Queixa é obrigatória
    required this.observacoes,   // Observações são obrigatórias
  });

  // ========================================
  // MÉTODO toMap() - CONVERTE OBJETO PARA MAP
  // ========================================
  
  // Método para converter o objeto CadastroModel para Map<String, dynamic>
  // Map = dicionário (chave-valor) que o banco de dados MySQL entende
  // String = tipo da chave (nome do campo)
  // dynamic = tipo do valor (pode ser qualquer tipo)
  Map<String, dynamic> toMap() {
    return {
      'cpf': cpf,                                    // CPF como string
      'nome_completo': nomeCompleto,                 // Nome como string
      'data_nascimento': dataNascimento.toIso8601String(), // Data convertida para string ISO
      'sexo': sexo,                                  // Sexo como string
      'telefone': telefone,                          // Telefone como string
      'quarto_leito': quartoLeito,                   // Quarto/leito como string
      'queixa_principal': queixaPrincipal,           // Queixa como string
      'observacoes': observacoes,                    // Observações como string
    };
  }

  // ========================================
  // MÉTODO fromMap() - CRIA OBJETO A PARTIR DE MAP
  // ========================================
  
  // Método factory para criar um objeto CadastroModel a partir de um Map
  // factory = método especial que retorna uma instância da classe
  // Map<String, dynamic> = dicionário que vem do banco de dados MySQL
  factory CadastroModel.fromMap(Map<String, dynamic> map) {
    return CadastroModel(
      cpf: map['cpf'],                                    // Pega CPF do Map
      nomeCompleto: map['nome_completo'],                 // Pega nome do Map
      dataNascimento: DateTime.parse(map['data_nascimento']), // Converte string para DateTime
      sexo: map['sexo'],                                  // Pega sexo do Map
      telefone: map['telefone'],                          // Pega telefone do Map
      quartoLeito: map['quarto_leito'],                   // Pega quarto/leito do Map
      queixaPrincipal: map['queixa_principal'],           // Pega queixa do Map
      observacoes: map['observacoes'],                    // Pega observações do Map
    );
  }

  // ========================================
  // MÉTODO copyWith() - CRIA CÓPIA COM CAMPOS ALTERADOS
  // ========================================
  
  // Método para criar uma cópia do objeto com alguns campos alterados
  // String? = parâmetro opcional (pode ser null)
  // ?? = operador null-coalescing (se null, usa o valor atual)
  CadastroModel copyWith({
    String? cpf,                    // CPF opcional (não pode mudar)
    String? nomeCompleto,           // Nome opcional (não pode mudar)
    DateTime? dataNascimento,       // Data opcional (não pode mudar)
    String? sexo,                   // Sexo opcional (não pode mudar)
    String? telefone,               // Telefone opcional (PODE MUDAR)
    String? quartoLeito,            // Quarto/leito opcional (PODE MUDAR)
    String? queixaPrincipal,        // Queixa opcional (PODE MUDAR)
    String? observacoes,            // Observações opcionais (PODE MUDAR)
  }) {
    return CadastroModel(
      cpf: cpf ?? this.cpf,                    // Se cpf for null, usa o atual
      nomeCompleto: nomeCompleto ?? this.nomeCompleto, // Se nome for null, usa o atual
      dataNascimento: dataNascimento ?? this.dataNascimento, // Se data for null, usa a atual
      sexo: sexo ?? this.sexo,                 // Se sexo for null, usa o atual
      telefone: telefone ?? this.telefone,     // Se telefone for null, usa o atual
      quartoLeito: quartoLeito ?? this.quartoLeito, // Se quarto for null, usa o atual
      queixaPrincipal: queixaPrincipal ?? this.queixaPrincipal, // Se queixa for null, usa a atual
      observacoes: observacoes ?? this.observacoes, // Se observações forem null, usa as atuais
    );
  }

  // ========================================
  // MÉTODOS PARA ATUALIZAR CAMPOS MUTÁVEIS
  // ========================================
  
  // Método para atualizar o telefone
  // void = não retorna valor
  void atualizarTelefone(String novoTelefone) {
    telefone = novoTelefone;
  }
  
  // Método para atualizar o quarto/leito
  void atualizarQuartoLeito(String novoQuartoLeito) {
    quartoLeito = novoQuartoLeito;
  }
  
  // Método para atualizar a queixa principal
  void atualizarQueixaPrincipal(String novaQueixaPrincipal) {
    queixaPrincipal = novaQueixaPrincipal;
  }
  
  // Método para atualizar as observações
  void atualizarObservacoes(String novasObservacoes) {
    observacoes = novasObservacoes;
  }
  
  // Método para adicionar observação (sem substituir as existentes)
  void adicionarObservacao(String novaObservacao) {
    if (observacoes.isEmpty) {
      observacoes = novaObservacao;
    } else {
      observacoes = '$observacoes\n$novaObservacao';
    }
  }

  // ========================================
  // MÉTODOS AUXILIARES (DEBUG E TESTES)
  // ========================================
  
  // Método para converter o objeto para String (útil para debug)
  // @override = sobrescreve o método toString() da classe BaseModel
  // $cpf = interpolação de string (substitui pela variável)
  @override
  String toString() {
    return 'CadastroModel(cpf: $cpf, nomeCompleto: $nomeCompleto, dataNascimento: $dataNascimento, sexo: $sexo, telefone: $telefone, quartoLeito: $quartoLeito, queixaPrincipal: $queixaPrincipal, observacoes: $observacoes)';
  }
}

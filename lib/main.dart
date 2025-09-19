// Arquivo principal da aplicação Flutter
// main.dart: Ponto de entrada da aplicação
// Inicializa o app e define a tela inicial

import 'package:flutter/material.dart'; // Biblioteca principal do Flutter
import 'database/database_helper.dart'; // Importa o helper do banco de dados
import 'models/cadastro_model.dart'; // Importa o modelo de cadastro

// Função principal que inicia a aplicação
void main() async { // async = permite operações assíncronas
  WidgetsFlutterBinding.ensureInitialized(); // Inicializa o Flutter
  
  // Testa a conexão com o banco de dados
  await _testDatabaseConnection(); // Chama função de teste
  
  runApp(MyApp()); // Inicia a aplicação
}

// Função para testar a conexão com o banco via API
Future<void> _testDatabaseConnection() async {
  try { // Tenta conectar
    print('🔄 Testando conexão com API...'); // Mensagem de teste
    
    // Cria a tabela via API (testa se consegue conectar)
    final success = await DatabaseHelper.createTable(); // Executa criação da tabela
    
    if (success) { // Se sucesso
      print('✅ Conexão com API estabelecida com sucesso!'); // Sucesso
      print('📊 Tabela "cadastro" criada/verificada via API'); // Confirmação
    } else { // Se falha
      print('❌ Erro ao conectar com API'); // Erro
    }
    
  } catch (e) { // Se der erro
    print('❌ Erro ao conectar com API: $e'); // Mostra o erro
    print('🔧 Verifique se o backend está rodando na porta 3000'); // Dica
  }
}

// Classe principal da aplicação
class MyApp extends StatelessWidget { // StatelessWidget = widget sem estado
  @override
  Widget build(BuildContext context) { // Constrói a interface
    return MaterialApp( // MaterialApp = app com Material Design
      title: 'PET Saúde', // Título da aplicação
      theme: ThemeData( // Tema da aplicação
        primarySwatch: Colors.blue, // Cor principal (azul)
        useMaterial3: true, // Usa Material Design 3
      ),
      home: MyHomePage(), // Tela inicial
    );
  }
}

// Classe da tela inicial
class MyHomePage extends StatefulWidget { // StatefulWidget = widget com estado
  @override
  _MyHomePageState createState() => _MyHomePageState(); // Cria o estado
}

// Estado da tela inicial
class _MyHomePageState extends State<MyHomePage> { // Estado da tela
  final _formKey = GlobalKey<FormState>(); // Chave do formulário
  final _cpfController = TextEditingController(); // Controlador do CPF
  final _nomeController = TextEditingController(); // Controlador do nome
  final _telefoneController = TextEditingController(); // Controlador do telefone
  final _quartoController = TextEditingController(); // Controlador do quarto
  final _queixaController = TextEditingController(); // Controlador da queixa
  final _observacoesController = TextEditingController(); // Controlador das observações
  
  DateTime _dataNascimento = DateTime.now(); // Data de nascimento
  String _sexo = 'M'; // Sexo selecionado
  bool _isLoading = false; // Estado de carregamento

  @override
  Widget build(BuildContext context) { // Constrói a interface
    return Scaffold( // Scaffold = estrutura básica da tela
      appBar: AppBar( // Barra superior
        title: Text('PET Saúde - Cadastro de Pacientes'), // Título da barra
        backgroundColor: Colors.blue, // Cor de fundo
      ),
      body: SingleChildScrollView( // Permite rolar a tela
        padding: EdgeInsets.all(16), // Espaçamento interno
        child: Form( // Formulário
          key: _formKey, // Chave do formulário
          child: Column( // Coluna vertical
            crossAxisAlignment: CrossAxisAlignment.stretch, // Estica horizontalmente
            children: <Widget>[ // Lista de widgets
              // Título
              Text( // Texto principal
                'Cadastro de Paciente', // Título
                style: TextStyle( // Estilo do texto
                  fontSize: 24, // Tamanho da fonte
                  fontWeight: FontWeight.bold, // Negrito
                  color: Colors.blue, // Cor do texto
                ),
                textAlign: TextAlign.center, // Centraliza o texto
              ),
              SizedBox(height: 20), // Espaçamento
              
              // CPF
              TextFormField( // Campo de texto do CPF
                controller: _cpfController, // Controlador
                decoration: InputDecoration( // Decoração do campo
                  labelText: 'CPF', // Rótulo
                  hintText: '000.000.000-00', // Dica
                  border: OutlineInputBorder(), // Borda
                  prefixIcon: Icon(Icons.person), // Ícone
                ),
                validator: (value) { // Validação
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o CPF';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16), // Espaçamento
              
              // Nome Completo
              TextFormField( // Campo de texto do nome
                controller: _nomeController, // Controlador
                decoration: InputDecoration( // Decoração do campo
                  labelText: 'Nome Completo', // Rótulo
                  hintText: 'Digite o nome completo', // Dica
                  border: OutlineInputBorder(), // Borda
                  prefixIcon: Icon(Icons.person_outline), // Ícone
                ),
                validator: (value) { // Validação
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome completo';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16), // Espaçamento
              
              // Data de Nascimento
              InkWell( // Área clicável
                onTap: () async { // Ação ao clicar
                  final date = await showDatePicker( // Mostra seletor de data
                    context: context, // Contexto
                    initialDate: _dataNascimento, // Data inicial
                    firstDate: DateTime(1900), // Primeira data
                    lastDate: DateTime.now(), // Última data
                  );
                  if (date != null) { // Se selecionou data
                    setState(() { // Atualiza estado
                      _dataNascimento = date; // Define nova data
                    });
                  }
                },
                child: InputDecorator( // Decorador de entrada
                  decoration: InputDecoration( // Decoração
                    labelText: 'Data de Nascimento', // Rótulo
                    border: OutlineInputBorder(), // Borda
                    prefixIcon: Icon(Icons.calendar_today), // Ícone
                  ),
                  child: Text( // Texto da data
                    '${_dataNascimento.day.toString().padLeft(2, '0')}/'
                    '${_dataNascimento.month.toString().padLeft(2, '0')}/'
                    '${_dataNascimento.year}', // Formato DD/MM/AAAA
                  ),
                ),
              ),
              SizedBox(height: 16), // Espaçamento
              
              // Sexo
              DropdownButtonFormField<String>( // Dropdown do sexo
                value: _sexo, // Valor atual
                decoration: InputDecoration( // Decoração
                  labelText: 'Sexo', // Rótulo
                  border: OutlineInputBorder(), // Borda
                  prefixIcon: Icon(Icons.wc), // Ícone
                ),
                items: [ // Itens do dropdown
                  DropdownMenuItem(value: 'M', child: Text('Masculino')), // Opção M
                  DropdownMenuItem(value: 'F', child: Text('Feminino')), // Opção F
                ],
                onChanged: (value) { // Ação ao mudar
                  setState(() { // Atualiza estado
                    _sexo = value!; // Define novo valor
                  });
                },
              ),
              SizedBox(height: 16), // Espaçamento
              
              // Telefone
              TextFormField( // Campo de texto do telefone
                controller: _telefoneController, // Controlador
                decoration: InputDecoration( // Decoração do campo
                  labelText: 'Telefone', // Rótulo
                  hintText: '(00) 00000-0000', // Dica
                  border: OutlineInputBorder(), // Borda
                  prefixIcon: Icon(Icons.phone), // Ícone
                ),
                validator: (value) { // Validação
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16), // Espaçamento
              
              // Quarto/Leito
              TextFormField( // Campo de texto do quarto
                controller: _quartoController, // Controlador
                decoration: InputDecoration( // Decoração do campo
                  labelText: 'Quarto/Leito', // Rótulo
                  hintText: 'Ex: 101, Leito A', // Dica
                  border: OutlineInputBorder(), // Borda
                  prefixIcon: Icon(Icons.bed), // Ícone
                ),
                validator: (value) { // Validação
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o quarto/leito';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16), // Espaçamento
              
              // Queixa Principal
              TextFormField( // Campo de texto da queixa
                controller: _queixaController, // Controlador
                decoration: InputDecoration( // Decoração do campo
                  labelText: 'Queixa Principal', // Rótulo
                  hintText: 'Descreva a queixa principal', // Dica
                  border: OutlineInputBorder(), // Borda
                  prefixIcon: Icon(Icons.medical_services), // Ícone
                ),
                maxLines: 3, // Múltiplas linhas
                validator: (value) { // Validação
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a queixa principal';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16), // Espaçamento
              
              // Observações
              TextFormField( // Campo de texto das observações
                controller: _observacoesController, // Controlador
                decoration: InputDecoration( // Decoração do campo
                  labelText: 'Observações', // Rótulo
                  hintText: 'Observações adicionais (opcional)', // Dica
                  border: OutlineInputBorder(), // Borda
                  prefixIcon: Icon(Icons.note), // Ícone
                ),
                maxLines: 3, // Múltiplas linhas
              ),
              SizedBox(height: 24), // Espaçamento
              
              // Botão de Cadastrar
              ElevatedButton( // Botão elevado
                onPressed: _isLoading ? null : _cadastrarPaciente, // Ação do botão
                style: ElevatedButton.styleFrom( // Estilo do botão
                  backgroundColor: Colors.blue, // Cor de fundo
                  padding: EdgeInsets.symmetric(vertical: 16), // Espaçamento interno
                ),
                child: _isLoading // Se carregando
                    ? CircularProgressIndicator(color: Colors.white) // Mostra loading
                    : Text( // Senão mostra texto
                        'Cadastrar Paciente', // Texto do botão
                        style: TextStyle( // Estilo do texto
                          fontSize: 18, // Tamanho da fonte
                          fontWeight: FontWeight.bold, // Negrito
                          color: Colors.white, // Cor branca
                        ),
                      ),
              ),
              SizedBox(height: 16), // Espaçamento
              
              // Status da conexão
              Text( // Texto de status
                'Conexão com API: ✅ Ativa', // Status da conexão
                style: TextStyle( // Estilo do texto
                  fontSize: 14, // Tamanho da fonte
                  color: Colors.green, // Cor verde
                  fontWeight: FontWeight.bold, // Negrito
                ),
                textAlign: TextAlign.center, // Centraliza o texto
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para cadastrar paciente
  Future<void> _cadastrarPaciente() async {
    if (_formKey.currentState!.validate()) { // Se formulário válido
      setState(() { // Atualiza estado
        _isLoading = true; // Define carregando
      });

      try { // Tenta cadastrar
        // Cria modelo do paciente
        final paciente = CadastroModel(
          cpf: _cpfController.text, // CPF
          nomeCompleto: _nomeController.text, // Nome
          dataNascimento: _dataNascimento, // Data
          sexo: _sexo, // Sexo
          telefone: _telefoneController.text, // Telefone
          quartoLeito: _quartoController.text, // Quarto
          queixaPrincipal: _queixaController.text, // Queixa
          observacoes: _observacoesController.text, // Observações
        );

        // Insere no banco via API
        final success = await DatabaseHelper.insertCadastro(paciente);

        if (success) { // Se sucesso
          _showMessage('Paciente cadastrado com sucesso!', Colors.green); // Mostra sucesso
          _limparFormulario(); // Limpa formulário
        } else { // Se falha
          _showMessage('Erro ao cadastrar paciente', Colors.red); // Mostra erro
        }
      } catch (e) { // Se der erro
        _showMessage('Erro: $e', Colors.red); // Mostra erro
      } finally { // Sempre executa
        setState(() { // Atualiza estado
          _isLoading = false; // Para carregamento
        });
      }
    }
  }

  // Método para mostrar mensagem
  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar( // Mostra snackbar
      SnackBar( // Snackbar
        content: Text(message), // Conteúdo
        backgroundColor: color, // Cor de fundo
        duration: Duration(seconds: 3), // Duração
      ),
    );
  }

  // Método para limpar formulário
  void _limparFormulario() {
    _cpfController.clear(); // Limpa CPF
    _nomeController.clear(); // Limpa nome
    _telefoneController.clear(); // Limpa telefone
    _quartoController.clear(); // Limpa quarto
    _queixaController.clear(); // Limpa queixa
    _observacoesController.clear(); // Limpa observações
    setState(() { // Atualiza estado
      _dataNascimento = DateTime.now(); // Reseta data
      _sexo = 'M'; // Reseta sexo
    });
  }
}

// ========================================
// CLASSE ABSTRATA BaseModel
// ========================================
//
// Classe abstrata que contém métodos comuns a todos os modelos
// abstract = não pode ser instanciada diretamente, só pode ser herdada
// 
// EXEMPLO DE USO:
// class CadastroModel extends BaseModel {
//   // Implementa os métodos abstratos
// }
//
// VANTAGENS:
// 1. Evita repetição de código
// 2. Garante consistência entre modelos
// 3. Facilita manutenção
// 4. Padrão da comunidade Flutter
//
abstract class BaseModel {
  // Construtor padrão para permitir herança
  BaseModel();
  
  // ========================================
  // MÉTODOS ABSTRATOS (DEVEM SER IMPLEMENTADOS)
  // ========================================
  
  // Método abstrato que deve ser implementado por todas as classes filhas
  // Map<String, dynamic> = dicionário que o banco de dados MySQL entende
  // 
  // EXEMPLO DE IMPLEMENTAÇÃO:
  // Map<String, dynamic> toMap() {
  //   return {
  //     'cpf': cpf,
  //     'nome_completo': nomeCompleto,
  //     // ... outros campos
  //   };
  // }
  //
  // USO: cadastro.toMap() retorna {'cpf': '123.456.789-00', ...}
  //
  Map<String, dynamic> toMap();
  
  // Método factory abstrato que deve ser implementado por todas as classes filhas
  // factory = método especial que retorna uma instância da classe
  // Map<String, dynamic> = dicionário que vem do banco de dados MySQL
  // 
  // EXEMPLO DE IMPLEMENTAÇÃO:
  // factory CadastroModel.fromMap(Map<String, dynamic> map) {
  //   return CadastroModel(
  //     cpf: map['cpf'],
  //     nomeCompleto: map['nome_completo'],
  //     // ... outros campos
  //   );
  // }
  //
  // USO: CadastroModel.fromMap({'cpf': '123.456.789-00', ...})
  //
  factory BaseModel.fromMap(Map<String, dynamic> map) {
    throw UnimplementedError('fromMap deve ser implementado pela classe filha');
  }
  
  // ========================================
  // MÉTODOS IMPLEMENTADOS (HERDADOS AUTOMATICAMENTE)
  // ========================================
  
  // Método para converter o objeto para String (útil para debug)
  // @override = sobrescreve o método toString() da classe Object
  // $this = interpolação de string (substitui pela variável)
  // 
  // EXEMPLO DE USO:
  // final cadastro = CadastroModel(...);
  // print(cadastro.toString()); // Imprime: BaseModel: {cpf: 123.456.789-00, ...}
  //
  @override
  String toString() {
    return 'BaseModel: ${toMap()}';
  }
  
  // Método para comparar dois objetos (útil para testes)
  // @override = sobrescreve o operador == da classe Object
  // identical() = verifica se são o mesmo objeto na memória
  // 
  // EXEMPLO DE USO:
  // final cadastro1 = CadastroModel(cpf: "123", ...);
  // final cadastro2 = CadastroModel(cpf: "123", ...);
  // print(cadastro1 == cadastro2); // true (mesmos dados)
  //
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;  // Se são o mesmo objeto, são iguais
    return other is BaseModel &&             // Se o outro é BaseModel
        other.runtimeType == runtimeType &&  // E são do mesmo tipo
        other.toMap() == toMap();            // E têm os mesmos dados
  }
  
  // Método para gerar hash code (útil para testes e coleções)
  // @override = sobrescreve o getter hashCode da classe Object
  // hashCode = número único que representa o objeto
  // 
  // EXEMPLO DE USO:
  // final cadastro = CadastroModel(...);
  // print(cadastro.hashCode); // Imprime: 1234567890
  //
  @override
  int get hashCode {
    return toMap().hashCode;  // Hash baseado nos dados do objeto
  }
  
  // ========================================
  // MÉTODOS AUXILIARES (UTILITÁRIOS)
  // ========================================
  
  // Método para verificar se o objeto está vazio
  // bool = tipo de dados (verdadeiro ou falso)
  // 
  // EXEMPLO DE USO:
  // final cadastro = CadastroModel(...);
  // print(cadastro.isEmpty); // false (se tiver dados)
  //
  bool get isEmpty {
    return toMap().isEmpty;  // Verifica se o Map está vazio
  }
  
  // Método para verificar se o objeto não está vazio
  // 
  // EXEMPLO DE USO:
  // final cadastro = CadastroModel(...);
  // print(cadastro.isNotEmpty); // true (se tiver dados)
  //
  bool get isNotEmpty {
    return !isEmpty;  // Inverte o resultado de isEmpty
  }
  
  // Método para obter as chaves (nomes dos campos)
  // List<String> = lista de strings
  // 
  // EXEMPLO DE USO:
  // final cadastro = CadastroModel(...);
  // print(cadastro.keys); // ['cpf', 'nome_completo', 'data_nascimento', ...]
  //
  List<String> get keys {
    return toMap().keys.toList();  // Converte as chaves do Map para List
  }
  
  // Método para obter os valores
  // List<dynamic> = lista de valores de qualquer tipo
  // 
  // EXEMPLO DE USO:
  // final cadastro = CadastroModel(...);
  // print(cadastro.values); // ['123.456.789-00', 'João Silva', '1990-05-15', ...]
  //
  List<dynamic> get values {
    return toMap().values.toList();  // Converte os valores do Map para List
  }
}
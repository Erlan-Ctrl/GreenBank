// lib/user_repository.dart

class UserRepository {
  /// Mapa CPF (sem pontuação) → { 'nome': nome, 'senha': senha }
  static final Map<String, Map<String, String>> _users = {};

  /// Registra um novo usuário. Retorna true se sucesso, false se CPF já existir.
  static bool register(String cpfNormalized, String nome, String password) {
    if (_users.containsKey(cpfNormalized)) {
      return false; // CPF já cadastrado
    }
    _users[cpfNormalized] = {
      'nome': nome,
      'senha': password,
    };
    return true;
  }

  /// Retorna true se CPF+senha batem com algo cadastrado.
  static bool canLogin(String cpfNormalized, String password) {
    if (!_users.containsKey(cpfNormalized)) return false;
    return _users[cpfNormalized]!['senha'] == password;
  }

  /// Retorna o nome associado a um CPF (ou null se não existir).
  static String? getName(String cpfNormalized) {
    return _users[cpfNormalized]?['nome'];
  }
}

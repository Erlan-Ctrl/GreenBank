class UserRepository {
  static final Map<String, Map<String, String>> _users = {};

  static bool register(String cpfNormalized, String nome, String password) {
    if (_users.containsKey(cpfNormalized)) {
      return false;
    }
    _users[cpfNormalized] = {
      'nome': nome,
      'senha': password,
    };
    return true;
  }

  static bool canLogin(String cpfNormalized, String password) {
    if (!_users.containsKey(cpfNormalized)) return false;
    return _users[cpfNormalized]!['senha'] == password;
  }

  static String? getName(String cpfNormalized) {
    return _users[cpfNormalized]?['nome'];
  }
}

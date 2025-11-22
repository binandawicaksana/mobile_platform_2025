class AuthService {
  AuthService._internal();

  static final AuthService instance = AuthService._internal();

  // user simple di memori
  final Map<String, String> _users = {
    'a': 'a', // user default
  };

  String? currentUser; // username yang sedang login

  bool login(String username, String password) {
    final ok = _users[username] == password;
    if (ok) {
      currentUser = username; // simpan username kalau berhasil login
    }
    return ok;
  }

  bool register(String username, String password) {
    if (_users.containsKey(username)) return false;
    _users[username] = password;
    return true;
  }

  void logout() {
    currentUser = null;
  }
}

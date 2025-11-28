class AuthService {
  AuthService._private();
  static final AuthService instance = AuthService._private();

  static const String _defaultAvatarAsset = 'assets/images/v.jpg';

  String? currentUser;
  String _avatarRef = _defaultAvatarAsset;
  bool _avatarIsAsset = true;

  String get displayName => currentUser ?? 'peterparkir';
  String get avatarRef => _avatarRef;
  bool get avatarIsAsset => _avatarIsAsset;

  /// Simulate login without credentials (auto-login)
  bool loginAuto() {
    currentUser = 'peterparkir';
    resetAvatarToDefault();
    return true;
  }

  /// If you later want to support real login:
  bool login(String username, String password) {
    if (username.isNotEmpty && password.isNotEmpty) {
      currentUser = username;
      return true;
    }
    return false;
  }

  void logout() {
    currentUser = null;
    resetAvatarToDefault();
  }

  void updateAvatar(String url) {
    final trimmed = url.trim();
    if (trimmed.isEmpty) {
      resetAvatarToDefault();
      return;
    }

    if (trimmed.startsWith('assets/')) {
      _avatarRef = trimmed;
      _avatarIsAsset = true;
    } else {
      _avatarRef = trimmed;
      _avatarIsAsset = false;
    }
  }

  void resetAvatarToDefault() {
    _avatarRef = _defaultAvatarAsset;
    _avatarIsAsset = true;
  }
}

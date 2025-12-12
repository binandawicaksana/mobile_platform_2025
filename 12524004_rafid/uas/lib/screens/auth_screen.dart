part of 'package:uas/main.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({
    super.key,
    required this.isLogin,
    required this.onSubmit,
    required this.onToggleMode,
  });

  final bool isLogin;
  final Future<void> Function(AuthFormData data) onSubmit;
  final VoidCallback onToggleMode;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void didUpdateWidget(covariant AuthScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLogin != widget.isLogin) {
      _formKey.currentState?.reset();
      if (widget.isLogin) {
        _nameController.clear();
        _confirmController.clear();
        _balanceController.clear();
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  double _parseBalance(String input) {
    final sanitized = input.replaceAll(RegExp(r'[^0-9,\.]'), '');
    final normalized = sanitized.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0;
  }

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;
    if (!_formKey.currentState!.validate()) return;

    final data = AuthFormData(
      mode: widget.isLogin ? AuthMode.login : AuthMode.register,
      fullName: widget.isLogin ? null : _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      confirmPassword:
          widget.isLogin ? null : _confirmController.text.trim(),
      initialBalance:
          widget.isLogin ? null : _parseBalance(_balanceController.text),
    );

    setState(() => _isSubmitting = true);
    try {
      await widget.onSubmit(data);
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isLogin ? 'Masuk' : 'Daftar';
    final subtitle = widget.isLogin
        ? 'Selamat datang kembali! Masuk untuk lanjut ke dashboard.'
        : 'Buat akun baru agar pengeluaranmu lebih teratur.';
    final actionLabel = widget.isLogin ? 'Masuk' : 'Daftar';
    final toggleLabel = widget.isLogin
        ? 'Belum punya akun? Daftar'
        : 'Sudah punya akun? Masuk';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 32),
          Text(
            'Self track.\nStay on budget.',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: MockupColors.blueDark,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kelola pemasukan dan pengeluaranmu lewat aplikasi ini.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: MockupColors.textSecondary,
                ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 30,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: MockupColors.blueDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: MockupColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (!widget.isLogin) ...[
                    AuthTextField(
                      label: 'Nama Lengkap',
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                  AuthTextField(
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email wajib diisi';
                      }
                      if (!value.contains('@')) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AuthTextField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password wajib diisi';
                      }
                      if (value.length < 6) {
                        return 'Minimal 6 karakter';
                      }
                      return null;
                    },
                  ),
                  if (!widget.isLogin) ...[
                    const SizedBox(height: 16),
                    AuthTextField(
                      label: 'Konfirmasi Password',
                      controller: _confirmController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konfirmasi password wajib diisi';
                        }
                        if (value != _passwordController.text) {
                          return 'Password tidak sama';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      label: 'Saldo Awal (opsional)',
                      controller: _balanceController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return null;
                        }
                        final parsed = _parseBalance(value);
                        if (parsed < 0) {
                          return 'Nominal tidak boleh negatif';
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: MockupColors.blueDark,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    child: Text(
                      _isSubmitting ? 'Memproses...' : actionLabel,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _isSubmitting ? null : widget.onToggleMode,
                    child: Text(
                      toggleLabel,
                      style: const TextStyle(
                        color: MockupColors.blueDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Icon(
                        Icons.verified_user,
                        size: 18,
                        color: MockupColors.mutedBlue,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Data kamu terenkripsi dan aman. Kamu bisa ubah profil kapan pun.',
                          style: TextStyle(
                            fontSize: 12,
                            color: MockupColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: MockupColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: MockupColors.borderBase.withOpacity(0.4),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  const BorderSide(color: MockupColors.blueDark, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}

class WalletStore {
  static int balance = 55394; // in Rupiah
  static final List<String> history = [
    'Top up Rp50.000 (21 Nov 2025)',
    'Pembelian Produk -Rp13.552 (20 Nov 2025)',
  ];

  static bool debit(int amount, {String note = 'Pembayaran'}) {
    if (amount <= 0) return false;
    if (balance < amount) return false;
    balance -= amount;
    history.insert(0, '$note -Rp${_fmt(amount)} (${DateTime.now().toLocal().toString().split(".").first})');
    return true;
  }

  static void credit(int amount, {String note = 'Top up'}) {
    if (amount <= 0) return;
    balance += amount;
    history.insert(0, '$note Rp${_fmt(amount)} (${DateTime.now().toLocal().toString().split(".").first})');
  }

  static String _fmt(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idx = s.length - i;
      buf.write(s[i]);
      if (idx > 1 && idx % 3 == 1) buf.write('.');
    }
    return buf.toString();
  }
}


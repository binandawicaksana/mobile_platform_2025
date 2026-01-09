import 'package:flutter/material.dart';
import 'theme_const.dart';
import 'add_food.dart';
import 'bottom_nav.dart';
import 'utils/download_helper.dart' as dl;

class TicketScreen extends StatelessWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      bottomNavigationBar: const MainBottomNav(currentIndex: 1),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  BackButton(color: Colors.white),
                  Text(
                    'Riwayat Pesanan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 24),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: const [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Jakarta',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Icon(Icons.arrow_forward, color: Colors.white),
                      Text('Bali',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Senin, 10 Desember\n04:00 PM',
                          style: TextStyle(color: Colors.white, fontSize: 11)),
                      Text('Selasa, 11 Desember\n07:00 AM',
                          style: TextStyle(color: Colors.white, fontSize: 11),
                          textAlign: TextAlign.right),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _ticketCard(),
                            const SizedBox(height: 16),
                            _actionButtons(context),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ticketCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('LionAir:1234', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text('Tria Agustin', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Divider(height: 24),
          _InfoRow(
            leftLabel: 'LionAir Loket',
            leftValue: 'LionAir',
            rightLabel: 'Seat & bagasi',
            rightValue: 'Bisnis',
          ),
          SizedBox(height: 16),
          Text('Bagasi', style: TextStyle(fontSize: 11, color: Colors.black54)),
          SizedBox(height: 4),
          Text('20kg', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          _Barcode(),
        ],
      ),
    );
  }

  Widget _actionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: kPrimaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddFoodScreen()),
              );
            },
            child: const Text('Tambah Makanan',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 46,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kPrimaryColor,
                    side: const BorderSide(color: kPrimaryColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    await dl.saveTicketFile('tiket.txt', _ticketPlainTextPretty());
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Tiket diunduh / disimpan')),
                    );
                  },
                  child: const Text('Download / Save'),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 46,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  onPressed: () async {
                    await dl.openPrintPreview('Tiket Penerbangan', _ticketHtmlPretty());
                  },
                  child: const Text('Share / Save PDF'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String leftLabel, leftValue, rightLabel, rightValue;
  const _InfoRow({
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(leftLabel, style: const TextStyle(fontSize: 11, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(leftValue, style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(rightLabel, style: const TextStyle(fontSize: 11, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(rightValue, style: const TextStyle(fontWeight: FontWeight.bold)),
        ]),
      ],
    );
  }
}

class _Barcode extends StatelessWidget {
  const _Barcode();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
      child: const Center(
        child: Text(
          '|||| ||||| || ||||| |||',
          style: TextStyle(color: Colors.white, letterSpacing: 2, fontSize: 20),
        ),
      ),
    );
  }
}

// Versi bersih untuk konten unduhan/preview (tanpa karakter rusak)
String _ticketPlainTextFixed() {
  return '''
Tiket Penerbangan

Maskapai : LionAir
Nama     : Tria Agustin
Rute     : Jakarta → Bali
Keberangkatan : Sen, 10 Des 04:00 PM
Kedatangan   : Sel, 11 Des 07:00 AM
Kelas    : Bisnis
Bagasi   : 20kg
''';
}

String _ticketHtmlFixed() {
  return '''
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Tiket Penerbangan</title>
<style>
body { font-family: Arial; padding: 24px; }
.card { border:1px solid #eee; padding:16px; border-radius:12px; }
h1 { color:#00C7CF; }
.barcode { background:#000;color:#fff;padding:12px;border-radius:8px;text-align:center;letter-spacing:2px; }
</style>
</head>
<body>
<h1>Tiket Penerbangan</h1>
<div class="card">
<p><b>Nama:</b> Tria Agustin</p>
<p><b>Maskapai:</b> LionAir</p>
<p><b>Rute:</b> Jakarta → Bali</p>
<p><b>Kelas:</b> Bisnis</p>
<p><b>Bagasi:</b> 20kg</p>
<div class="barcode">|||| ||||| || ||||| |||</div>
</div>
<script>window.print()</script>
</body>
</html>
''';
}

String _ticketPlainText() {
  return '''
Tiket Penerbangan

Maskapai : LionAir
Nama     : Tria Agustin
Rute     : Jakarta → Bali
Keberangkatan : Sen, 10 Des 04:00 PM
Kedatangan   : Sel, 11 Des 07:00 AM
Kelas    : Bisnis
Bagasi   : 20kg
''';
}

String _ticketHtml() {
  return '''
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Tiket Penerbangan</title>
<style>
body { font-family: Arial; padding: 24px; }
.card { border:1px solid #eee; padding:16px; border-radius:12px; }
h1 { color:#00C7CF; }
.barcode { background:#000;color:#fff;padding:12px;border-radius:8px;text-align:center;letter-spacing:2px; }
</style>
</head>
<body>
<h1>Tiket Penerbangan</h1>
<div class="card">
<p><b>Nama:</b> Tria Agustin</p>
<p><b>Maskapai:</b> LionAir</p>
<p><b>Rute:</b> Jakarta → Bali</p>
<p><b>Kelas:</b> Bisnis</p>
<p><b>Bagasi:</b> 20kg</p>
<div class="barcode">|||| ||||| || ||||| |||</div>
</div>
<script>window.print()</script>
</body>
</html>
''';
}

// Versi HTML yang lebih rapi untuk dicetak
String _ticketHtmlPretty() {
  return '''
<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Tiket Penerbangan</title>
  <style>
    :root { --primary:#00C7CF; --text:#0f172a; --muted:#6b7280; --line:#e6eef2; --surface:#fff; --bg:#f3f6f8; }
    *{box-sizing:border-box}
    body{margin:0;padding:24px;background:var(--bg);color:var(--text);font:14px/1.5 -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,'Noto Sans','Liberation Sans',sans-serif}
    .ticket{max-width:760px;margin:0 auto;background:var(--surface);border-radius:16px;overflow:hidden;border:1px solid #e5e7eb;box-shadow:0 10px 24px rgba(15,23,42,.06)}
    .header{display:flex;align-items:center;justify-content:space-between;padding:16px 20px;color:#fff;background:var(--primary)}
    .title{margin:0;font-size:18px;font-weight:800;letter-spacing:.3px}
    .code{font-size:12px;opacity:.9}
    .section{padding:20px;border-top:1px dashed var(--line)}
    .row{display:flex;gap:16px}
    .col{flex:1}
    .label{font-size:11px;color:var(--muted);text-transform:uppercase;letter-spacing:.06em}
    .value{margin-top:4px;font-size:14px;font-weight:700;color:var(--text)}
    .route{display:flex;align-items:center;gap:10px;font-weight:800;font-size:20px;letter-spacing:.3px}
    .arrow{opacity:.7}
    .time{font-weight:700}
    .note{font-size:12px;color:var(--muted)}
    .barcode{height:70px;border-radius:8px;overflow:hidden;background:repeating-linear-gradient(90deg,#000 0 2px,transparent 2px 4px)}
    .barcode-wrap{background:#111;padding:10px;border-radius:10px}
    .barcode-text{color:#fff;text-align:center;font-size:12px;letter-spacing:2px;margin-top:6px;opacity:.9}
    .grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:16px}
    @media(max-width:520px){.row{flex-direction:column}.grid{grid-template-columns:1fr}}
    @page{size:auto;margin:10mm}
    @media print{body{background:#fff;padding:0}.ticket{box-shadow:none}.btn-print{display:none!important}}
    .btn-print{margin:16px 0;text-align:center}
    .btn-print button{background:var(--primary);color:#fff;border:0;padding:10px 16px;border-radius:8px;cursor:pointer}
  </style>
</head>
<body>
  <div class="ticket">
    <div class="header">
      <h1 class="title">Tiket Penerbangan</h1>
      <div class="code">LionAir:1234</div>
    </div>
    <div class="section">
      <div class="row">
        <div class="col">
          <div class="label">Nama Penumpang</div>
          <div class="value">Tria Agustin</div>
        </div>
        <div class="col">
          <div class="label">Maskapai</div>
          <div class="value">LionAir</div>
        </div>
      </div>
    </div>
    <div class="section">
      <div class="label">Rute</div>
      <div class="route"><span>Jakarta (CGK)</span><span class="arrow">→</span><span>Bali (DPS)</span></div>
      <div style="height:8px"></div>
      <div class="grid">
        <div>
          <div class="label">Keberangkatan</div>
          <div class="value"><span class="time">Sen, 10 Des</span> • 04:00 PM</div>
        </div>
        <div>
          <div class="label">Kedatangan</div>
          <div class="value"><span class="time">Sel, 11 Des</span> • 07:00 AM</div>
        </div>
      </div>
    </div>
    <div class="section">
      <div class="row">
        <div class="col">
          <div class="label">Kelas</div>
          <div class="value">Bisnis</div>
        </div>
        <div class="col">
          <div class="label">Bagasi</div>
          <div class="value">20kg</div>
        </div>
      </div>
    </div>
    <div class="section">
      <div class="barcode-wrap">
        <div class="barcode"></div>
        <div class="barcode-text">|||| ||||| || ||||| |||</div>
      </div>
      <div style="height:8px"></div>
      <div class="note">Simpan tiket ini dan tunjukkan saat check-in.</div>
    </div>
  </div>
  <div class="btn-print"><button onclick="window.print()">Cetak</button></div>
  <script>window.print()</script>
</body>
</html>
''';
}

// Versi teks polos yang rapi
String _ticketPlainTextPretty() {
  return '''
Tiket Penerbangan

Nama     : Tria Agustin
Maskapai : LionAir
Rute     : Jakarta → Bali
Keberangkatan : Sen, 10 Des 04:00 PM
Kedatangan   : Sel, 11 Des 07:00 AM
Kelas    : Bisnis
Bagasi   : 20kg
''';
}

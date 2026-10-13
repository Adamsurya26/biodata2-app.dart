import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

// =====================================================================
// MODEL
// =====================================================================

/// Satu baris riwayat. Dipakai untuk Pendidikan dan Pekerjaan,.
class Riwayat {
  final String judul;
  final String subjudul;
  final String periode;
  const Riwayat(this.judul, this.subjudul, this.periode);
}

/// Kategori riwayat beserta nama, ikon, dan label isian formnya.
class Kategori {
  final String nama;
  final IconData ikon;
  final List<String> labels;

  const Kategori(this.nama, this.ikon, this.labels);

  static const pendidikan = Kategori
    ('Pendidikan',
      Icons.school,
      ['Teknik Informatika', 'Universitas Esa Unggul, 2022 - Sekarang'],
  );

  static const pekerjaan = Kategori
    ('Pekerjaan',
      Icons.work,
      ['Store Keeper', 'PT. First Jakarta International','2020 - Sekarang'],
  );
}

/// Data nilai.
class Nilai {
  final String nim;
  final String nama;
  final String mataKuliah;
  final double tugasIndividu;
  final double uts;
  final double uas;
  final double quiz;
  final double tugasProject;
  final double absensi;

  const Nilai({
    required this.nim,
    required this.nama,
    required this.mataKuliah,
    required this.tugasIndividu,
    required this.uts,
    required this.uas,
    required this.quiz,
    required this.tugasProject,
    required this.absensi,
  });

  /// Bobot: Tugas Individu 15%, UTS 15%, UAS 20%, Quiz 5%, Tugas Project 40%, Absensi 5%
  double get akhir => tugasIndividu * 0.15 + uts * 0.15 + uas * 0.20 +
      quiz * 0.05 + tugasProject * 0.40 + absensi * 0.05;

  String get grade {
    final n = akhir;
    if (n >= 85) return 'A';
    if (n >= 70) return 'B';
    if (n >= 60) return 'C';
    if (n >= 50) return 'D';
    return 'E';
  }
}

// =====================================================================
// STATE MANAGEMENT (Provider + ChangeNotifier)
// =====================================================================

/// State untuk Menu 1: Biodata Mahasiswa
class BiodataProvider extends ChangeNotifier {
  final Map<String, String> _pribadi = {
    'Nama Lengkap': 'Adam Surya Budiansyah',
    'NIM': '20220801543',
    'Tempat, Tanggal Lahir': 'Jakarta, 22 Januari 2000',
    'Jenis Kelamin': 'Laki-laki',
    'Alamat': 'Mutiara Gading City Blok D12/20',
    'No. Telepon': '0896-3172-8199',
    'Email': 'Adamsurya555@student.esaunggul.ac.id',
  };

  final Map<Kategori, List<Riwayat>> _riwayat = {
    Kategori.pendidikan: [
      const Riwayat('SD', 'SDN Lagoa 02 Jakarta', '2006-2012'),
      const Riwayat('SMP', 'SMP Attaqwa 02 Bekasi', '2012 - 2015'),
      const Riwayat('SMA', 'SMK Attaqwa 01 Bekasi', '2015 - 2018'),
      const Riwayat('S1 Teknik Informatika', 'Universitas Esa Unggul',
          '2022 - sekarang'),
    ],
    Kategori.pekerjaan: [
      const Riwayat('Kasir', 'Transera Waterpark', '2019 - 2020'),
      const Riwayat('Store Keeper', 'PT. First Jakarta International',
          '2020 - sekarang'),
    ],
  };

  Map<String, String> get pribadi => _pribadi;

  List<Riwayat> riwayat(Kategori k) => _riwayat[k]!;

  void ubahPribadi(List<String> nilaiBaru) {
    final keys = _pribadi.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      _pribadi[keys[i]] = nilaiBaru[i];
    }
    notifyListeners();
  }

  void tambahRiwayat(Kategori k, Riwayat r) {
    _riwayat[k]!.add(r);
    notifyListeners();
  }

  void hapusRiwayat(Kategori k, int index) {
    _riwayat[k]!.removeAt(index);
    notifyListeners();
  }
}

/// State untuk Menu 2: Nilai Mahasiswa
class NilaiProvider extends ChangeNotifier {
  final List<Nilai> _daftar = [
    const Nilai(
      nim: '20220801543',
      nama: 'Adam Surya Budiansyah',
      mataKuliah: 'Pemrograman Mobile',
      tugasIndividu: 85,
      uts: 80,
      uas: 80,
      quiz: 75,
      tugasProject: 75,
      absensi: 85,
    ),
    const Nilai(
      nim: '20220801543',
      nama: 'Adam Surya Budiansyah',
      mataKuliah: 'Algoritma',
      tugasIndividu: 70,
      uts: 65,
      uas: 75,
      quiz: 75,
      tugasProject: 75,
      absensi: 80,
    ),
    const Nilai(
      nim: '20220801543',
      nama: 'Adam Surya Budiansyah',
      mataKuliah: 'Basis data',
      tugasIndividu:  75,
      uts: 75,
      uas: 75,
      quiz: 85,
      tugasProject: 78,
      absensi: 85,
    ),
  ];

  List<Nilai> get daftar => _daftar;

  void tambah(Nilai n) {
    _daftar.add(n);
    notifyListeners();
  }

  void hapus(Nilai n) {
    _daftar.remove(n);
    notifyListeners();
  }
}

/// State untuk Menu 3: Profil Pengguna (termasuk mode gelap)
class ProfilProvider extends ChangeNotifier {
  String nama = 'Adam Surya Budiansyah';
  String username = 'Adamsurya2000';
  String email = 'Adamsurya555@student.esaunggul.ac.id';
  bool modeGelap = false;

  File? foto;

  void ubahFoto(File fileBaru) {
    foto = fileBaru;
    notifyListeners();
  }

  void ubahProfil(String namaBaru, String usernameBaru, String emailBaru) {
    nama = namaBaru;
    username = usernameBaru;
    email = emailBaru;
    notifyListeners();
  }

  void setModeGelap(bool nilai) {
    modeGelap = nilai;
    notifyListeners();
  }
}

// =====================================================================
// MAIN
// =====================================================================

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BiodataProvider()),
        ChangeNotifierProvider(create: (_) => NilaiProvider()),
        ChangeNotifierProvider(create: (_) => ProfilProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

ThemeData _buatTema(Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: brightness,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      centerTitle: false,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Tema ikut berubah otomatis saat switch di halaman Profil diubah
    final gelap = context.watch<ProfilProvider>().modeGelap;

    return MaterialApp(
      title: 'Aplikasi Biodata Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: _buatTema(Brightness.light),
      darkTheme: _buatTema(Brightness.dark),
      themeMode: gelap ? ThemeMode.dark : ThemeMode.light,
      home: const HomePage(),
    );
  }
}

// =====================================================================
// HALAMAN UTAMA (menu di bagian bawah)
// =====================================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indeks = 0;

  static const _halaman = [BiodataPage(), NilaiPage(), ProfilPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _halaman[_indeks],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indeks,
        onDestinationSelected: (i) => setState(() => _indeks = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.badge_outlined),
            selectedIcon: Icon(Icons.badge),
            label: 'Biodata',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Nilai',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// FUNGSI BANTU: dialog form dengan beberapa isian teks
// =====================================================================

Future<List<String>?> tampilkanFormDialog(
    BuildContext context, {
      required String judul,
      required List<String> labels,
      List<String>? nilaiAwal,
    }) {
  final controllers = List.generate(
    labels.length,
        (i) => TextEditingController(text: nilaiAwal != null ? nilaiAwal[i] : ''),
  );

  return showDialog<List<String>>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(judul),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < labels.length; i++)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: controllers[i],
                  decoration: InputDecoration(
                    labelText: labels[i],
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(
            ctx,
            controllers.map((c) => c.text.trim()).toList(),
          ),
          child: const Text('Simpan'),
        ),
      ],
    ),
  );
}

// =====================================================================
// MENU 1: BIODATA MAHASISWA
// (Pribadi, Pendidikan, Pekerjaan)
// =====================================================================

class BiodataPage extends StatelessWidget {
  const BiodataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Biodata Mahasiswa'),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Pribadi'),
              Tab(text: 'Pendidikan'),
              Tab(text: 'Pekerjaan'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PribadiTab(),
            RiwayatTab(kategori: Kategori.pendidikan),
            RiwayatTab(kategori: Kategori.pekerjaan),
          ],
        ),
      ),
    );
  }
}

class PribadiTab extends StatelessWidget {
  const PribadiTab({super.key});

  static const _ikon = [
    Icons.person,
    Icons.badge,
    Icons.cake,
    Icons.wc,
    Icons.home,
    Icons.phone,
    Icons.email,
  ];

  @override
  Widget build(BuildContext context) {
    final data = context.watch<BiodataProvider>().pribadi;
    final entri = data.entries.toList();

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          child: Column(
            children: [
              for (int i = 0; i < entri.length; i++) ...[
                ListTile(
                  leading: Icon(_ikon[i], color: Colors.blue),
                  title: Text(
                    entri[i].key,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  subtitle: Text(
                    entri[i].value,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                if (i < entri.length - 1) const Divider(height: 1),
              ],
            ],
          ),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          icon: const Icon(Icons.edit),
          label: const Text('Ubah biodata'),
          onPressed: () async {
            final hasil = await tampilkanFormDialog(
              context,
              judul: 'Ubah Biodata Pribadi',
              labels: data.keys.toList(),
              nilaiAwal: data.values.toList(),
            );
            if (hasil != null && context.mounted) {
              context.read<BiodataProvider>().ubahPribadi(hasil);
            }
          },
        ),
      ],
    );
  }
}

class RiwayatTab extends StatelessWidget {
  final Kategori kategori;
  const RiwayatTab({super.key, required this.kategori});

  @override
  Widget build(BuildContext context) {
    final daftar = context.watch<BiodataProvider>().riwayat(kategori);

    return Scaffold(
      body: daftar.isEmpty
          ? Center(
        child: Text(
          'Belum ada data ${kategori.nama.toLowerCase()}'
              '.\nTekan tombol + untuk menambah.',
          textAlign: TextAlign.center,
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 80),
        itemCount: daftar.length,
        itemBuilder: (context, i) {
          final r = daftar[i];
          return Card(
            child: ListTile(
              leading: Icon(kategori.ikon, color: Colors.blue),
              title: Text(
                r.judul,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('${r.subjudul}\n${r.periode}'),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Hapus',
                onPressed: () => context
                    .read<BiodataProvider>()
                    .hapusRiwayat(kategori, i),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        tooltip: 'Tambah ${kategori.nama.toLowerCase()}',
        onPressed: () async {
          final hasil = await tampilkanFormDialog(
            context,
            judul: 'Tambah ${kategori.nama}',
            labels: kategori.labels,
          );
          if (hasil != null && hasil[0].isNotEmpty && context.mounted) {
            context
                .read<BiodataProvider>()
                .tambahRiwayat(kategori, Riwayat(hasil[0], hasil[1], hasil[2]));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// =====================================================================
// MENU 2: NILAI MAHASISWA (ListView -> Detail -> Form tambah)
// =====================================================================

class NilaiPage extends StatelessWidget {
  const NilaiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final daftar = context.watch<NilaiProvider>().daftar;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Nilai'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Tambah nilai',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FormNilaiPage()),
            ),
          ),
        ],
      ),
      body: daftar.isEmpty
          ? const Center(
        child: Text('Belum ada data nilai.\nTekan + untuk menambah.',
            textAlign: TextAlign.center),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 6),
        itemCount: daftar.length,
        itemBuilder: (context, i) {
          final n = daftar[i];
          return Card(
            margin:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ListTile(
              title: Text(n.nama),
              subtitle: Text(
                '${n.mataKuliah}  |  Nilai akhir ${n.akhir.toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 12),
              ),
              trailing: CircleAvatar(
                radius: 16,
                child: Text(n.grade),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailNilaiPage(nilai: n),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FormNilaiPage extends StatefulWidget {
  const FormNilaiPage({super.key});

  @override
  State<FormNilaiPage> createState() => _FormNilaiPageState();
}

  class _FormNilaiPageState extends State<FormNilaiPage> {
  final _formKey = GlobalKey<FormState>();
  final _nim = TextEditingController();
  final _nama = TextEditingController();
  final _mataKuliah = TextEditingController();
  final _tugasIndividu = TextEditingController();
  final _uts = TextEditingController();
  final _uas = TextEditingController();
  final _quiz = TextEditingController();
  final _tugasProject = TextEditingController();
  final _absensi = TextEditingController();

  @override
  void dispose() {
    for (final c in [_nim, _nama, _mataKuliah, _tugasIndividu, _uts,
      _uas, _quiz, _tugasProject, _absensi]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _wajibIsi(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null;

  String? _validasiNilai(String? v) {
    if (v == null || v.trim().isEmpty) return 'Wajib diisi';
    final angka = double.tryParse(v.trim());
    if (angka == null) return 'Harus berupa angka';
    if (angka < 0 || angka > 100) return 'Nilai harus 0 - 100';
    return null;
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    context.read<NilaiProvider>().tambah(
      Nilai(
        nim: _nim.text.trim(),
        nama: _nama.text.trim(),
        mataKuliah: _mataKuliah.text.trim(),
        tugasIndividu: double.parse(_tugasIndividu.text.trim()),
        uts: double.parse(_uts.text.trim()),
        uas: double.parse(_uas.text.trim()),
        quiz: double.parse(_quiz.text.trim()),
        tugasProject: double.parse(_tugasProject.text.trim()),
        absensi: double.parse(_absensi.text.trim()),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nilai berhasil disimpan')),
    );
    Navigator.pop(context);
  }

  Widget _isian(
      TextEditingController controller,
      String label,
      String? Function(String?) validator, {
        TextInputType? keyboard,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const angka = TextInputType.numberWithOptions(decimal: true);

    return Scaffold(
      appBar: AppBar(title: const Text('Form Nilai Mahasiswa')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _isian(_nim, 'NIM', _wajibIsi, keyboard: TextInputType.number),
            _isian(_nama, 'Nama Mahasiswa', _wajibIsi),
            _isian(_mataKuliah, 'Mata Kuliah', _wajibIsi),
            _isian(_tugasIndividu, 'Nilai Tugas (15%)', _validasiNilai,
                keyboard: angka),
            _isian(_uts, 'Nilai UTS (15%)', _validasiNilai, keyboard: angka),
            _isian(_uas, 'Nilai UAS (20%)', _validasiNilai, keyboard: angka),
            _isian(_quiz,'Nilai Quiz (5%)', _validasiNilai, keyboard: angka),
            _isian(_tugasProject, 'Nilai Tugas Project (40%)', _validasiNilai,
                keyboard: angka),
            _isian(_absensi, 'Nilai Absensi (5%)', _validasiNilai,
                keyboard: angka),
            const SizedBox(height: 4),
            FilledButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Simpan nilai'),
              onPressed: _simpan,
            ),
          ],
        ),
      ),
    );
  }
}

class DetailNilaiPage extends StatelessWidget {
  final Nilai nilai;
  const DetailNilaiPage({super.key, required this.nilai});

  @override
  Widget build(BuildContext context) {
    final baris = [
      ['NIM', nilai.nim],
      ['Nama Mahasiswa', nilai.nama],
      ['Mata Kuliah', nilai.mataKuliah],
      ['Nilai Tugas Individu (15%)', nilai.tugasIndividu.toStringAsFixed(1)],
      ['Nilai UTS (15%)', nilai.uts.toStringAsFixed(1)],
      ['Nilai UAS (20%)', nilai.uas.toStringAsFixed(1)],
      ['Nilai Quiz (5%)', nilai.quiz.toStringAsFixed(1)],
      ['Nilai Tugas Project (40%)', nilai.tugasProject.toStringAsFixed(1)],
      ['Nilai Absensi (5%)', nilai.absensi.toStringAsFixed(1)],
      ['Nilai Akhir', nilai.akhir.toStringAsFixed(2)],
      ['Grade', nilai.grade],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Nilai'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Hapus nilai',
            onPressed: () {
              context.read<NilaiProvider>().hapus(nilai);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Nilai dihapus')),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: Column(
              children: [
                for (final b in baris)
                  ListTile(
                    dense: true,
                    title: Text(b[0]),
                    trailing: Text(
                      b[1],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// MENU 3: PROFIL PENGGUNA
// =====================================================================

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  Future<void> _pilihFoto(BuildContext context) async {
    final hasil = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (hasil != null && context.mounted) {
      context.read<ProfilProvider>().ubahFoto(File(hasil.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ProfilProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Pengguna')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 8),
          Center(
            child: Stack(
              children: [
              CircleAvatar(
              radius: 55,
              backgroundImage: p.foto != null
                  ? FileImage(p.foto!)
                  : const AssetImage('assets/images/foto.jpeg')
              as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.blue,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.camera_alt,
                          size: 18, color: Colors.white),
                      onPressed: () => _pilihFoto(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              p.nama,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(p.email, style: const TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: const Text('Nama'),
                  subtitle: Text(p.nama),
                ),
                const Divider(height: 1),
                ListTile(
                  leading:
                  const Icon(Icons.alternate_email, color: Colors.blue),
                  title: const Text('Username'),
                  subtitle: Text(p.username),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.blue),
                  title: const Text('Email'),
                  subtitle: Text(p.email),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode, color: Colors.blue),
                  title: const Text('Mode gelap'),
                  value: p.modeGelap,
                  onChanged: (v) =>
                      context.read<ProfilProvider>().setModeGelap(v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text('Ubah profil'),
            onPressed: () async {
              final hasil = await tampilkanFormDialog(
                context,
                judul: 'Ubah Profil',
                labels: const ['Nama', 'Username', 'Email'],
                nilaiAwal: [p.nama, p.username, p.email],
              );
              if (hasil != null && context.mounted) {
                context
                    .read<ProfilProvider>()
                    .ubahProfil(hasil[0], hasil[1], hasil[2]);
              }
            },
          ),
        ],
      ),
    );
  }
}
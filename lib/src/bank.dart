/// Satu entri bank.
class Bank {
  const Bank({required this.nama, required this.sandi});

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
        nama: json['nama_bank'] as String,
        sandi: json['sandi_bank'] as String,
      );

  /// Nama bank (`nama_bank`).
  final String nama;

  /// Sandi bank (`sandi_bank`), string agar nol di depan tetap ada (mis. `001`).
  /// Tidak unik: `022` dipakai CIMB Niaga dan Unit Usaha Syariah-nya.
  final String sandi;

  /// Perkiraan bank syariah berdasarkan nama (mengandung kata "syariah").
  /// Heuristik, bukan data resmi.
  bool get isSyariah => nama.toLowerCase().contains('syariah');

  Map<String, String> toJson() => {'nama_bank': nama, 'sandi_bank': sandi};

  @override
  bool operator ==(Object other) =>
      other is Bank && other.nama == nama && other.sandi == sandi;

  @override
  int get hashCode => Object.hash(nama, sandi);

  @override
  String toString() => 'Bank($sandi, $nama)';
}

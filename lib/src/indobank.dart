import 'dart:convert';

import 'bank.dart';
import 'bank_data.g.dart';

/// Akses daftar bank Indonesia. Semua data tertanam, tanpa async.
///
/// Sumber data: Tabel Sandi Bank resmi BCA per 31 Maret 2026.
abstract final class IndoBank {
  static final List<Bank> _banks = List.unmodifiable([
    for (final (nama, sandi) in bankData) Bank(nama: nama, sandi: sandi),
  ]);

  /// Semua bank (tidak bisa diubah).
  static List<Bank> get banks => _banks;

  /// Mencari bank berdasarkan sebagian nama. Huruf besar/kecil, tanda baca,
  /// dan spasi ganda diabaikan. Query kosong mengembalikan semua bank.
  static List<Bank> search(String name) {
    final needle = _normalize(name);
    if (needle.isEmpty) return _banks;
    return _banks.where((b) => _normalize(b.nama).contains(needle)).toList();
  }

  /// Mencari satu bank dengan kecocokan persis pada kolom [key]
  /// (`nama_bank` atau `sandi_bank`). Mengembalikan yang pertama, atau `null`.
  static Bank? find(String key, String value) {
    for (final b in _banks) {
      switch (key) {
        case 'nama_bank':
          if (b.nama == value) return b;
        case 'sandi_bank':
          if (b.sandi == value) return b;
      }
    }
    return null;
  }

  /// Semua bank dengan sandi [code]. Sandi tidak unik.
  static List<Bank> findBySandi(String code) =>
      _banks.where((b) => b.sandi == code).toList();

  /// Bank yang namanya mengandung "syariah" (heuristik).
  static List<Bank> get syariah => _banks.where((b) => b.isSyariah).toList();

  /// Ekspor semua bank sebagai string JSON.
  static String toJson() => jsonEncode(_banks.map((b) => b.toJson()).toList());

  static String _normalize(String s) => s
      .toLowerCase()
      .replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), ' ')
      .trim();
}

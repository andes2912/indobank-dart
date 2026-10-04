# indobank (Dart/Flutter)

Daftar bank di Indonesia (nama dan sandi bank) untuk Dart dan Flutter. Data tertanam sebagai `const` list: tanpa database, tanpa jaringan, tanpa asset tambahan, dan semua sinkron (bukan `Future`).

Versi PHP/Laravel: [andes2912/indobank](https://github.com/andes2912/indobank). Versi Go: [andes2912/indobank-go](https://github.com/andes2912/indobank-go).

Data diambil dari **Tabel Sandi Bank resmi BCA per 31 Maret 2026** (123 entri bank umum dan Unit Usaha Syariah).

## Instalasi

```
dart pub add indobank
# atau di proyek Flutter:
flutter pub add indobank
```

## Pemakaian

```dart
import 'package:indobank/indobank.dart';

// Semua bank
final semua = IndoBank.banks;

// Pencarian sebagian nama (abaikan huruf besar/kecil, tanda baca, spasi ganda)
final hasil = IndoBank.search('bri');

// Kecocokan persis berdasarkan kolom
final bca = IndoBank.find('sandi_bank', '014');

// Semua bank dengan sandi tertentu (sandi tidak unik)
final cimb = IndoBank.findBySandi('022');

// Bank syariah (heuristik berdasarkan nama)
final syariah = IndoBank.syariah;

// Ekspor JSON
final json = IndoBank.toJson();
```

Contoh dropdown di Flutter:

```dart
DropdownButton<Bank>(
  items: [
    for (final b in IndoBank.banks)
      DropdownMenuItem(value: b, child: Text('${b.sandi} - ${b.nama}')),
  ],
  onChanged: (b) {},
)
```

## API

| Anggota | Keterangan |
|---|---|
| `IndoBank.banks` | Semua bank (tidak bisa diubah). |
| `IndoBank.search(name)` | Cari berdasarkan sebagian nama. Query kosong mengembalikan semua. |
| `IndoBank.find(key, value)` | Cocok persis pada `nama_bank` atau `sandi_bank`; `Bank?`. |
| `IndoBank.findBySandi(code)` | Semua bank dengan sandi tersebut. |
| `IndoBank.syariah` | Bank yang namanya mengandung "syariah". |
| `IndoBank.toJson()` | Semua bank sebagai string JSON. |
| `Bank.nama`, `Bank.sandi` | Sandi berupa `String` agar nol di depan tetap ada (mis. `001`). |
| `Bank.isSyariah` | Heuristik nama, bukan data resmi. |

> Sandi bank tidak unik. Contoh: `022` dipakai Bank CIMB Niaga dan Unit Usaha Syariah-nya. Gunakan `findBySandi` bila perlu semua yang cocok.

## Memperbarui data

1. Ganti `tool/bank.csv` (format sama dengan repo PHP: `"nama_bank",sandi_bank`).
2. `dart run tool/generate.dart` (membuat ulang `lib/src/bank_data.g.dart`, jangan diedit tangan).
3. Sesuaikan jumlah di test `jumlah bank` bila berubah, lalu `dart test`.

## Lisensi

MIT

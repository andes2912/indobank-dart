// Membuat lib/src/bank_data.g.dart dari tool/bank.csv.
//
// Jalankan setelah mengganti tool/bank.csv:
//   dart run tool/generate.dart
import 'dart:io';

void main() {
  final lines = File('tool/bank.csv')
      .readAsLinesSync()
      .where((l) => l.trim().isNotEmpty)
      .skip(1); // header

  final row = RegExp(r'^"(.*)",\s*"?([^",]*)"?\s*$');
  final out = StringBuffer()
    ..writeln('// GENERATED FILE. Jangan diedit tangan.')
    ..writeln('// Sumber: tool/bank.csv, dibuat oleh `dart run tool/generate.dart`.')
    ..writeln()
    ..writeln('// ignore_for_file: lines_longer_than_80_chars')
    ..writeln()
    ..writeln('const List<(String, String)> bankData = [');

  for (final line in lines) {
    final m = row.firstMatch(line);
    if (m == null) {
      stderr.writeln('Baris tidak valid: $line');
      exit(1);
    }
    final nama = m.group(1)!.replaceAll(r'\', r'\\').replaceAll("'", r"\'");
    out.writeln("  ('$nama', '${m.group(2)}'),");
  }
  out.writeln('];');

  File('lib/src/bank_data.g.dart').writeAsStringSync(out.toString());
  stdout.writeln('lib/src/bank_data.g.dart dibuat.');
}

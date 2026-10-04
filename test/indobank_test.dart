import 'dart:convert';

import 'package:indobank/indobank.dart';
import 'package:test/test.dart';

void main() {
  test('jumlah bank', () => expect(IndoBank.banks.length, 123));

  test('daftar tidak bisa diubah', () {
    expect(() => IndoBank.banks.add(const Bank(nama: 'X', sandi: '1')),
        throwsUnsupportedError);
  });

  test('sandi mempertahankan nol di depan', () {
    expect(IndoBank.find('nama_bank', 'BANK INDONESIA')?.sandi, '001');
  });

  test('search case-insensitive dan partial', () {
    expect(IndoBank.search('mandiri'), isNotEmpty);
    expect(IndoBank.search('MANDIRI').length, IndoBank.search('mandiri').length);
  });

  test('search mengabaikan tanda baca dan spasi ganda', () {
    expect(IndoBank.search('bank   bri'), isNotEmpty);
    expect(IndoBank.search('(bank rakyat indonesia)'), isNotEmpty);
  });

  test('search kosong mengembalikan semua', () {
    expect(IndoBank.search('').length, IndoBank.banks.length);
  });

  test('find BCA dan yang tidak ada', () {
    expect(IndoBank.find('sandi_bank', '014'), isNotNull);
    expect(IndoBank.find('sandi_bank', 'xyz'), isNull);
    expect(IndoBank.find('kolom_tidak_ada', '014'), isNull);
  });

  test('findBySandi: 022 tidak unik', () {
    expect(IndoBank.findBySandi('022').length, greaterThanOrEqualTo(2));
  });

  test('syariah', () {
    expect(IndoBank.syariah, isNotEmpty);
    expect(IndoBank.syariah.every((b) => b.isSyariah), isTrue);
  });

  test('toJson', () {
    final list = jsonDecode(IndoBank.toJson()) as List;
    expect(list.length, 123);
    expect((list.first as Map)['sandi_bank'], '001');
    expect(Bank.fromJson(list.first as Map<String, dynamic>),
        IndoBank.banks.first);
  });
}

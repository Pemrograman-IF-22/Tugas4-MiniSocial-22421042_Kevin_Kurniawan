// barang_controller.dart
import '../models/item.dart';

class BarangController {
  static final BarangController _instance = BarangController._internal();
  factory BarangController() => _instance;

  BarangController._internal();

  final List<Barang> _barangList = [];

  Future<List<Barang>> getAllBarang() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _barangList;
  }

  Future<void> addBarang(String nama, String deskripsi, String imageUrl, double harga) async {
    _barangList.add(
      Barang(
        id: DateTime.now().toIso8601String(),
        nama: nama,
        deskripsi: deskripsi,
        imageUrl: imageUrl,
        harga: harga,
      ),
    );
  }

  Future<void> updateBarang(String id, String nama, String deskripsi, String imageUrl, double harga) async {
    final index = _barangList.indexWhere((item) => item.id == id);
    if (index != -1) {
      _barangList[index] = Barang(
        id: id,
        nama: nama,
        deskripsi: deskripsi,
        imageUrl: imageUrl,
        harga: harga,
      );
    }
  }

  Future<bool> deleteBarang(String id) async {
    _barangList.removeWhere((item) => item.id == id);
    return true;
  }
}
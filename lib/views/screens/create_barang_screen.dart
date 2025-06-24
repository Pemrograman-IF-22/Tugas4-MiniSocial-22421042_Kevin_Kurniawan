// create_barang_screen.dart
import 'package:flutter/material.dart';
import '../../controllers/barang_controller.dart';
import '../../models/item.dart';

class CreateBarangScreen extends StatefulWidget {
  final Barang? editBarang;
  const CreateBarangScreen({super.key, this.editBarang});

  @override
  State<CreateBarangScreen> createState() => _CreateBarangScreenState();
}

class _CreateBarangScreenState extends State<CreateBarangScreen> {
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _hargaController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final BarangController _controller = BarangController();

  @override
  void initState() {
    super.initState();
    if (widget.editBarang != null) {
      _namaController.text = widget.editBarang!.nama;
      _deskripsiController.text = widget.editBarang!.deskripsi;
      _hargaController.text = widget.editBarang!.harga.toString();
      _imageUrlController.text = widget.editBarang!.imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editBarang != null ? 'Edit Barang' : 'Tambah Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama Barang'),
            ),
            TextField(
              controller: _deskripsiController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            TextField(
              controller: _hargaController,
              decoration: const InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL (optional)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final nama = _namaController.text;
                final deskripsi = _deskripsiController.text;
                final harga = double.tryParse(_hargaController.text) ?? 0;
                final imageUrl = _imageUrlController.text;

                if (widget.editBarang == null) {
                  await _controller.addBarang(
                    nama,
                    deskripsi,
                    imageUrl,
                    harga,
                  );
                } else {
                  await _controller.updateBarang(
                    widget.editBarang!.id,
                    nama,
                    deskripsi,
                    imageUrl,
                    harga,
                  );
                }

                if (context.mounted) {
                  Navigator.pop(context, true);
                }
              },
              child: Text(widget.editBarang == null ? 'Simpan' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }
}
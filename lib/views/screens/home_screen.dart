// home_screen.dart
import 'package:flutter/material.dart';
import '../../controllers/barang_controller.dart';
import '../../models/item.dart';
import 'create_barang_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BarangController _controller = BarangController();
  List<Barang> _barangList = [];

  @override
  void initState() {
    super.initState();
    _loadBarang();
  }

  Future<void> _loadBarang() async {
    final items = await _controller.getAllBarang();
    setState(() {
      _barangList = items;
    });
  }

  void _addBarang() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateBarangScreen()),
    );
    if (result == true) _loadBarang();
  }

  void _editBarang(Barang barang) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreateBarangScreen(editBarang: barang)),
    );
    if (result == true) _loadBarang();
  }

  Future<void> _deleteBarang(String id) async {
    await _controller.deleteBarang(id);
    _loadBarang();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Barang')),
      body: _barangList.isEmpty
          ? const Center(child: Text('Belum ada barang.'))
          : ListView.builder(
              itemCount: _barangList.length,
              itemBuilder: (context, index) {
                final barang = _barangList[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: barang.imageUrl.isNotEmpty
                        ? Image.network(barang.imageUrl, width: 50, height: 50)
                        : const Icon(Icons.image),
                    title: Text(barang.nama),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(barang.deskripsi),
                        Text('Rp ${barang.harga}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editBarang(barang),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteBarang(barang.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addBarang,
        child: const Icon(Icons.add),
      ),
    );
  }
}
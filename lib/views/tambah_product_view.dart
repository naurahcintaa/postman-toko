import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:produktif_postman_toko1/services/product.dart';
import 'package:produktif_postman_toko1/widgets/alert.dart';
import 'package:produktif_postman_toko1/models/product_model.dart';

class ProductFormView extends StatefulWidget {
  final ProductModel? item;

  const ProductFormView({super.key, this.item});

  @override
  State<ProductFormView> createState() => _ProductFormViewState();
}

class _ProductFormViewState extends State<ProductFormView> {
  ProductService product = ProductService();

  final formKey = GlobalKey<FormState>();

  TextEditingController nama = TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  TextEditingController harga = TextEditingController();
  TextEditingController stok = TextEditingController();

  File? selectedImage;
  bool isLoading = false;

  // 📸 ambil gambar
  Future getImage() async {
    setState(() => isLoading = true);

    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        selectedImage = File(picked.path);
      });
    }

    setState(() => isLoading = false);
  }

  @override
  void initState() {
    super.initState();

    // 👉 kalau edit (update)
    if (widget.item != null) {
      nama.text = widget.item!.nama_barang ?? '';
      deskripsi.text = widget.item!.deskripsi ?? '';
      harga.text = widget.item!.harga.toString();
      stok.text = widget.item!.stok.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? "Tambah Produk" : "Edit Produk"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              // NAMA
              TextFormField(
                controller: nama,
                decoration: const InputDecoration(labelText: "Nama Barang"),
                validator: (v) => v!.isEmpty ? "Harus diisi" : null,
              ),

              // DESKRIPSI
              TextFormField(
                controller: deskripsi,
                decoration: const InputDecoration(labelText: "Deskripsi"),
                validator: (v) => v!.isEmpty ? "Harus diisi" : null,
              ),

              // HARGA
              TextFormField(
                controller: harga,
                decoration: const InputDecoration(labelText: "Harga"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Harus diisi" : null,
              ),

              // STOK
              TextFormField(
                controller: stok,
                decoration: const InputDecoration(labelText: "Stok"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Harus diisi" : null,
              ),

              const SizedBox(height: 20),

              // BUTTON PILIH GAMBAR
              ElevatedButton(
                onPressed: getImage,
                child: const Text("Pilih Gambar"),
              ),

              const SizedBox(height: 10),

              // PREVIEW GAMBAR
              selectedImage != null
                  ? Image.file(selectedImage!, height: 150)
                  : isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Belum pilih gambar"),

              const SizedBox(height: 20),

              // BUTTON SIMPAN
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    var result = await product.insertProduct(
                      id: widget.item?.id,
                      nama: nama.text,
                      deskripsi: deskripsi.text,
                      harga: harga.text,
                      stok: stok.text,
                      image: selectedImage,
                    );

                    if (result["status"] == true) {
                      AlertMessage.showSnackBar(
                        context,
                        message: result["message"],
                        status: true,
                      );
                      Navigator.pop(context);
                    } else {
                      AlertMessage.showSnackBar(
                        context,
                        message: result["message"],
                        status: false,
                      );
                    }
                  }
                },
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

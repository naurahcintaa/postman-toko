import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:produktif_postman_toko1/services/product.dart';
import 'package:produktif_postman_toko1/widgets/alert.dart';

class ProductFormView extends StatefulWidget {
  final dynamic item;
  const ProductFormView({super.key, this.item});

  @override
  State<ProductFormView> createState() => _ProductFormViewState();
}

class _ProductFormViewState extends State<ProductFormView> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nama = TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  TextEditingController harga = TextEditingController();
  TextEditingController stok = TextEditingController();

  File? imageFile;
  bool isLoading = false;

  ProductService product = ProductService();

  @override
  void initState() {
    super.initState();

    if (widget.item != null) {
      nama.text = widget.item.nama_barang ?? '';
      deskripsi.text = widget.item.deskripsi ?? '';
      harga.text = widget.item.harga.toString();
      stok.text = widget.item.stok.toString();
    }
  }

  // 📸 PICK IMAGE
  pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  // 💾 SAVE DATA (FIX DISINI)
  save() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      var result = await product.insertProduct(
        id: widget.item?.id,
        nama: nama.text,
        deskripsi: deskripsi.text,
        harga: harga.text,
        stok: stok.text,
        image: imageFile,
      );

      setState(() => isLoading = false);

      // ✅ HANDLE RESPONSE
      if (result["status"] == true) {
        AlertMessage.showSnackBar(
          context,
          message: result["message"] ?? "Berhasil",
          status: true,
        );

        Navigator.pop(context);
      } else {
        AlertMessage.showSnackBar(
          context,
          message: result["message"] ?? "Gagal",
          status: false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item == null ? "Tambah" : "Edit"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nama,
                decoration: const InputDecoration(labelText: "Nama"),
                validator: (v) => v!.isEmpty ? "Wajib isi" : null,
              ),

              TextFormField(
                controller: deskripsi,
                decoration: const InputDecoration(labelText: "Deskripsi"),
              ),

              TextFormField(
                controller: harga,
                decoration: const InputDecoration(labelText: "Harga"),
                keyboardType: TextInputType.number,
              ),

              TextFormField(
                controller: stok,
                decoration: const InputDecoration(labelText: "Stok"),
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: pickImage,
                child: const Text("Pilih Gambar"),
              ),

              const SizedBox(height: 10),

              if (imageFile != null)
                Image.file(imageFile!, height: 100),

              const SizedBox(height: 20),

              // ✅ BUTTON SAVE (ADA LOADING)
              ElevatedButton(
                onPressed: isLoading ? null : save,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:produktif_postman_toko1/services/url.dart' as url;

class ProductModel {
  int? id;
  String? title;
  String? deskripsi;
  int? stok;
  int? harga;
  String? image;

  ProductModel({
    this.id,
    this.title,
    this.deskripsi,
    this.stok,
    this.harga,
    this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      title: json["nama_barang"],
      deskripsi: json["deskripsi"],
      stok: json["stok"],
      harga: json["harga"],
      image: Uri.encodeFull(
        "${url.BaseUrlTanpaAPi}/toko/${json["image"]}",
      ),
    );
  }
}

import 'package:produktif_postman_toko1/services/url.dart' as url;

class ProductModel {
  int? id;
  String? nama_barang;
  String? deskripsi;
  int? stok;
  int? harga;
  String? image;

  ProductModel({
    this.id,
    this.nama_barang,
    this.deskripsi,
    this.stok,
    this.harga,
    this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      nama_barang: json["nama_barang"],
      deskripsi: json["deskripsi"],
      stok: json["stok"],
      harga: json["harga"],
      image: json["image"] != null
          ? "${url.BaseUrlTanpaAPi}/${json["image"]}"
          : null,
    );
  }
}

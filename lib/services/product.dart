import 'dart:convert';
import 'dart:io';
import 'package:produktif_postman_toko1/models/product_model.dart';
import 'package:produktif_postman_toko1/models/response_data_list.dart';
import 'package:produktif_postman_toko1/models/user_login.dart';
import 'package:produktif_postman_toko1/services/url.dart' as url;
import 'package:http/http.dart' as http;

class ProductService {

  // =======================
  // ✅ GET DATA PRODUCT
  // =======================
  Future<ResponseDataList> getProduct() async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    if (user.status == false) {
      return ResponseDataList(
        status: false,
        message: 'Belum login / token invalid',
      );
    }

    var uri = Uri.parse("${url.BaseUrl}/admin/getbarang"); // ✅ FIX

    try {
      var response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer ${user.token}",
          "Accept": "application/json",
        },
      );

      print("GET RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data["status"] == true) {
          List list = data["data"];

          List<ProductModel> products =
              list.map((e) => ProductModel.fromJson(e)).toList();

          return ResponseDataList(
            status: true,
            message: data["message"],
            data: products,
          );
        } else {
          return ResponseDataList(
            status: false,
            message: data["message"],
          );
        }
      } else {
        return ResponseDataList(
          status: false,
          message: "Error ${response.statusCode}",
        );
      }
    } catch (e) {
      print("ERROR: $e");
      return ResponseDataList(
        status: false,
        message: "Koneksi error",
      );
    }
  }

  // =======================
  // ✅ INSERT / UPDATE
  // =======================
  Future<Map<String, dynamic>> insertProduct({
    int? id,
    String? nama,
    String? deskripsi,
    String? harga,
    String? stok,
    File? image,
  }) async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    if (user.status == false) {
      return {
        "status": false,
        "message": "Belum login"
      };
    }

    var uri = Uri.parse(
      id == null
          ? "${url.BaseUrl}/admin/insertbarang"
          : "${url.BaseUrl}/admin/updatebarang/$id",
    );

    try {
      var request = http.MultipartRequest("POST", uri);

      request.headers.addAll({
        "Authorization": "Bearer ${user.token}",
        "Accept": "application/json",
      });

      request.fields["nama_barang"] = nama ?? '';
      request.fields["deskripsi"] = deskripsi ?? '';
      request.fields["harga"] = harga ?? '';
      request.fields["stok"] = stok ?? '';

      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath("image", image.path),
        );
      }

      var resStream = await request.send();
      var res = await http.Response.fromStream(resStream);

      print("INSERT RESPONSE: ${res.body}");

      return json.decode(res.body);
    } catch (e) {
      print("ERROR INSERT: $e");
      return {
        "status": false,
        "message": "Gagal upload"
      };
    }
  }

  // =======================
  // 🗑 DELETE
  // =======================
  Future<Map<String, dynamic>> deleteProduct(int id) async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();

    var uri = Uri.parse("${url.BaseUrl}/admin/hapusbarang/$id");

    try {
      var res = await http.delete(
        uri,
        headers: {
          "Authorization": "Bearer ${user.token}",
          "Accept": "application/json",
        },
      );

      return json.decode(res.body);
    } catch (e) {
      return {
        "status": false,
        "message": "Delete gagal"
      };
    }
  }
}
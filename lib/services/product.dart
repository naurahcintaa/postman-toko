import 'dart:convert';
import 'package:produktif_postman_toko1/models/product_model.dart';
import 'package:produktif_postman_toko1/models/response_data_list.dart';
import 'package:produktif_postman_toko1/models/user_login.dart';
import 'package:produktif_postman_toko1/services/url.dart' as url;
import 'package:http/http.dart' as http;

class ProductService {
  Future getProduct() async {
    UserLogin userLogin = UserLogin();
    var user = await userLogin.getUserLogin();
    print("TOKEN: ${user.token}"); // 👈 TARUH DI SINI
    if (user.status == false) {
      ResponseDataList response = ResponseDataList(
        status: false,
        message: 'anda belum login / token invalid',
      );
      return response;
    }
    var uri = Uri.parse(url.BaseUrl + "/admin/getbarang");
    Map<String, String> headers = {"Authorization": 'Bearer ${user.token}', "Accept": "application/json"};
    var getProduct = await http.get(uri, headers: headers);
    print("RESPONSE: ${getProduct.body}"); // 🔥 bonus debug
    if (getProduct.statusCode == 200 && getProduct.body.isNotEmpty) {
      var data = json.decode(getProduct.body);
      if (data["status"] == true) {
        List product = data["data"].map((r) => ProductModel.fromJson(r)).toList();
        ResponseDataList response = ResponseDataList(
          status: true, 
          message: 'success load data',
          data: product,
        );
        return response;
      } else {
        ResponseDataList response = ResponseDataList(
          status: false,
          message: 'Failed load data',
        );
        return response;
      }
    } else {
      ResponseDataList response = ResponseDataList(
        status: false,
        message: "gagal load product dengan code error ${getProduct.statusCode}",
      );
      return response;
    }
  }
}

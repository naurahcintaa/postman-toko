import 'package:flutter/material.dart';
import 'package:produktif_postman_toko1/models/response_data_list.dart';
import 'package:produktif_postman_toko1/widgets/alert.dart';
import 'package:produktif_postman_toko1/widgets/bottom_nav.dart';
import 'package:produktif_postman_toko1/services/product.dart';
import 'product_form_view.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  ProductService product = ProductService();
  List? barang;

  String baseUrl = "http://learn.smktelkom-mlg.sch.id/toko/api";

  getBarang() async {
    ResponseDataList res = await product.getProduct();
    setState(() {
      barang = res.data;
    });
  }

  @override
  void initState() {
    super.initState();
    getBarang();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ======================
      // ➕ TAMBAH
      // ======================
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProductFormView()),
          );
          getBarang();
        },
        child: const Icon(Icons.add),
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "https://media.istockphoto.com/id/1726740294/vector/pink-light-silky-background-luxury-pastel-satin-smooth-texture-banner-header-backdrop-design.jpg",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: barang == null
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: barang!.length,
                  itemBuilder: (context, index) {
                    var item = barang![index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListTile(
                        // ======================
                        // IMAGE
                        // ======================
                        leading: Builder(
                          builder: (context) {
                            print("IMAGE URL: ${item.image}");
                            return Image.network(
                              item.image ?? '',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print("IMAGE ERROR: $error");
                                return const Icon(Icons.broken_image);
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        // ======================
                        // TEXT
                        // ======================
                        title: Text(item.nama_barang ?? ''),
                        subtitle: Text(
                            "Rp ${item.harga} | Stok: ${item.stok}"),

                        // ======================
                        // MENU
                        // ======================
                        trailing: PopupMenuButton(
                          onSelected: (value) async {
                            if (value == "edit") {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ProductFormView(item: item),
                                ),
                              );
                              getBarang();
                            }

                            if (value == "delete") {
                              AlertMessage.showDeleteDialog(
                                context: context,
                                onConfirm: () async {
                                  var res = await product
                                      .deleteProduct(item.id);

                                  AlertMessage.showSnackBar(
                                    context,
                                    message: res["message"],
                                    status: res["status"],
                                  );

                                  getBarang();
                                },
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: "edit",
                              child: Text("Edit"),
                            ),
                            const PopupMenuItem(
                              value: "delete",
                              child: Text("Delete"),
                            ),
                          ],
                        ),

                        // ======================
                        // TAP = EDIT
                        // ======================
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductFormView(item: item),
                            ),
                          );
                          getBarang();
                        },
                      ),
                    );
                  },
                ),
        ),
      ),

      bottomNavigationBar: BottomNav(1),
    );
  }
}
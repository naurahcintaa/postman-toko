import 'package:flutter/material.dart';
import 'package:produktif_postman_toko1/models/response_data_list.dart';
import 'package:produktif_postman_toko1/widgets/bottom_nav.dart';
import 'package:produktif_postman_toko1/services/product.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  ProductService product = ProductService();
  List? barang;

  getBarang() async {
    ResponseDataList getProduct = await product.getProduct();
    setState(() {
      barang = getProduct.data;
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "https://media.istockphoto.com/id/1726740294/vector/pink-light-silky-background-luxury-pastel-satin-smooth-texture-banner-header-backdrop-design.jpg?s=612x612&w=0&k=20&c=0LpuI57meGEKzsiwZEcPpmy32qk-5Nl8MRXlNpNbDBc=",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                "Our Collection",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: barang != null
                    ? ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: barang!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                )
                              ],
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  "https://learn.smktelkom-mlg.sch.id/toko/api${barang![index].image}",
                                  width: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.broken_image, size: 60, color: Colors.grey);
                                  },
                                ),
                              ),
                              title: Text(
                                barang![index].title??'',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                "Rp ${barang![index].harga} | Stok: ${barang![index].stok}",
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(1),
    );
  }
}

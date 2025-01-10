import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:uni_store/models/product_model.dart';
import 'package:uni_store/screens/utilities/info_product.dart';

class ViewMore extends StatelessWidget {
  final String textTitileAppbar;
  final List<Product> data;

  const ViewMore(
      {super.key, required this.textTitileAppbar, required this.data});

  @override
  Widget build(BuildContext context) {
    final double availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: availableHeight / 7,
          width: double.infinity,
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.orange, Colors.orangeAccent])),
            padding: const EdgeInsets.all(10.0),
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Lottie.asset("assets/lotties/arrow_left.json",
                        width: 30, height: 30, fit: BoxFit.contain),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    textTitileAppbar,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 230),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => InfoProduct(
                      data: data[index],
                    ),
                  )),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: data[index].thumbnail,
                              progressIndicatorBuilder:
                                  (context, url, progress) => Lottie.asset(
                                      "/lotties/loading.json",
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.contain),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            data[index].title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            data[index].description,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            runAlignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                "\$ ${((data[index].price) / (1 - data[index].discountPercentage / 100)).toStringAsFixed(2)}",
                                style: const TextStyle(
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "\$ ${data[index].price}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    ));
  }
}

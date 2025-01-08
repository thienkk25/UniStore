import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readmore/readmore.dart';
import 'package:shop_fashion/services/notify_service.dart';

class Notify extends ConsumerWidget {
  const Notify({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double availableHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    List<String> dataNotify = ref.watch(notifyNotifierProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: availableHeight / 7,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(
                            Icons.chevron_left_outlined,
                            size: 30,
                          )),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        "Notifier",
                        style: TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: dataNotify.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    child: Container(
                      margin:
                          const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Thông báo",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ReadMoreText(
                            dataNotify[index],
                            style: const TextStyle(color: Colors.grey),
                            trimMode: TrimMode.Line,
                            trimLines: 2,
                            colorClickableText: Colors.black,
                            trimCollapsedText: 'Show more',
                            trimExpandedText: 'Show less',
                            moreStyle: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold),
                            lessStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

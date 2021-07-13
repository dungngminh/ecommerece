import 'package:badges/badges.dart';
import 'package:ecommerce/models/product.dart';
import 'package:ecommerce/screens/inner_screen/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedsProduct extends StatefulWidget {
  @override
  _FeedsProductState createState() => _FeedsProductState();
}

class _FeedsProductState extends State<FeedsProduct> {
  @override
  Widget build(BuildContext context) {
    final productAtributte = Provider.of<Product>(context);
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(ProductDetail.routeName),
        child: Container(
          width: 250,
          height: 290,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: 100,
                        maxHeight: size.height * 0.3,
                      ),
                      child: Image.network(
                        productAtributte.imageSrc,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Badge(
                      //want to change location of badge ? wrap it with Align or Postioned
                      toAnimate: true,
                      animationType: BadgeAnimationType.scale,
                      shape: BadgeShape.square,
                      badgeColor: Colors.deepPurple,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                      ),
                      badgeContent: const Text(
                        'New',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                margin: const EdgeInsets.only(left: 5, bottom: 2, right: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      productAtributte.title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        '\$ ${productAtributte.price}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Text(
                            'Quantity:',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${productAtributte.quantity}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ]),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(18),
                            child: const Icon(
                              Icons.more_horiz,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

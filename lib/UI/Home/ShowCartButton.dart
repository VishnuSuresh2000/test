import 'package:beru/BLOC/CustomeStream/CartStream.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';

class ShowCartButton extends StatelessWidget {
  const ShowCartButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: SizedBox(
        width: 35,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Icon(
                Icons.shopping_cart,
              ),
            ),
            Selector<CartData, int>(
                builder: (context, value, child) {
                  if (value == 0) {
                    return Offstage();
                  } else {
                    return Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.red),
                          child: SizedBox(
                            height: 16,
                            width: 16,
                            child: "$value"
                                .text
                                .textStyle(Theme.of(context)
                                    .textTheme
                                    .caption
                                    .copyWith(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold))
                                .make()
                                .centered(),
                          ),
                        ),
                      ),
                    );
                  }
                },
                selector: (_, handler) => handler?.data?.length ?? 0),
          ],
        ),
      ),
    );
  }
}

import 'package:beru/Schemas/Product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Counter extends StatelessWidget {
  final Product product;
  const Counter({
    Key key,
    @required TextEditingController controller,
    this.product,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: ChangeNotifierProvider(
        create: (context) => ValueNotifier<bool>(true),
        child: Consumer<ValueNotifier<bool>>(
          builder: (context, value, child) {
            return Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                      child: IconButton(
                          icon: Icon(
                            Icons.remove,
                            size: 13,
                          ),
                          onPressed: () {
                            double comput = double.parse(_controller.text) -
                                (product.inKg ? 0.25 : 1);
                            if (comput >= 0) {
                              _controller.text = "$comput";
                            }
                          })),
                  Flexible(
                    flex: 2,
                    child: Container(
                      color: Color(0xff68D8AE),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: TextField(
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            counterText: "",
                            counter: Offstage(),
                            isCollapsed: true,
                            prefix: Offstage(),
                            border: InputBorder.none,
                          ),
                          controller: _controller,
                          readOnly: value.value,
                          keyboardType: TextInputType.number,
                          maxLength: 2,
                          onSubmitted: (data) {
                            if (_controller.text.isEmpty) {
                              _controller.text = "0";
                            }
                            print("on completed");
                            value.value = (!value.value);
                          },
                          onTap: () {
                            print("on completed tap");
                            if (value.value) {
                              value.value = (!value.value);
                              print("value ${value.value}");
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                      child: IconButton(
                          icon: Icon(Icons.add, size: 13),
                          onPressed: () {
                            double comput = double.parse(_controller.text) +
                                (product.inKg ? 0.25 : 1);
                            if (comput <= product.salles[0].count) {
                              _controller.text = "$comput";
                            }
                          }))
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
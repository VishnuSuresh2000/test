import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class BeruSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Material(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(4.0),
        elevation: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            'search'
                .text
                .textStyle(Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(fontSize: 10, fontWeight: FontWeight.normal))
                .make()
                .pOnly(left: 10),
            Icon(
              Icons.search,
              color: Theme.of(context).iconTheme.color,
            ).pOnly(right: 10)
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:provider/provider.dart';
import 'package:axeii_loader/model/model.dart';

class GetPresetSettings extends StatelessWidget {

  const GetPresetSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
                InputQty(
      decoration: QtyDecorationProps(
        qtyStyle: QtyStyle.btnOnRight,
        btnColor: Colors.grey,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).hintColor),
        ),
      ),
    ),


            // Text("Preset Selector:"),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   spacing: 10,
            //   children: [
            //     SizedBox(width: 40, child: TextField()),
            //     Column(
            //       spacing: 2,
            //       children: [
            //         FilledButton(
            //           child: Icon(Icons.arrow_upward_rounded),
            //           onPressed: () {},
            //         ),
            //         FilledButton(
            //           child: Icon(Icons.arrow_downward_rounded),
            //           onPressed: () {},
            //         ),
            //       ],
            //     ),
            //   ],
            // ),
          ],
        ),
      ],
    );
  }
}

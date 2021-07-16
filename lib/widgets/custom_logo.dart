import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.25,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset('images/icons8-buy-100.png'),
            Positioned(
              bottom: 0,
              child: Text(
                'Authentic Cell Shop',
                style: TextStyle(fontFamily: 'Pacifico', fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  final int id;

  const DetailsScreen({Key key, this.id}) : super(key: key);
  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: Center(
        child: Text(
          '${widget.id}',
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'const.dart';

class RecommendedMaterialsScreen extends StatefulWidget {
  final String materialId;
  const RecommendedMaterialsScreen({Key? key, required this.materialId}) : super(key: key);

  @override
  State<RecommendedMaterialsScreen> createState() => _RecommendedMaterialsScreenState();
}

class _RecommendedMaterialsScreenState extends State<RecommendedMaterialsScreen> {
  List<dynamic> _recommendedMaterials = [];

  Future<List<dynamic>> _getRecommendedMaterials() async {
    final response = await http.get(Uri.parse('$apiBaseUrl:3000/Recommandation/Recomandation/${widget.materialId}'));
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final recommendedMaterials = decoded['recommendedMaterials'];
      return recommendedMaterials;
    } else {
      throw Exception('Failed to load recommended materials');
    }
  }

  @override
  void initState() {
    super.initState();
    _getRecommendedMaterials().then((materials) {
      setState(() {
        _recommendedMaterials = materials;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recommended Materials'),
      ),
      body: ListView.builder(
        itemCount: _recommendedMaterials.length,
        itemBuilder: (BuildContext context, int index) {
          final material = _recommendedMaterials[index];
          return Card(
            child: ListTile(
              leading: Image.network(material['imageUrl']),
              title: Text(material['name']),
              subtitle: Text('\$${material['price']}'),
            ),
          );
        },
      ),
    );
  }
}

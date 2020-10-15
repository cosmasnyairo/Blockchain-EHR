import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/node.dart';
import '../secrets.dart' as secrets;

class NodeProvider extends ChangeNotifier {

  final String _apiurl = secrets.apiurl;

  NodeProvider();

  List<Node> _nodes = [];

  List<Node> get nodes {
    return [..._nodes];
  }

  Future<void> getNodes() async {
    try {
      final url = '$_apiurl/get_nodes';
      final response = await http.get(url);
      var extractedData = json.decode(response.body) as Map<String, dynamic>;
      List<Node> loadednodes = [];
      extractedData.forEach((key, value) {
        List nodes = value as List<dynamic>;
        nodes.forEach((element) {
          loadednodes.add(Node(node: element));
        });
      });
      _nodes = loadednodes;
    } catch (e) {
      print(e);
    }
  }

  Future<void> addNodes() async {
    try {} catch (e) {}
  }

  Future<void> removeNode() async {
    try {} catch (e) {}
  }
}

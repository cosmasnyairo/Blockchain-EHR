import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/node.dart';
import '../secrets.dart' as secrets;

class NodeProvider extends ChangeNotifier {
  final String _apiurl = secrets.url;

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

  Future<void> addNodes(String node) async {
    try {
      final url = '$_apiurl/add_node';
      Map<String, String> addednode = {
        "node": node,
      };
      final response = await http.post(
        url,
        body: json.encode(addednode),
        headers: {
          "Content-Type": "application/json",
        },
      );
      final res = json.decode(response.body);
      getNodes();
      throw res["message"];
    } catch (e) {
      throw (e);
    }
  }

  Future<void> removeNode(String node) async {
    try {
      final url = '$_apiurl/remove_node/$node';
      print(url);
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      );
      final res = json.decode(response.body);
      getNodes();
      throw res["message"];
    } catch (e) {
      throw e;
    }
  }
}

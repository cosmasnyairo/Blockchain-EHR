import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
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

  Future<void> getNodes(
    int port,
  ) async {
    try {
      final url = '$_apiurl:$port/get_nodes';
      final response = await http.get(url).timeout(const Duration(seconds: 10),
          onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
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
      throw (e);
    }
  }

  Future<void> addNodes(int port, String node) async {
    try {
      final url = '$_apiurl:$port/add_node';
      Map<String, String> addednode = {
        "node": node,
      };
      await http.post(
        url,
        body: json.encode(addednode),
        headers: {
          "Content-Type": "application/json",
        },
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      throw 'True';
    } catch (e) {
      throw (e);
    }
  }

  Future<void> removeNode(int port, String node) async {
    try {
      final url = '$_apiurl:$port/remove_node/$node';
      await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
        },
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });

      throw 'True';
    } catch (e) {
      throw (e);
    }
  }
}

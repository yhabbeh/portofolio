import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/portfolio_data_model.dart';

abstract class PortfolioLocalDataSource {
  Future<PortfolioDataModel> getPortfolioData();
}

class PortfolioLocalDataSourceImpl implements PortfolioLocalDataSource {
  @override
  Future<PortfolioDataModel> getPortfolioData() async {
    // Simulate minor network latency for real loading indicator visualization
    await Future.delayed(const Duration(milliseconds: 600));
    final jsonString = await rootBundle.loadString('assets/data/portfolio.json');
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    return PortfolioDataModel.fromJson(jsonMap);
  }
}

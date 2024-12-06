import 'package:flutter/material.dart';
import 'package:farmapp/screens/farmer_register_screen.dart';
import 'package:farmapp/screens/market_register_screen.dart';

class RegisterSelectionScreen extends StatefulWidget {
  const RegisterSelectionScreen({super.key});

  @override
  _RegisterSelectionScreenState createState() =>
      _RegisterSelectionScreenState();
}

class _RegisterSelectionScreenState extends State<RegisterSelectionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String appBarTitle = "Çiftçi Kayıt";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {
        if (_tabController.index == 0) {
          appBarTitle = "Çiftçi Kayıt";
        } else {
          appBarTitle = "Market Kayıt";
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.purple,
          labelColor: Colors.purple,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "Çiftçi Kayıt"),
            Tab(text: "Market Kayıt"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          FarmerRegisterScreen(),
          MarketRegisterScreen(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

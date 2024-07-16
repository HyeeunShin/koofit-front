import 'package:flutter/material.dart';
import 'package:koofit/main_screen/search_tab_menu/food_detail_screen.dart';
import 'package:koofit/main_screen/search_tab_menu/tab_menu.dart';
import 'package:koofit/model/config/palette.dart';
import 'package:koofit/model/data/user.dart';
import 'package:gsheets/gsheets.dart';
import 'package:flutter_easy_search_bar/flutter_easy_search_bar.dart';

class SearchDietScreen extends StatefulWidget {
  final User userData;
  final String selectedDate;

  const SearchDietScreen(
      {super.key, required this.userData, required this.selectedDate});

  @override
  State<SearchDietScreen> createState() => _SearchDietScreenState();
}

class _SearchDietScreenState extends State<SearchDietScreen> {
  String searchText = '';

  final GSheets gsheets = GSheets({
    "type": "service_account",
    "project_id": "biohealthcare-43b45",
    "private_key_id": "bde78be6d66f1184164b0ebdff5a6b045b29073c",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDeYfX+ldt+dcMM\nXqT6sVrPKidLEXLqwJePGAV87rDB6hbXis+RTxiw01KqdS0k/j/w7SmuG3w9MCz9\njAybfIx67qLWJ9ujL3zW1yaHtMljZR013jaj85LsDnlasGrgaYqvg9xo61A2fMy4\nE/Uo0Xo3YcUsgCjWJkQ2amSrXyZVmgSSqKHoigZNny7MHuGlIuySXruQ5tMv+DhQ\n8qtY7ppWqAigl0+ayu22g5zLABsqCzGUt4autC0yKycMdEnc6xFaYcfG3LegVutT\nV/gE94pmRpB5CtQZBypsu61y6ef43RS+gbKFNsUOX3q3rWOyvZOhKAvSIIxZMQkP\nT3WoEODtAgMBAAECggEAMMKOd1Cg9Li5+HGdH3m5RVDDFlbgWWA6qw2zkFneyFn9\nQawGSKBs88KWLtlr+V9FIlzCBZKxulHgn4RwdDxKKh8+dZH+Oujr6Mh6goltmd1f\nGwNa/DZpSdh/m9awTH3fwo25S4kDCLtzAM6hc96Ae3m0y8XbDl+MF9lasue1RlHL\nAYm8aRGvK7S63Ejlzav1gu3OZbOUWxX9lfO9mmtrwZLu01+VZFB1bW1kBst5jTAr\n4MNI7D1nzQXtnhqZVyhKWG/E7pTK9iuVdb0DiW5HYSlxwmg6J9VQBPk/33uS41hS\nOHu/KPndGr2LrV9Sq9pNNgcYGur/EKXrPZ3jjmvisQKBgQD5E+7Es74g/wNR1AUb\nfqT6L2PVsA5yjJWeN4fYvuN//ZGOQgyj4IYafMXsWL8pNubwkMzQt4uvH+o7a3qN\n9EjRno+cLhCJ3KjQX5bM4mPMbytC/tpXG0tn/hikLVx49cKnbvuMuOfVYkjNWEni\nfJ2a0kFE8jNt0IFE8BG/0cErfQKBgQDkkBra/L0/UyUDJrx804IwItk9PnE3sQVf\nN3PM8CcYrGf4kjmmxbjkK3qLaN6YNjGuVcLtGBsigcOGjuKBBTz7m9c0l30VPOqL\npTiedVPbDLTN5XkI+1+c7RNRuxtmnRuDNqVKX4hiZVQQwHEDKCY7mbaUdR0Hc6bN\ndgVjj58mMQKBgGvQhPoAE7yUpgs1i0BrgV4KRVyp6JcM43ao8tSPTEqKqAa78Fy/\nQ00T1ViI0bY1XaGkDAQMbxpO5kTyMQphQ2P5DpC8H8yNB0WrGst08136gO9vAXPT\nDMDm7COkvvJc7vUqxRgUscVb1ceM/+5Zop7xg+8kJ77REiOVBxnQ4ZzBAoGAMFrQ\nY63+t6v2c6E5VUtGCrsErLFOMJMR6OAJbr0L+GtZH7yH1+GSySrtpRrNpPQqNJDO\nSWzFKNq9K/WEs/kQusZwlB7Mhra5hEuzG8sEr54Tjk/S+HR9+OwrHypvlJj+Xhcs\nhvyJFRAM5fJgtmNDG27csrHIL3BnRKaIY1TaPbECgYApgHHzx1fdwm2re0z3hsC7\nmEchAInPchyGvJ0ULRr2WNZat4eurtT0tf8ZeNLLK4pB4Q4DZtg4zcUTcsi1tFaa\n5yWAkvTYDgDeevPHarPqg/ab9z0WW9vhsy4Mt7o4fIGwME/c68Uu9x7l101XFWYa\nv4ugIpZxCkVZ/2u9jMtRew==\n-----END PRIVATE KEY-----\n",
    "client_email":
        "fooddatagsheets@biohealthcare-43b45.iam.gserviceaccount.com",
    "client_id": "103093735126220995857",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/fooddatagsheets%40biohealthcare-43b45.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  });
  Worksheet? _worksheet;
  List<List<String>> _data = [];
  String searchValue = '';
  List<String> dataToDisplayList = [];
  List<List<String>> _filteredData = [];
  late User _userData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadSpreadsheetData();
    _userData = widget.userData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        // Set this to false to avoid resizing when the keyboard is displayed
        appBar: EasySearchBar(
            backgroundColor: Palette.mainSkyBlue,
            searchCursorColor: Palette.mid_dark_mainSkyBlue,
            title: const Text(
              '식단 추가하기',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            onSearch: _filterData,
            asyncSuggestions: (value) async => await _filterData(value),
            onSuggestionTap: (String tappedSuggestion) {
              // Assuming rowData is a List<String> related to the tapped suggestion
              List<String> rowData = _filteredData.firstWhere(
                  (row) => row.length > 10 && row[1] == tappedSuggestion,
                  orElse: () => []);
              _onRowTap(rowData);
            }),
        body: Center(
            child: TabMenu(
                UserData: _userData, selectedDate: widget.selectedDate)));
  }

  Future<void> _loadSpreadsheetData() async {
    try {
      final spreadsheet = await gsheets
          .spreadsheet('1QzTEHSf-zVoi_pWiI4fApI3AbE4-hzTLDCtpfv5Stck');
      _worksheet = spreadsheet.worksheetByTitle('FoodData');
      _data = await _worksheet!.values.allRows();
      setState(() {});
    } catch (e) {
      print('Error loading spreadsheet data: $e');
    }
  }

  Future<List<String>> _filterData(String query) async {
    await Future.delayed(const Duration(milliseconds: 10));

    if (mounted) {
      setState(() {
        searchText = query.toLowerCase();
        _filteredData = _data
            .where((row) =>
                row.length > 9 && row[1].toLowerCase().contains(searchText))
            .toList();

        // Update dataToDisplayList here
        dataToDisplayList = _filteredData
            .map((rowData) => rowData.length > 10 ? rowData[1] : '')
            .toList();

        // Print or use dataToDisplayList as needed
        print(dataToDisplayList);
      });
    }

    // Return the result outside the setState block
    return dataToDisplayList;
  }

  void _onRowTap(List<String> rowData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(
            rowData: rowData,
            userData: _userData,
            selectedDate: widget.selectedDate),
      ),
    );
  }
}

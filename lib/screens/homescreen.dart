import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/district.dart';
import 'district_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<District>> getAllDistricts() async {
    List<District> districts = [];
    String url = 'https://data.covid19india.org/state_district_wise.json'; 
    var response = await http.get(Uri.parse(url));

    //if successfull
    if (response.statusCode == 200) {
      var rawBody = json.decode(response.body);

      for (var each in rawBody.values) {
        each["districtData"].forEach((keys, values) {
          var district = District.fromJson(keys, values);
          districts.add(district);
        });
      }
      return districts;
    }
    return districts; //returns empty list if error in fetching data from API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            toolbarHeight: 0, elevation: 0, backgroundColor: Colors.white),
        body: Container(
          margin: const EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.black,
                    image: const DecorationImage(
                        image: AssetImage('assets/images/lgm.png'))),
              ),
              Expanded(
                child: FutureBuilder<List<District>>(
                    future: getAllDistricts(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        List<District> districts =
                            snapshot.data as List<District>;
                        return ListView.builder(
                          itemCount: districts.length - 1,
                          itemBuilder: (context, index) {
                            District district = districts[index + 1];
                            return GestureDetector(
                              onTap: (() =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DistrictDetailsScreen(
                                        district: district),
                                  ))),
                              child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          gradient:
                                              const LinearGradient(colors: [
                                            Color(0XffFFAE42),
                                            Color(0XffFAEE9E),
                                          ])),
                                      child: district.notes != ''
                                          ? ListTile(
                                              leading: Text('${index + 1}'),
                                              minLeadingWidth: 10,
                                              title: Text(
                                                district.name,
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              trailing: const Icon(
                                                  Icons.arrow_forward_ios),
                                              subtitle: Text(
                                                'Note: ${district.notes}',
                                                style: const TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ))
                                          : ListTile(
                                              contentPadding:
                                                  const EdgeInsets.all(15.0),
                                              title: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('${index + 1}'),
                                                  const SizedBox(width: 10.0),
                                                  Text(
                                                    district.name,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  const Expanded(
                                                    child: SizedBox.shrink(),
                                                  )
                                                ],
                                              ),
                                              trailing: const Icon(
                                                  Icons.arrow_forward_ios),
                                            ))),
                            );
                          },
                        );
                      }
                    }),
              ),
            ],
          ),
        ));
  }
}

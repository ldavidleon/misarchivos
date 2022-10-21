import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_muc_api/Models/mcu_model.dart';
import 'package:flutter_muc_api/Models/model.dart';
import 'package:http/http.dart' as http;
import 'package:slidable_button/slidable_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var marvelApiUrl = "https://mcuapi.herokuapp.com/api/v1/movies";
  List<MCUDATA?> mcuMoviesList = [];

  @override
  void initState() {
    super.initState();
    getMarvelMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          toolbarHeight: 100,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          )),
          title: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Marvel Movies",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 201, 31, 19),
                      radius: 23,
                      child: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 5, 63, 163),
                        radius: 20,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://st4.depositphotos.com/20370054/28773/v/450/depositphotos_287737786-stock-illustration-avengers-logo-isolated-vector-icon.jpg"),
                          radius: 17,
                        ),
                      ),
                    ),
                  ],
                ),
                HorizontalSlidableButton(
                  width: MediaQuery.of(context).size.width / 3,
                  buttonWidth: 60.0,
                  color: Theme.of(context).backgroundColor.withOpacity(0.5),
                  buttonColor: Theme.of(context).primaryColor,
                  dismissible: false,
                  label: Center(
                      child: Text('Slide Me', style: TextStyle(fontSize: 10))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Leon\nAlejo',
                          style: TextStyle(fontSize: 10),
                        ),
                        Text('Perez\nMartinez', style: TextStyle(fontSize: 10)),
                      ],
                    ),
                  ),
                  onChanged: (position) {
                    setState(() {
                      if (position == SlidableButtonPosition.end) {
                        var result = Text(
                          'Button is on the right',
                          style: TextStyle(color: Colors.white),
                        );
                      } else {
                        var result = 'Button is on the left';
                      }
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.grey[900],
        body: mcuMoviesList.isNotEmpty
            ? GridView.builder(
                itemCount: mcuMoviesList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (BuildContext context, int index) {
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: mcuMoviesList[index]!.coverUrl != null
                          ? CachedNetworkImage(
                              imageUrl:
                                  mcuMoviesList[index]!.coverUrl.toString(),
                              placeholder: (context, url) =>
                                  Image.asset('images/place_holder.png'),
                            )
                          : Image.asset('images/place_holder.png'));
                },
              )
            : Center(
                child: Container(
                width: 50,
                height: 50,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white70,
                  ),
                ),
              )));
  }

  void getMarvelMovies() {
    final uri = Uri.parse(marvelApiUrl);
    http.get(uri).then((response) {
      if (response.statusCode == 200) {
        final responseBody = response.body;
        final decodedData = jsonDecode(responseBody);
        mcuMoviesList = mcg_model.fromJson(decodedData).data as List<MCUDATA?>;
        print(mcuMoviesList.first!.id);
        setState(() {});
      } else {}
    }).catchError((err) {
      debugPrint('=========== $err =============');
    });
  }
}

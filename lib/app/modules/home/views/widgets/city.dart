// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ongkir/app/modules/home/controllers/home_controller.dart';

import 'package:http/http.dart' as http;

import '../../city_model.dart';

class Kota extends GetView<HomeController> {
  const Kota({
    Key? key,
    required this.tipe,
    required this.provId
  }) : super(key: key);

  final int provId;
  final String tipe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownSearch<City>(
        showClearButton: true,
        label: tipe == "asal" ? "Kota / Kabupatan Asal" : "Kota Kabupaten Asal",
        onFind: (String? filter) async {
          Uri url = Uri.parse("https://api.rajaongkir.com/starter/city?province=${provId}");

          try{

            final response = await http.get(
              url, 
              headers: {
                "key": "798d3f72a1cd6bce4b684aeed186f58a", 
              }
            );

            var data = json.decode(response.body);

            var listAllCity = data["rajaongkir"]["results"];                
            
            var models = City.fromJsonList(listAllCity);
            return models;

          }catch(err){
            return List<City>.empty();
          }

        },
        onChanged: (kotaValue){
          if(kotaValue != null){
            if(tipe == "asal"){
              controller.kotaAsalId.value = int.parse(kotaValue.cityId!);
            }else{
              controller.kotaTujuanId.value = int.parse(kotaValue.cityId!);
            }
          }else{
            if(tipe == "asal"){
              print("tidak memiliki kota asal apapun");
            }else{
              print("tidak memiliki kota tujuan apapun");
            }
          }
        }, 
        popupItemBuilder: (context, item, isSelected){
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15, 
              vertical: 5
            ),
            child: Text(
              "${item.type} ${item.cityName}", 
              style: TextStyle(
                fontSize: 18, 

              ),
            ),
          );
        },
        itemAsString: (item) => "${item!.type} ${item.cityName}",
        showSearchBox: true,
      ),
    );
  }
}

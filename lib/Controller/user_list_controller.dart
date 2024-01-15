import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:jewellery_user/ConstFile/constColors.dart';

class UserListController extends GetxController {

  // RxList<String> userlists = <String>[].obs;

  List<UserList> userlists = <UserList>[
    UserList(name: 'Nikunj Paghadal', btnName: 'In Progress'),
    UserList(name: 'Dhruv Gajera', btnName: 'Completed'),
    UserList(name: 'Rahul Bhimani', btnName: 'Pending'),
    UserList(name: 'Ronak Savaliya', btnName: 'Cancelled'),
    UserList(name: 'Karan Gheewala', btnName: 'Completed'),
    UserList(name: 'Baraiya Vishal', btnName: 'Completed'),
  ];
}

class UserList {
  UserList({required this.name, required this.btnName});
  final String name;
  late final String btnName;
}

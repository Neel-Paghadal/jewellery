import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ReportSearchController extends GetxController {
  List<Report> reportlist = <Report>[
    Report(designCode: '# 2352', date: 'Create Date : 02/01/2024', btnName: 'Completed'),
    Report(designCode: '# 2354', date: 'Create Date : 01/01/2024', btnName: 'Completed'),
    Report(designCode: '# 4563', date: 'Create Date : 29/12/2023', btnName: 'Pending'),
    Report(designCode: '# 2564', date: 'Create Date : 29/12/2023', btnName: 'Completed'),
    Report(designCode: '# 5648', date: 'Create Date : 20/12/2023', btnName: 'Cancelled'),

  ];
}

class Report {
  Report({required this.btnName, required this.designCode, required this.date});
  final String designCode;
  final String date;
  final String btnName;
}
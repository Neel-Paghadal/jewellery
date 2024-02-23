
class ConstApi {
  static  String baseUrl = 'http://208.64.33.118:8558';
  static  String apiUrl = '${baseUrl}/api/';
  static  String baseFilePath = '${baseUrl}/Files/';
  static  String userRegister = '${apiUrl}Auth/Register';
  static  String userLogin = '${apiUrl}Auth/login';
  static  String  getOrder = '${apiUrl}Order/Orders?PageNumber=1&PageSize=10';
  static  String  getUser = '${apiUrl}Order/GetOrderUsers?orderId=2239E3D2-56D2-42C6-99AC-11440B4C53B7';
  static  String  getUserForDrop = '${apiUrl}Order/Users?orderId=de060e20-bf54-48b9-b50c-048c9b5fbfb5';
  static  String  order = '${apiUrl}Order';
  static  String  updateOrder = '${apiUrl}Order/updateorder';
  static  String  assignOrder = '${apiUrl}Order/AssignOrder';
  static  String  getOrderDetails = '${apiUrl}Order/GetOrderDetails?orderId=1e4e44a1-910c-4e95-9ee3-cd5cb72b8b82';
  static  String  newUser = '${apiUrl}Auth/registerAdminUser';
  static  String  orderComplete = '${apiUrl}Order/CompleteOrder';
  static  String  orderCancel = '${apiUrl}Order/CancelOrder';
  static  String  releaseDevice = '${apiUrl}User/release-device';
  static  String  getReport = '${apiUrl}Report/Orders';
  static  String  getParty = '${apiUrl}Order/GetParties';
  static  String  updateAssignOrder = '${apiUrl}Order/UpdateAssignOrder';

}

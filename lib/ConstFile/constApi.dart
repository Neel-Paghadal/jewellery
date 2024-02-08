
class ConstApi {
  static  String baseUrl = 'http://208.64.33.118:8558/api/';
  static  String userRegister = '${baseUrl}Auth/Register';
  static  String userLogin = '${baseUrl}Auth/login';
  static  String  getOrder = '${baseUrl}Order/Orders?PageNumber=1&PageSize=10';
  static  String  getUser = '${baseUrl}Order/GetOrderUsers?orderId=2239E3D2-56D2-42C6-99AC-11440B4C53B7';
  static  String  getUserForDrop = '${baseUrl}Order/Users?orderId=de060e20-bf54-48b9-b50c-048c9b5fbfb5';
  static  String  order = '${baseUrl}Order';
  static  String  updateOrder = '${baseUrl}Order/updateorder';
  static  String  assignOrder = '${baseUrl}Order/AssignOrder';
  static  String  getOrderDetails = '${baseUrl}Order/GetOrderDetails?orderId=1e4e44a1-910c-4e95-9ee3-cd5cb72b8b82';
  static  String  newUser = '${baseUrl}Auth/registerAdminUser';
  static  String  orderComplete = '${baseUrl}Order/CompleteOrder';
  static  String  orderCancel = '${baseUrl}Order/CancelOrder';
  static  String  releaseDevice = '${baseUrl}User/release-device';
  static  String  getReport = '${baseUrl}Report/Orders';
  static  String  getParty = '${baseUrl}Order/GetParties';
  static  String  updateAssignOrder = '${baseUrl}Order/UpdateAssignOrder';

}

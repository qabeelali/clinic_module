const String appUrl = 'https://web.azu-app.com';
String sheetsApi(String? search) =>
    '${appUrl}/api/sheets?search=${search ?? ''}';
const String storeSheet = '${appUrl}/api/sheets/store';
String showSheetUrl(id) {
  return '${appUrl}/api/sheets/show?id=${id}';
}

const String addUpdate = '${appUrl}/api/sheets/add-new-update';
String drugsSearch(String? e) =>
    '${appUrl}/api/sheets/drugs-search?drug=${e ?? ''}';
const String labTestSearch = '${appUrl}/api/sheets/lab-test-search';
String searchToSend(type, name) =>
    '${appUrl}/api/sheets/search-to-send?type=${type ?? ''}&search=${name ?? ''}';
String showAllRecieved(String? search) =>
    '${appUrl}/api/sheets/show-all-received?search=${search ?? ''}';
const String tokenGetId = '${appUrl}/api/token-get-id';
String getRecievedDataUrl(id) {
  return '${appUrl}/api/sheets/show-received-by-id?id=$id';
}

const String acceptUrl = '${appUrl}/api/sheets/accept';
const String rejectUrl = '${appUrl}/api/sheets/reject';

const String sendData = '${appUrl}/api/sheets/send-data';
String radiologySearch(String? e) =>
    '${appUrl}/api/sheets/radiologies-search?drug=${e ?? ''}';
String labSearch(String? e) {
  return '${appUrl}/api/sheets/lab-test-search?drug=${e ?? ''}';
}

String recievedSheetUrl = '${appUrl}/api/sheets/received-sheet';
String sendSheetToDoctor = '${appUrl}/api/sheets/sendSheetToDoctor';
String searchToLoinkUrl(String? search) {
  return '${appUrl}/api/sheets/search-to-link-user?search=$search';
}

String linkUserUrl = '${appUrl}/api/sheets/link-user';
String checkSearchUrl = '${appUrl}/api/sheets/check-search';
const sendSheet = '${appUrl}/api/sheets/send-sheet';
String getDaysUrl (String date){
  return '${appUrl}/api/main-ca?date=$date';
}
String getOrdersUrl(String date){
  return '${appUrl}/api/day-ca?date=$date';
}
String getRequestsUrl(String type, String? date, dynamic state){
  return "${appUrl}/api/orders/?state=${state??''}&date=${date??''}&type=$type";
}
String getRequestUrl(String id){
  return '${appUrl}/api/orders/show?id=$id&type=1';
}

String getDatesUrl(id){
  return '$appUrl/api/orders/availedBooking?id=$id';
}
const String getPricesUrl = '$appUrl/api/prices?type=1';
const String acceptRequestUrl = '$appUrl/api/orders/accept';
const String rejectRequestUrl = '$appUrl/api/orders/reject';
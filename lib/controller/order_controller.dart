import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sixvalley_delivery_boy/controller/profile_controller.dart';
import 'package:sixvalley_delivery_boy/controller/wallet_controller.dart';
import 'package:sixvalley_delivery_boy/data/api/api_checker.dart';
import 'package:sixvalley_delivery_boy/data/model/response/order_details.dart';
import 'package:sixvalley_delivery_boy/data/model/response/order_model.dart';
import 'package:sixvalley_delivery_boy/data/repository/order_repo.dart';
import 'package:sixvalley_delivery_boy/view/base/custom_snackbar.dart';

class OrderController extends GetxController implements GetxService {
  final OrderRepo orderRepo;
  OrderController({@required this.orderRepo});


  List<OrderModel> _currentOrders = [];
  List<OrderModel> get currentOrders => _currentOrders;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int _orderTypeIndex = 0;
  int get orderTypeIndex => _orderTypeIndex;
  int _orderTypeFilterIndex = 0;
  int get orderTypeFilterIndex => _orderTypeFilterIndex;
  final OrderDetailsModel _orderDetailsModel = OrderDetailsModel();
  OrderDetailsModel get orderDetailsModel => _orderDetailsModel;
  List<OrderDetailsModel> _orderDetails;
  List<OrderDetailsModel> get orderDetails => _orderDetails;
  List<OrderModel> _allOrderHistory = [];
  List<OrderModel> get allOrderHistory => _allOrderHistory;
  String _feedbackMessage;
  String get feedbackMessage => _feedbackMessage;

  String selectedOrderLat = '23.83721';
  String selectedOrderLng = '90.363715';

  void setSelectedOrderLatLng(LatLng latLng){
    selectedOrderLat = latLng.latitude.toString();
    selectedOrderLat = latLng.longitude.toString();
    // update();
  }

  final List<String> reasonList = [
    'could_not_contact_with_the_customer',
    'customer_cant_collect_the_parcel_now_request_to_deliver_delay',
    'could_not_find_the_location',
    'delivery_man_transport_broken',
    'other'
  ];


  String _reasonValue = '';
  String get reasonValue => _reasonValue;

  List<OrderModel> _orderList;
  List<OrderModel> get orderList => _orderList != null ? _orderList.reversed.toList() : _orderList;

  void setReason(String value, {bool reload = true}){
    _reasonValue = value;
    if(reload){
      update();
    }

  }



  Future<void> getCurrentOrders(BuildContext context) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.getCurrentOrders();
    if (response.body != null && response.body != {} && response.statusCode == 200) {
      _currentOrders = [];
      response.body.forEach((order) {_currentOrders.add(OrderModel.fromJson(order));});

      _isLoading = false;
    } else {
      ApiChecker.checkApi(response);
      _isLoading = false;
    }
    update();
  }




  Future<List<OrderDetailsModel>> getOrderDetails(String orderID, BuildContext context) async {
    _orderDetails = null;
    _isLoading = true;
    Response response = await orderRepo.getOrderDetails(orderID: orderID);
    if (response.body != null && response.statusCode == 200) {
      _orderDetails = [];
      response.body.forEach((orderDetail) => _orderDetails.add(OrderDetailsModel.fromJson(orderDetail)));
      _isLoading = false;
    } else {
      ApiChecker.checkApi( response);
      _isLoading = false;
    }
    update();
    return _orderDetails;
  }




  Future <void> getAllOrderHistory(String type, String startDate, String endDate, String search, int isPause) async {
    _isLoading = true;
    Response response = await orderRepo.getAllOrderHistory(type,startDate,endDate, search, isPause);
    if (response.body != null && response.statusCode == 200) {
      _allOrderHistory = [];
      response.body.forEach((order) {_allOrderHistory.add(OrderModel.fromJson(order));});
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  void selectedOrderLatLng(String lat, String lng){
    selectedOrderLat = lat;
    selectedOrderLng = lng;
    update();
  }



  Future<bool> updateOrderStatus({int orderId, String status,BuildContext context}) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.updateOrderStatus(orderId: orderId, status: status);
    Get.back();
    bool _isSuccess;
    if(response.body != null && response.statusCode == 200) {
      showCustomSnackBar(response.body['message'], isError: false);
      _isSuccess = true;
      Get.find<ProfileController>().getProfile();
      getCurrentOrders(context);
    }else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }
    _isLoading = false;
    update();
    return _isSuccess;
  }



  Future<bool> cancelOrderStatus({int orderId, String cause,BuildContext context}) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.cancelOrderStatus(orderId: orderId,  cause: cause);
    Get.back();
    bool _isSuccess;
    if(response.body != null && response.statusCode == 200) {
      showCustomSnackBar(response.body['message'], isError: false);
      _isSuccess = true;
      getCurrentOrders(context);
    }else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }
    _isLoading = false;

    update();
    return _isSuccess;
  }

  Future<bool> rescheduleOrderStatus({int orderId, String deliveryDate, String cause, BuildContext context}) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.rescheduleOrder(orderId: orderId, deliveryDate: deliveryDate, cause: cause);
    Get.back();
    bool _isSuccess;
    if(response.body != null && response.statusCode == 200) {
      showCustomSnackBar(response.body['message'], isError: false);
      _isSuccess = true;
      getCurrentOrders(context);
    }else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }
    _isLoading = false;

    update();
    return _isSuccess;
  }

  Future<bool> pauseAndResumeOrder({int orderId, int isPos, String cause, BuildContext context}) async {
    _isLoading = true;
    update();
    Response response = await orderRepo.pauseAndResumeOrder(orderId: orderId, isPos: isPos, cause: cause);
    Get.back();
    bool _isSuccess;
    if(response.body != null && response.statusCode == 200) {
      showCustomSnackBar(response.body['message'], isError: false);
      _isSuccess = true;
      getCurrentOrders(context);
    }else {
      ApiChecker.checkApi(response);
      _isSuccess = false;
    }
    _isLoading = false;

    update();
    return _isSuccess;
  }

  Future updatePaymentStatus({int orderId, String status}) async {
    Response apiResponse = await orderRepo.updatePaymentStatus(orderId: orderId, status: status);

    if (apiResponse.statusCode == 200) {

    } else {
     ApiChecker.checkApi(apiResponse);
    }
    update();
  }

  Future orderRefresh(BuildContext context) async{
    getCurrentOrders(context);
    return getCurrentOrders(context);
  }


  void setEarningFilterIndex(int index) {
    _orderTypeFilterIndex = index;
    if(_orderTypeFilterIndex == 0){
      Get.find<WalletController>().getOrderWiseDeliveryCharge('', '', 1, '');
    }else if(_orderTypeFilterIndex == 1){
      Get.find<WalletController>().getOrderWiseDeliveryCharge('', '', 1, 'TodayEarn');
    }
    else if(_orderTypeFilterIndex == 2){
      Get.find<WalletController>().getOrderWiseDeliveryCharge('', '', 1, 'ThisWeekEarn');
    }
    else if(_orderTypeFilterIndex == 3){
      Get.find<WalletController>().getOrderWiseDeliveryCharge('', '', 1, 'ThisMonthEarn');
    }
    update();
  }

  void setOrderTypeIndex(int index, {String startDate = '', String endDate = '', String search = '', bool reload = false}) {
    _orderTypeIndex = index;
    if(orderTypeIndex == 0){
      getAllOrderHistory('', startDate, endDate, search,0);
    }else if(orderTypeIndex == 1){
      getAllOrderHistory('out_for_delivery', startDate, endDate, search,0);
    } else if(orderTypeIndex == 2){
      getAllOrderHistory('', startDate, endDate, search, 1);
    } else if(orderTypeIndex == 3){
      getAllOrderHistory('delivered', startDate, endDate, search,0);
    }else if(orderTypeIndex == 4){
      getAllOrderHistory('return', startDate, endDate, search,0);
    }else if(orderTypeIndex == 5){
      getAllOrderHistory('canceled', startDate, endDate, search,0);
    }
    update();

  }

  DateTime _startDate;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-d');
  DateTime get startDate => _startDate;
  DateFormat get dateFormat => _dateFormat;

  void selectDate(BuildContext context){
    showDatePicker(

      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
    ).then((date) {
      _startDate = date;
      update();
    });
  }

}

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:sixvalley_delivery_boy/controller/menu_controller.dart';
import 'package:sixvalley_delivery_boy/controller/order_controller.dart';
import 'package:sixvalley_delivery_boy/controller/profile_controller.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/view/base/custom_home_app_bar.dart';
import 'package:sixvalley_delivery_boy/view/base/no_data_screen.dart';
import 'package:sixvalley_delivery_boy/view/base/title_widget.dart';
import 'package:sixvalley_delivery_boy/view/screens/home/widget/earn_statement_widget.dart';
import 'package:sixvalley_delivery_boy/view/screens/home/widget/ongoing_order_card_widget.dart';
import 'package:sixvalley_delivery_boy/view/screens/home/widget/trip_status_widget.dart';
import 'package:sixvalley_delivery_boy/view/screens/order/widget/permission_dialog.dart';

class HomeScreen extends StatefulWidget {
  final Function(int index) onTap;
  const HomeScreen({Key key, @required this.onTap}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<void> _loadData(BuildContext context) async {
    await Get.find<ProfileController>().getProfile();
    await Get.find<OrderController>().getCurrentOrders(context);
    await Get.find<OrderController>().getAllOrderHistory('', '', '', '',0);

  }

  @override
  void initState() {
    _checkPermission(context);
    _loadData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomRiderAppBar(title: 'dashboard'.tr, isSwitch: true),

      body: RefreshIndicator(
        onRefresh: () async {
          return true;
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [

                  const EarnStatementWidget(),
                   SizedBox(height: Dimensions.paddingSizeDefault),

                  TripStatusWidget(onTap: (int index) => widget.onTap(index)),


                  Padding(
                    padding:  EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault,
                        Dimensions.paddingSizeDefault,Dimensions.paddingSizeDefault,Dimensions.paddingSizeExtraSmall),
                    child: TitleWidget(title: 'ongoing'.tr,onTap: (){

                      Get.find<BottomMenuController>().selectOrderHistoryScreen(fromHome: true);
                      Get.find<OrderController>().setOrderTypeIndex(0);

                    },),
                  ),




                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                    child:  GetBuilder<OrderController>(builder: (orderController) {
                      return !orderController.isLoading ? orderController.currentOrders.isNotEmpty ?
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: orderController.currentOrders.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index){
                          return OnGoingOrderWidget(orderModel: orderController.currentOrders[index], index: index);
                        },
                      ) : const Center(child: NoDataScreen(),
                      ) : Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor),);
                    }),
                  ),

                ],
              ),
            )
          ],
        ),
      )
    );
  }

  void _checkPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      showDialog(context: context, barrierDismissible: false, builder: (context) => PermissionDialog(isDenied: true,
          onPressed: () async {
            Navigator.pop(context);
            await Geolocator.requestPermission();

          }));
    }else if(permission == LocationPermission.deniedForever) {
      showDialog(context: context, barrierDismissible: false, builder: (context) => PermissionDialog(isDenied: false,
          onPressed: () async {
            Navigator.pop(context);
            await Geolocator.openAppSettings();

          }));
    }
  }
}





import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sixvalley_delivery_boy/controller/menu_controller.dart';
import 'package:sixvalley_delivery_boy/controller/order_controller.dart';
import 'package:sixvalley_delivery_boy/controller/profile_controller.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/utill/images.dart';
import 'package:sixvalley_delivery_boy/utill/styles.dart';
import 'package:sixvalley_delivery_boy/view/screens/dashboard/dashboard_screen.dart';

class TripStatusWidget extends StatelessWidget {
  final Function(int index) onTap;
  const TripStatusWidget({Key key, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeDefault,vertical: Dimensions.paddingSizeExtraSmall),
      child: GetBuilder<ProfileController>(
        builder: (profileController) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
            Padding(
              padding:  EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
              child: Text('order_status'.tr,style:  rubikMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge,
                  color: Theme.of(context).colorScheme.secondary)),
            ),
            GestureDetector(
              onTap: ()=> Get.to(()=> const DashboardScreen(pageIndex: 1)),
              child: TripItem(color: Theme.of(context).colorScheme.tertiaryContainer,icon: Images.assigned,
                  title: 'assigned', totalCount: profileController.profileModel != null?
                profileController.profileModel.totalDelivery??0 : 0,
                onTap: (){
                Get.find<BottomMenuController>().selectOrderHistoryScreen(fromHome: true);
                Get.find<OrderController>().setOrderTypeIndex(0);
                onTap(1);
                },),
            ),

            TripItem(color: Theme.of(context).colorScheme.surface, icon: Images.pending,
                title: 'paused',totalCount: profileController.profileModel.pendingDelivery,
              onTap: ()
                {
                 Get.find<BottomMenuController>().selectOrderHistoryScreen(fromHome: true);
                 onTap(1);
                  Get.find<OrderController>().setOrderTypeIndex(2, reload: true);
                }
            ),

            TripItem(color: Theme.of(context).colorScheme.primaryContainer,icon: Images.completed,
                title: 'delivered', totalCount: profileController.profileModel.completedDelivery,
              onTap: (){
                Get.find<BottomMenuController>().selectOrderHistoryScreen(fromHome: true);
                onTap(1);
                Get.find<OrderController>().setOrderTypeIndex(3, reload: true);
              }),


          ],);
        }
      ),
    );
  }
}

class TripItem extends StatelessWidget {
  final Color color;
  final String icon;
  final String title;
  final int totalCount;
  final Function onTap;
  const TripItem({Key key, this.icon, this.title, this.totalCount, this.color, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding:  EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
        child: Container(decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
          color: color.withOpacity(.55)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
             Container(padding:  EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
               child: Row(children: [
                Padding(
              padding:  EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: SizedBox(width: 30,child: Image.asset(icon)),
            ),
                Text(title.tr, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge, fontWeight: FontWeight.w400),),
               ],),),
              Padding(
            padding:  EdgeInsets.symmetric(horizontal : Dimensions.paddingSizeSmall),
            child: Container(padding:  EdgeInsets.symmetric(vertical : Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeLarge),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
              color: color.withOpacity(.75)
            ),child: Text(NumberFormat.compact().format(totalCount),style: rubikMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),),),
          )
        ],)),
      ),
    );
  }
}

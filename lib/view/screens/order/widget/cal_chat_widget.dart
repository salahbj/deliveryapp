
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixvalley_delivery_boy/controller/chat_controller.dart';
import 'package:sixvalley_delivery_boy/data/model/response/order_model.dart';
import 'package:sixvalley_delivery_boy/utill/dimensions.dart';
import 'package:sixvalley_delivery_boy/utill/images.dart';
import 'package:sixvalley_delivery_boy/view/screens/chat/chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class CallAndChatWidget extends StatelessWidget {
  final OrderModel orderModel;
  final bool isSeller;
  final bool isAdmin;
  const CallAndChatWidget({Key key, this.orderModel, this.isSeller = false, this.isAdmin = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String phone = isSeller? orderModel.sellerInfo.phone : orderModel.customer.phone;
    int id = 0;
    String name = '';
    if(isAdmin){
      id = 0;
      name = 'admin';
    }else{
      id =   isSeller ? orderModel.sellerInfo.id : orderModel.customer.id;
      name = isSeller ? orderModel.sellerInfo.shop.name : '${orderModel.customer.fName} ${orderModel.customer.lName}';
    }

    return Row(children: [
      InkWell(
        onTap: ()=> _launchUrl("tel:$phone"),
        child: Padding(
          padding:  EdgeInsets.only(right: Dimensions.paddingSizeSmall),
          child: Container(width: 40,height: 40,decoration: BoxDecoration(
            color: Theme.of(context).hintColor.withOpacity(.0525),
            border: Border.all(color: Theme.of(context).hintColor),
            borderRadius: BorderRadius.circular(50),

          ),
            padding:  EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Image.asset(Images.callIcon,color: Theme.of(context).colorScheme.onTertiaryContainer)),
        ),
      ),

      InkWell(
        onTap: (){
          print('====>name==>$name');
          if(!isSeller){
            Get.find<ChatController>().setUserTypeIndex(1);
          }
          Get.to(ChatScreen(userId: id, name: name));
        },
        child: Padding(
          padding:  EdgeInsets.only(right: Dimensions.paddingSizeSmall),
          child: Container(width: 40,decoration: BoxDecoration(
            color: Theme.of(context).hintColor.withOpacity(.0525),
            border: Border.all(color: Theme.of(context).hintColor),
            borderRadius: BorderRadius.circular(50),

          ),
            padding:  EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Image.asset(Images.smsIcon,color:Get.isDarkMode? Theme.of(context).hintColor: Theme.of(context).primaryColor,),),
        ),
      )
    ],);
  }
}
Future<void> _launchUrl(String _url) async {
  if (!await launchUrl(Uri.parse(_url))) {
    throw 'Could not launch $_url';
  }
}
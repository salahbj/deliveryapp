
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixvalley_delivery_boy/controller/chat_controller.dart';
import 'package:sixvalley_delivery_boy/view/base/custom_home_app_bar.dart';
import 'package:sixvalley_delivery_boy/view/base/custom_loader.dart';
import 'package:sixvalley_delivery_boy/view/screens/chat/widget/message_list_view.dart';
import 'package:sixvalley_delivery_boy/view/screens/chat/widget/message_sendig_section_widget.dart';


class ChatScreen extends StatefulWidget {
  final int userId;
  final String name;
  const ChatScreen({Key key, @required this.userId, this.name = 'chat'}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();



  @override
  void initState() {
    super.initState();
    Get.find<ChatController>().getMessages(1, widget.userId,firstLoad: true);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatController) {
      return Scaffold(
        appBar: CustomRiderAppBar(title: widget.name, isBack: true,),

        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(children: [

              !chatController.isLoading?
               Expanded(
                  child: (chatController.messageModel.message != null && chatController.messageModel.message.isNotEmpty) ?
                  MessageListView(chatController: chatController, scrollController: _scrollController, userId: widget.userId) :
                  const SizedBox()): Expanded(child: CustomLoader(height: Get.height-300,)),
              Container(
                color: Theme.of(context).canvasColor,
                child: Column(children: [
                   MessageSendingSectionWidget(userId: widget.userId),
                ]),
              ), //: const SizedBox(),
            ]),
          ),
        ),
      );
    }
    );
  }
}

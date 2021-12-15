import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterWidget extends StatelessWidget {
  static const TEXT_STYLE = TextStyle(fontSize: 10, color: Colors.grey);

  const FooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  launch('https://play.google.com/store/account/subscriptions');
                },
                child: const Text("서비스 이용약관", style: TEXT_STYLE),
              ),
              const SizedBox(width: 10,),
              GestureDetector(
                onTap: () {
                  launch('https://play.google.com/store/account/subscriptions');
                },
                child: const Text("개인정보 처리방침", style: TEXT_STYLE),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Container(height: 1, color: const Color(0xffeeeeee)),
          const SizedBox(height: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("(주)코드플레이 대표이사 송명수", style: TEXT_STYLE),
              SizedBox(height: 5,),
              Text("사업자등록번호: 669-88-01204", style: TEXT_STYLE),
              SizedBox(height: 5,),
              Text("통신판매업신고: 2021-경기하남-2172호", style: TEXT_STYLE),
              SizedBox(height: 5,),
              Text("주소: 경기도 하남시 하남시청앞", style: TEXT_STYLE),
              SizedBox(height: 5,),
              Text("전자우편: sms0470@gmail.com", style: TEXT_STYLE)
            ],
          ),
          const SizedBox(height: 10,),
          Container(height: 1, color: const Color(0xffeeeeee)),
          const SizedBox(height: 10,),
          const Text(
            "(주)코드플레이는 통신판매중개시스템 제공자로서, 통신판매의 당사자가 아니며 상품의 예약, 이용 및 환불 등과 관련한 의무와 책임은 각 판매자에게 있습니다.",
            style: TEXT_STYLE
          ),
          const SizedBox(height: 30,),
        ]
      )

    );
  }
  
}
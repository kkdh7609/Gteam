import 'package:flutter/material.dart';

/* 아임포트 결제 모듈을 불러옵니다. */
import 'package:iamport_flutter/iamport_payment.dart';
/* 아임포트 결제 데이터 모델을 불러옵니다. */
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:gteams/pay/pay.dart';
import 'package:gteams/pay/result.dart';
import 'package:gteams/pay/payMethod.dart';

class IamPortPayment extends StatefulWidget {

  IamPortPayment({this.chargeType, this.PayMethodType});

  Cost chargeType;
  PayMethod PayMethodType;

  @override
  _IamPortPaymentState createState() => _IamPortPaymentState();
}

class _IamPortPaymentState extends State<IamPortPayment> {

  int chargeAmount;
  var payMethod;

  @override
  initState(){
    super.initState();
    setState(() {
      if(widget.chargeType == Cost.ONE_THOUSANDS)
        chargeAmount = 10000;
      else if(widget.chargeType == Cost.FIVE_THOUSANDS)
        chargeAmount = 50000;
      else if(widget.chargeType == Cost.TEN_THOUSANDS)
        chargeAmount = 100000;

      if(widget.PayMethodType == PayMethod.CARD)
        payMethod = 'card';
      else if(widget.PayMethodType == PayMethod.PHONE)
        payMethod = 'phone';
    });
  }

  @override
  Widget build(BuildContext context) {
    return IamportPayment(

      appBar: new AppBar(
        backgroundColor: Color(0xff20253d),
        title: new Text('G-TEAM Point Chrage'),
      ),
      /* 웹뷰 로딩 컴포넌트 */
      initialChild: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/iamport-logo.png'),
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20.0)),
              ),
            ],
          ),
        ),
      ),
      /* [필수입력] 가맹점 식별코드 */
      userCode: 'imp89644193',// 'iamport',
      /* [필수입력] 결제 데이터 */
      data: PaymentData.fromJson({
        'digital' : true,
        'pg': 'html5_inicis',                                          // PG사
        'payMethod': payMethod,                                            // 결제수단
        'name': '아임포트 결제데이터 분석',                                  // 주문명
        'merchantUid': 'mid_${DateTime.now().millisecondsSinceEpoch}', // 주문번호
        'amount': (chargeAmount * 0.01).toInt(),                        // 결제금액
        'buyerName': '홍길동',                                           // 구매자 이름
        'buyerTel': '01012345678',                                     // 구매자 연락처
        'buyerEmail': 'example@naver.com',                             // 구매자 이메일
        'buyerAddr': '서울시 강남구 신사동 661-16',                         // 구매자 주소
        'buyerPostcode': '06018',                                      // 구매자 우편번호
        'appScheme': 'example',                                        // 앱 URL scheme
      }),

      /* [필수입력] 콜백 함수 */
      callback: (Map<String, String> result) {
        PayMethods().getFund().then((data){
          int fund = data + chargeAmount;

          PayMethods().updateFund(fund).then((tempData){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PayResultPage(payResult: chargeAmount)));
          });
        });
      },
    );
  }
}
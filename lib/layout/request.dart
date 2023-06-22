import '../controller/ptient_controller.dart';
import '../helper/launch_screen.dart';
import '../helper/loading.dart';
import '../layout/add_patient.dart';
import '../layout/patient.dart';
import '../model/date.dart';
import '../model/price.dart';
import '../model/request.dart';
import '../model/sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../helper/my_appbar.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({required this.id, super.key});
  final int id;
  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<PatientController>(context, listen: false)
        .getRequest(widget.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    Request? request = Provider.of<PatientController>(context).request;
    var e = request != null ? request.state : 0;

    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          child: MyAppbar(
            title: request != null ? request.fullName : 'Request',
            isElevated: 0.0,
            opacity: 1.0,
            leading: true,
            textSize: 24,
          ),
          preferredSize: Size(_width, _height * 0.0615)),
      bottomNavigationBar: request == null
          ? Container(
              height: 1,
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(14.0, 2, 14, 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (request.state == 0 || request.state == 1)
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet<bool>(
                          context: context,
                          builder: (context) {
                            return RejectBottomSheet();
                          },
                        ).then((value) {
                          if (value != null) {
                            Navigator.of(context).pop();
                          }
                        });
                      },
                      child: SubmitButton(
                        textColor: 0xffEC1C2E,
                        width: request!.state == 0 || request!.state == 3
                            ? MediaQuery.of(context).size.width * 0.3
                            : MediaQuery.of(context).size.width * 0.8,
                        title: request!.state == 0 ? 'Reject' : "Cancel",
                        borderColor: 0xffEC1C2E,
                      ),
                    ),
                  if (request!.state == 0 || request!.state == 3)
                    InkWell(
                      onTap: () {
                        if (request.state == 3) {
                          if (request.updateId == null) {
                            Provider.of<PatientController>(context,
                                    listen: false)
                                .createSheetToSend(
                                    request.fullName,
                                    request!.gander == 'male' ? 0 : 1,
                                    '',
                                    null,
                                    request.age ?? '');
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PatientAdd(
                                method: 'newOrder',
                                user: UserInfo(
                                    patient_name: request.fullName,
                                    age: request.age ?? '',
                                    gender: request.gander),
                              ),
                            ));
                          } else {
                            Provider.of<PatientController>(context,
                                    listen: false)
                                .getShowSheet(request.updateId!.toString());
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PatientScreen(),
                            ));
                          }
                        } else {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (BuildContext context) =>
                                AcceptBottomSheet(),
                          ).then((value) {
                            if (value) {}
                          });
                        }
                      },
                      child: SubmitButton(
                        textColor: 0xffffffff,
                        color: 0xff0199EC,
                        title: request!.state == 3
                            ? request.updateId != null
                                ? 'Go To Sheet'
                                : 'Add To Patient'
                            : 'Accept',
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),
                    ),
                ],
              ),
            ),
      body: request == null
          ? Center(child: LaunchScreen())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(request!.image),
                              ),
                              Container(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request!.fullName,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    request.typeName,
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            width: 100,
                            height: 27,
                            decoration: BoxDecoration(
                                color: e == 0
                                    ? Color(0xff0199EC)
                                    : e == 1
                                        ? Color(0xffFFB42B)
                                        : e == 2
                                            ? Colors.red
                                            : e == 3
                                                ? Color(0xff028C59)
                                                : Color(0xffEC1C2E),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(
                                request.stateName,
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'mon'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      RequestField(
                          content: request.fullName, title: 'Full Name'),
                      RequestField(
                          content: request.mobile, title: 'Phone Number'),
                      RequestField(
                        content: 'Case Details',
                        title: 'Case Details',
                      ),
                      if (request.age != null)
                        RequestField(content: request.age!, title: 'Age'),
                      RequestField(content: request.gander, title: 'Gender'),
                      RequestField(content: request.date, title: 'Date'),
                      if (request.address != null)
                        RequestField(
                            content: request.address!, title: 'Address'),
                      RequestField(
                          content: request.bookingType, title: 'Booking Type'),
                      Container(
                        height: 20,
                      ),
                      if (request.paymentMethode != null )
                        Column(
                          children: [
                            Text(
                              'Payment Method',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            Image.network(
                              request.paymentMethode!,
                              width: 120,
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class RejectBottomSheet extends StatelessWidget {
  RejectBottomSheet({
    super.key,
  });

  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.45,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Text(
                  'Reason',
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'neo',
                      fontWeight: FontWeight.w500),
                ),
              ),
              TextField(
                controller: _controller,
                maxLines: 11,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red)),
                ),
              ),
              Spacer(),
              ElevatedButton(
                  onPressed: () {
                    Provider.of<PatientController>(context, listen: false)
                        .rejectRequest(_controller.text)
                        .then((value) {
                      if (value) {
                        Navigator.of(context).pop(true);
                      }
                    });
                  },
                  child: Text('Reject'))
            ],
          ),
        ),
      ),
    );
  }
}

class SubmitButton extends StatelessWidget {
  SubmitButton({
    required this.textColor,
    this.borderColor,
    this.color,
    required this.title,
    required this.width,
    super.key,
  });
  int? color;
  int textColor;
  int? borderColor;

  String title;
  double width;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: width,
      duration: Duration(milliseconds: 100),
      margin: EdgeInsets.symmetric(horizontal: 5),
      height: 50,
      decoration: BoxDecoration(
          border: borderColor == null
              ? null
              : Border.all(color: Color(borderColor!)),
          color: color != null ? Color(color!) : null,
          borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: Color(textColor)),
        ),
      ),
    );
  }
}

class RequestField extends StatelessWidget {
  const RequestField({
    required this.content,
    required this.title,
    super.key,
  });
  final String title;
  final String content;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 20,
        ),
        Text(
          title,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xffF6F6F6),
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Center(
                      child: Text(
                    content,
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'neo',
                        fontWeight: FontWeight.w500),
                  )),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class AcceptBottomSheet extends StatefulWidget {
  const AcceptBottomSheet({
    super.key,
  });

  @override
  State<AcceptBottomSheet> createState() => _AcceptBottomSheetState();
}

class _AcceptBottomSheetState extends State<AcceptBottomSheet> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<PatientController>(context, listen: false).getDates(
        Provider.of<PatientController>(context, listen: false)
            .request!
            .id
            .toString());
    Provider.of<PatientController>(context, listen: false).getPrices();
  }
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    List<AvailedDate>? dates = Provider.of<PatientController>(context).dates;
    int? selected = Provider.of<PatientController>(context).selectedDate;
    List<Price> prices = Provider.of<PatientController>(context).prices;
    Price selectedPrice = prices.isEmpty
        ? Price(
            id: 1,
            product_name: 'reservation_price_1',
            price: '1,000',
            productId: 'reservation_price_1')
        : prices[Provider.of<PatientController>(context).selectedPrice];
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: dates == null
                  ? Loading()
                  : GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5),
                      itemCount: dates!.length,
                      itemBuilder: (context, index) => GridTile(
                          child: GestureDetector(
                        onTap: () {
                          if (dates[index].isValid) {
                            Provider.of<PatientController>(context,
                                    listen: false)
                                .selectDate(index + 1);
                          }
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 150),
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: selected == dates[index].id
                                ? Colors.blue
                                : !dates[index].isValid
                                    ? Color(0xffF7227F).withOpacity(0.26)
                                    : Color(0xffFAFAFA),
                          ),
                          child: Center(
                              child: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                                fontSize: 16,
                                color: dates[index].id == selected
                                    ? Colors.white
                                    : !dates[index].isValid
                                        ? Color(0xffF7227F)
                                        : Colors.black),
                          )),
                        ),
                      )),
                    ),
            ),
            Container(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('cost'),
                GestureDetector(
                  onTap: () {
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          title: Text('Select Price'),
                          content: Container(
                            height: 150,
                            constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.6,
                                minHeight: MediaQuery.of(context).size.height *
                                    0.1), // Adjust the height as needed
                            child: ListView.builder(
                              itemCount: prices
                                  .length, // Number of options in the list
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    Provider.of<PatientController>(context,
                                            listen: false)
                                        .selectPrice(
                                            index); // Update the selected index
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                            color: CupertinoColors.separator),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          prices[index].product_name,
                                          style: TextStyle(
                                              color: selectedPrice.id ==
                                                      prices[index].id
                                                  ? Colors.blue
                                                  : Colors.black),
                                        ),
                                        Text(
                                          prices[index].price,
                                          style: TextStyle(
                                              color: selectedPrice.id ==
                                                      prices[index].id
                                                  ? Colors.blue
                                                  : Colors.grey,
                                              fontSize: 12),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(0xffF6F6F6),
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xffF7227F),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                              child: Text(
                            'IQD',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                        Text(selectedPrice.price),
                        Container()
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
              height: 20,
            ),
            Align(alignment: Alignment.bottomLeft, child: Text('Time')),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) {
                      DateTime selectedTime = DateTime.now();

                      return Container(
                        height: 300, // Adjust the height as needed
                        color: Colors.white,
                        child: Column(
                          children: [
                            Expanded(
                              // Wrap the Column with Expanded
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.time,
                                initialDateTime: selectedTime,
                                onDateTimeChanged: (DateTime newDateTime) {
                                  selectedTime = newDateTime;
                                },
                              ),
                            ),
                            CupertinoButton(
                              child: Text('Select'),
                              onPressed: () {
                                // Perform an action with the selected time
                                Navigator.of(context).pop(selectedTime);
                              },
                            ),
                            Container(
                              height: 30,
                            )
                          ],
                        ),
                      );
                    },
                  ).then((selectedTime) {
                    // Handle the selected time after the dialog is closed
                    if (selectedTime != null) {
                      // Do something with the selected time
                      String minute() {
                        if (selectedTime.minute.toString().length == 1) {
                          return '0${selectedTime.minute.toString()}';
                        } else {
                          return selectedTime.minute.toString();
                        }
                      }

                      print(minute());
                      Provider.of<PatientController>(context, listen: false)
                          .changeBokingTime('${selectedTime.hour}:${minute()}');
                    }
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Color(0xffF6F6F6),
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset('assets/images/time.svg'),
                        Text(Provider.of<PatientController>(context)
                                .bookingTime ??
                            'Select Time'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            ElevatedButton(
                onPressed: () {
                  if (!isLoading) {
                    setState(() {
                      isLoading = true;
                    });
                      Provider.of<PatientController>(context, listen: false)
                      .acceptRequest()
                      .then((value) {
                        isLoading = false;
                    if (value) {
                      Navigator.of(context).pop();
                    }
                  });
                  }
                
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 50,
                    child: Padding(
                      padding:  EdgeInsets.all(15.0),
                      child: Center(  child:isLoading? Container(
                        width: 25,
                        child: CircularProgressIndicator(color: Colors.white,)): Text('Accept')),
                    )))
          ],
        ),
      ),
    );
  }
}

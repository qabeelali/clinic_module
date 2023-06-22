import '../controller/ptient_controller.dart';
import '../helper/launch_screen.dart';
import '../helper/loading.dart';
import '../layout/request.dart';
import '../model/request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../helper/my_appbar.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<PatientController>(context, listen: false)
        .getRequests();
  }

  @override
  Widget build(BuildContext context) {
    List<RequestContainer>? items =
        Provider.of<PatientController>(context).requests;

    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          child: MyAppbar(
            title: 'Patient',
            isElevated: 0.0,
            opacity: 1.0,
            leading: true,
            actions: [
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => FilterBottomSheet(),
                    );
                  },
                  icon: SvgPicture.asset('assets/images/filter.svg'))
            ],
          ),
          preferredSize: Size(_width, _height * 0.0615)),
      body: items == null|| items.isEmpty
          ? LaunchScreen()
          : RefreshIndicator(
            onRefresh: ()async{
                Provider.of<PatientController>(context, listen: false)
        .getRequests();
            },
            child: ListView(
            
                children: 
                [
                   if(Provider.of<PatientController>(context).requestLoading)  AnimatedScale(
            scale: Provider.of<PatientController>(context).requestLoading? 1:0
            ,
            duration: Duration(milliseconds: 100), child: Center(child: CircularProgressIndicator()),),
                  ... items.map((e) => RequestWidget(items: e ,)  )]
                ,
              ),
          ),
    );
  }
}

class RequestWidget extends StatelessWidget {
  const RequestWidget({
    super.key,
    required this.items,
  });

  final RequestContainer items;

  @override
  Widget build(BuildContext context) {
    return Column(
      
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Divider(
                  color: Colors.grey,
                  height: 1,
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  items.date,
                  style: TextStyle(
                      color: Colors.black, fontSize: 18, fontFamily: 'neo'),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Colors.grey,
                  height: 1,
                  thickness: 1,
                ),
              ),
            ],
          ),
        ),
    
        ...items.orders.map(
          (e) => GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder:(context) => RequestScreen(id:e.id),)).then((value) {
 Provider.of<PatientController>(context, listen: false)
        .getRequests();
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.12,
              padding: EdgeInsets.all(8),
              child: Material(
                elevation: 1,
                borderRadius: BorderRadius.circular(11),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(e.image),
                      ),
                      Container(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(),
                          Text(
                            e.fullName,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            e.typeName,
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          Container()
                        ],
                      ),
                      Expanded(child: Container()),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                      e.seriesNum==null?Container(height: 20,):  Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                color: Color(0xffF7227F),
                                borderRadius: BorderRadius.circular(3)),
                            child: Center(
                              child: Text(
                                e.seriesNum.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            height: 10,
                          ),
                          Container(
                            width: 100,
                            height: 27,
                            decoration: BoxDecoration(
                              color:  e.state == 0
                              ? Color(0xff0199EC)
                              : e.state == 1
                              ? Color(0xffFFB42B)
                              : e.state == 2
                              ? Colors.red
                              : e.state == 3
                              ? Color(0xff028C59)
                              : Color(0xffEC1C2E),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(
                                e.stateName,
                                style: TextStyle(
                                    color: Colors.white, fontFamily: 'mon'),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    super.key,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    DateTime? date = Provider.of<PatientController>(context).filterTime;
    int? selected = Provider.of<PatientController>(context).selectedFilter;
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Colors.grey.withOpacity(0.7)),
            ),
            Container(
              height: 20,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Filtering',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            Container(
              height: 20,
            ),
            Row(
              children: [
                FilterButton(
                  color: 0xff0199EC,
                  title: 'New',
                  isSelected: selected == 0,
                  index: 0,
                ),
                FilterButton(
                  color: 0xffEC1C2E,
                  title: 'Rejected',
                  isSelected: selected == 2,
                  index: 2,
                ),
              ],
            ),
            Container(
              height: 10,
            ),
            Row(
              children: [
                FilterButton(
                  color: 0xff0199EC,
                  title: 'Accepted',
                  isSelected: selected == 1,
                  index: 1,
                ),
                FilterButton(
                  color: 0xff0199EC,
                  title: 'completed',
                  isSelected: selected == 3,
                  index: 3,
                ),
              ],
            ),
            Container(
              height: 10,
            ),
            Row(
              children: [
                FilterButton(
                  color: 0xff0199EC,
                  title: 'Canceled',
                  isSelected: selected == 4,
                  index: 4,
                ),
                FilterButton(
                  color: 0xff0199EC,
                  title: 'Paid',
                  isSelected: selected == 5,
                  index: 5,
                ),
              ],
            ),
            Container(
              height: 10,
            ),
            Row(
              children: [
                FilterButton(
                  color: 0xff0199EC,
                  title: 'Unpaid',
                  isSelected: selected == 8,
                  index: 8,
                ),
              ],
            ),
            Container(
              height: 20,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Date',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )),
            Container(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => DatePickerDialog(
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2022),
                            lastDate: DateTime(2033)),
                      ).then((value) {
                        DateTime? res = value;
                        if (res != null) {
                          Provider.of<PatientController>(context, listen: false)
                              .changeFilterDate(res);
                        }
                      });
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Color(0xff0199EC))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              date == null
                                  ? 'Choose Date'
                                  : '${date!.year}-${date.month}-${date.day}',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                            Row(
                              children: [
                                if (date != null)
                                  IconButton(
                                    onPressed: Provider.of<PatientController>(
                                            context,
                                            listen: false)
                                        .clearFilterDate,
                                    icon: SvgPicture.asset(
                                        'assets/images/undo.svg'),
                                  ),
                                Container(
                                  width: 10,
                                ),
                                SvgPicture.asset(
                                    'assets/images/filter_calinder.svg'),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                   Provider.of<PatientController>(context, listen: false).getRequests();
                   Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xff0199EC)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Center(
                          child: Text(
                            'Filter',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  FilterButton({
    required this.color,
    required this.title,
    required this.isSelected,
    required this.index,
    super.key,
  });
  int color;
  String title;
  bool isSelected;
  int index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Provider.of<PatientController>(context, listen: false)
              .changeFilter(index);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 5),
          height: 40,
          decoration: BoxDecoration(
              color: Color(isSelected ? color : 0xffffffff),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: isSelected ? Colors.white : Color(0xff0199EC))),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

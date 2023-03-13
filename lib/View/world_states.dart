import 'package:covid_19/View/countries_list.dart';
import 'package:covid_19/model/world_states_model.dart';
import 'package:covid_19/services/states_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({Key? key}) : super(key: key);

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: Duration(seconds: 5), vsync: this)
        ..repeat();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .01),
            FutureBuilder(
                future: statesServices.fetchWorldStatesRecord(),
                builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(
                        child: SpinKitFadingCircle(
                      color: Colors.white,
                      size: 50,
                      controller: _controller,
                    ));
                  } else {
                    return Column(children: [
                      PieChart(
                        dataMap: {
                          'Total':
                              double.parse(snapshot.data!.cases!.toString()),
                          'Recovered': double.parse(
                              snapshot.data!.recovered!.toString()),
                          'Death':
                              double.parse(snapshot.data!.deaths!.toString()),
                        },
                        chartValuesOptions: ChartValuesOptions(
                            showChartValuesInPercentage: true),
                        chartRadius: MediaQuery.of(context).size.width / 3.2,
                        legendOptions:
                            LegendOptions(legendPosition: LegendPosition.left),
                        animationDuration: Duration(milliseconds: 1200),
                        chartType: ChartType.ring,
                        colorList: colorList,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.height * .06),
                        child: Card(
                          child: Column(
                            children: [
                              ReUsableRow(
                                  title: 'Total',
                                  value: snapshot.data!.cases!.toString()),
                              ReUsableRow(
                                  title: 'Recovered',
                                  value: snapshot.data!.recovered!.toString()),
                              ReUsableRow(
                                  title: 'Deaths',
                                  value: snapshot.data!.deaths!.toString()),
                              ReUsableRow(
                                  title: 'Active',
                                  value: snapshot.data!.active!.toString()),
                              ReUsableRow(
                                  title: 'Critical',
                                  value: snapshot.data!.critical!.toString()),
                              ReUsableRow(
                                  title: 'Today Recovered',
                                  value: snapshot.data!.todayRecovered!.toString()),
                              ReUsableRow(
                                  title: 'Today Deaths',
                                  value: snapshot.data!.todayDeaths!.toString()),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CountriesListScreen()));
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xff1aa260),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              'Track Countries',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      )
                    ]);
                  }
                }),
          ],
        ),
      )),
    );
  }
}

class ReUsableRow extends StatelessWidget {
  String title, value;
  ReUsableRow({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
          ),
        ],
      ),
    );
  }
}

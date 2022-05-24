import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'package:techintern_app_project/widgets/custom_dropdown.dart';
import 'package:techintern_app_project/widgets/offer_list.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final formKey = GlobalKey<FormState>();

  var queryResultSet = [];
  var Selected = [];
  String? city = "", salary = "", language = "", specialization = "";
  TextEditingController textEditingController = TextEditingController();

  final List<String> listCity = [
    'Abha',
    'Dammam',
    'Dhahran',
    'Hofuf',
    'Jeddah',
    'Jizan',
    'Jubail',
    'King Abdullah Economic City',
    'Khobar',
    'Mecca',
    'Medina',
    'Riyadh'
  ];

  final CityDropdownCtrl = TextEditingController();

  final List<String> listSalary = [
    '0-500SR',
    '500-1000SR',
    '1000-1500SR',
    '1500-2000SR',
    '2000-2500SR',
    '2500-3000SR',
    '3000-3500SR',
    '3500-4000SR'
  ];

  final SalaryDropdownCtrl = TextEditingController();

  final List<String> listSpecialization = [
    'Database',
    'Web development',
    'Moblie development',
    'UX/UI',
    'System Analysis',
    'Cyber Security',
    'AI',
    'Full-stack development'
  ];

  final SpecializationhDropdownCtrl = TextEditingController();

  final List<String> listLanguage = [
    'JavaScript',
    'Kotlin',
    'Swift',
    'Python',
    'C++',
    'Java',
    'R',
    'php'
  ];

  final LanguageDropdownCtrl = TextEditingController();
  String? _startDate, _endDate;
  DateRangePickerController? _controller;
  DateTime? _start, _end, _today;

  @override
  void initState() {
    _controller = DateRangePickerController();
    _startDate = DateFormat('dd/MM/yyyy').format(DateTime.now()).toString();
    _endDate = DateFormat('dd/MM/yyyy')
        .format(DateTime.now().add(const Duration(days: 0)))
        .toString();
    _today = DateTime.now();
    _start = _today;
    _end = _today!.add(const Duration(days: 0));
    _controller!.selectedRange = PickerDateRange(_start, _end);
    textEditingController.text =
        "${_startDate.toString()} - ${_endDate.toString()}";

    super.initState();
  }

  @override
  void dispose() {
    CityDropdownCtrl.dispose();
    SalaryDropdownCtrl.dispose();
    SpecializationhDropdownCtrl.dispose();
    LanguageDropdownCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        elevation: .25,
        title: const Text(
          'Search Training',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        shrinkWrap: true,
        children: [
          // using form for validation
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'City',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                CustomDropdown.search(
                  hintText: 'Select a city',
                  items: listCity,
                  controller: CityDropdownCtrl,
                  excludeSelected: false,
                  onChanged: (String _city) {
                    city = _city;
                    setState(() {});
                  },
                ),
                const SizedBox(height: 24),
                const Divider(height: 0),
                const SizedBox(height: 24),
                const Text(
                  'Salary Range',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                CustomDropdown.search(
                  hintText: 'Select a salary range',
                  items: listSalary,
                  controller: SalaryDropdownCtrl,
                  excludeSelected: false,
                  onChanged: (String sal) {
                    salary = sal;
                    setState(() {});
                  },
                ),
                const SizedBox(height: 24),
                const Divider(height: 0),
                const SizedBox(height: 24),
                const Text(
                  'Specialization',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                CustomDropdown.search(
                  hintText: 'Select a specialization',
                  items: listSpecialization,
                  controller: SpecializationhDropdownCtrl,
                  excludeSelected: false,
                  onChanged: (String spec) {
                    specialization = spec;
                    setState(() {});
                  },
                ),
                const SizedBox(height: 24),
                const Divider(height: 0),
                const SizedBox(height: 24),
                const Text(
                  'Programming language',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                CustomDropdown.search(
                  hintText: 'Select a programming language',
                  items: listLanguage,
                  controller: LanguageDropdownCtrl,
                  excludeSelected: false,
                  onChanged: (String language) {
                    language = language;
                    setState(() {});
                  },
                ),
                const SizedBox(height: 24),
                // const Text(
                //   'Date Range',
                //   style: _labelStyle,
                // ),
                // const SizedBox(height: 5),

                const Divider(height: 0),
                const SizedBox(height: 24),
                const Text(
                  'Date Range',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: const Text(
                                "Date Range",
                                style: TextStyle(color: Color(0xff3B7753)),
                              ),
                              content: Container(
                                height: 355,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  children: <Widget>[
                                    getDateRangePicker(),
                                    MaterialButton(
                                      child: const Text("OK"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              ));
                        });
                  },
                  child: TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(8),
                        // color: Colors.white
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),

                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      //labelText: "Date Range",
                    ),
                    enabled: false,
                    keyboardType: TextInputType.none,
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(height: 0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xff3B7753))),
                    onPressed: () async {
                      // if (formKey.currentState!.validate()) {
                      //   initiateSearch(Selected);
                      // }
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OfferList(
                                city: city,
                                salary: salary,
                                specialization: specialization,
                                language: LanguageDropdownCtrl.text,
                                startOfTheDay: _startDate,
                                endOfTheDay: _endDate,
                              )));

                      // QuerySnapshot<Map<String, dynamic>> data =
                      //     await FirebaseFirestore.instance
                      //         .collection("offerList")
                      //         .get();
                      // data.docs.forEach((element) {
                      //    ListData listData = ListData.fromJson(element.data());
                      // });
                    },
                    child: const Text(
                      'Search',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _startDate =
          DateFormat('dd/MM/yyyy').format(args.value.startDate).toString();
      _endDate = DateFormat('dd/MM/yyyy')
          .format(args.value.endDate ?? args.value.startDate)
          .toString();
      print(
          "Start Date :" + _startDate.toString() + "  " + _endDate.toString());
      textEditingController.text =
          "${_startDate.toString()} - ${_endDate.toString()}";
    });
  }

  getDateRangePicker() {
    return SfDateRangePicker(
      controller: _controller,
      selectionMode: DateRangePickerSelectionMode.range,
      onSelectionChanged: selectionChanged,
      rangeSelectionColor: const Color(0xff3B7753).withAlpha(40),
      selectionColor: const Color(0xff3B7753),
      startRangeSelectionColor: const Color(0xff3B7753),
      endRangeSelectionColor: const Color(0xff3B7753),
      todayHighlightColor: const Color(0xff3B7753),
      allowViewNavigation: false,
    );
  }
}

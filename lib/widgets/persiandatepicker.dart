import 'package:flutter/material.dart';

class PersianDatePicker extends StatefulWidget {
  final void Function(String month, int year) onDateChanged;

  const PersianDatePicker({super.key, required this.onDateChanged});

  @override
  State<PersianDatePicker> createState() => PersianDatePickerState();
}

class PersianDatePickerState extends State<PersianDatePicker> {
  final List<String> months = [
    'فروردین', 'اردیبهشت', 'خرداد', 'تیر',
    'مرداد', 'شهریور', 'مهر', 'آبان',
    'آذر', 'دی', 'بهمن', 'اسفند'
  ];

  late List<int> years;
  String selectedMonth = 'فروردین';
  int selectedYear = 1402;
  String selectedIndexMonth = "01";

  @override
  void initState() {
    super.initState();
    years = List.generate(11, (index) => 1402 + index);
  }
  // ✅ دسترسی از بیرون
  String getSelectedMonth() => selectedMonth;
  int getSelectedYear() => selectedYear;

  Map<String, dynamic> getSelectedDate() => {
    'month': selectedMonth,
    'year': selectedYear,
  };

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.calendar_today, color: Colors.purple),
              SizedBox(width: 8),
              Text(
                'انتخاب تاریخ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              // ماه
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedMonth,
                      icon: const Icon(Icons.arrow_drop_down),
                      items: months
                          .map((month) => DropdownMenuItem(
                        value: month,
                        child: Text(
                          month,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMonth =value!;
                          int selectedIndex = months.indexOf(value!)+1;
                          selectedIndexMonth = selectedIndex.toString().padLeft(2, '0');
                        });
                        widget.onDateChanged(selectedIndexMonth, selectedYear);
                      },

                        dropdownColor: Colors .purple.shade50,

                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // سال
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: selectedYear,
                      icon: const Icon(Icons.arrow_drop_down),
                      items: years
                          .map((year) => DropdownMenuItem(
                        value: year,
                        child: Text(
                          '$year',
                          style: const TextStyle(fontSize: 14),
                        ),

                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedYear = value!;
                        });
                        widget.onDateChanged(selectedIndexMonth, selectedYear);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

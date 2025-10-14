import 'package:flutter/material.dart';

class UserStatusSelector extends StatefulWidget {
  final String initialStatus;
  final ValueChanged<String> onStatusChanged;

  const UserStatusSelector({
    Key? key,
    required this.initialStatus,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  _UserStatusSelectorState createState() => _UserStatusSelectorState();
}

class _UserStatusSelectorState extends State<UserStatusSelector> {
  late String selectedStatus;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.initialStatus;
  }

  void _selectStatus(String status) {
    setState(() {
      selectedStatus = status;
    });
    widget.onStatusChanged(status);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.0,
      children: [
        ChoiceChip(
          avatar: Icon(Icons.check_circle, color: selectedStatus == 'active' ? Colors.white : Colors.green),
          label: Text(
            'فعال',
            style: TextStyle(
              color: selectedStatus == 'active' ? Colors.white : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          selected: selectedStatus == 'active',
          selectedColor: Colors.green,
          backgroundColor: Colors.green.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onSelected: (_) => _selectStatus('active'),
        ),
        ChoiceChip(
          avatar: Icon(Icons.lock, color: selectedStatus == 'inactive' ? Colors.white : Colors.red),
          label: Text(
            'غیرفعال',
            style: TextStyle(
              color: selectedStatus == 'inactive' ? Colors.white : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          selected: selectedStatus == 'inactive',
          selectedColor: Colors.red,
          backgroundColor: Colors.red.shade50,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onSelected: (_) => _selectStatus('inactive'),
        ),
      ],
    );
  }
}

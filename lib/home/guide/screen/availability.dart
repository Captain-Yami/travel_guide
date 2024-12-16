import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; // Import shared_preferences
import 'package:travel_guide/home/guide/screen/guide_homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Availability extends StatefulWidget {
  const Availability({super.key});

  @override
  State<Availability> createState() => _AvailabilityState();
}

class _AvailabilityState extends State<Availability> {
  bool isSelected = false; // To track if the selection is on or off
  TimeOfDay _startTime = TimeOfDay(hour: 9, minute: 0); // Default: 9:00 AM
  TimeOfDay _endTime = TimeOfDay(hour: 17, minute: 0); // Default: 5:00 PM

  // Track selected days of the week
  final List<bool> _selectedDays = List.generate(7, (index) => false); // 7 days of the week
  final List<String> _daysOfWeek = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  void initState() {
    super.initState();
    _loadAvailabilityStatus();
  }

  // Load the availability status from SharedPreferences
 Future<void> _loadAvailabilityStatus() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Assuming that you have a Firebase user authentication and you can get the user ID
  String userId = FirebaseAuth.instance.currentUser?.uid ?? ''; // Get the current user's UID
  
  try {
    // Fetch the availability data from Firestore
    DocumentSnapshot docSnapshot = await firestore
        .collection('Guide')
        .doc(userId) // Use the user's uid to retrieve their data
        .collection('availability')
        .doc('data') // Document ID
        .get();

    if (docSnapshot.exists) {
      var data = docSnapshot.data() as Map<String, dynamic>;

      setState(() {
        isSelected = data['isSelected'] ?? false;

        _startTime = TimeOfDay(
          hour: data['startTime']['hour'],
          minute: data['startTime']['minute'],
        );
        _endTime = TimeOfDay(
          hour: data['endTime']['hour'],
          minute: data['endTime']['minute'],
        );

        List<String> days = List<String>.from(data['selectedDays']);
        _selectedDays.setAll(0, List.generate(7, (index) {
          return days.contains(_daysOfWeek[index]);
        }));
      });
      print("Availability loaded successfully!");
    }
  } catch (e) {
    print("Error loading availability: $e");
  }
}



  // Save the availability status to SharedPreferences
  Future<void> _saveAvailabilityStatus() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Assuming that you have a Firebase user authentication and you can get the user ID
  String userId = FirebaseAuth.instance.currentUser?.uid ?? ''; // Get the current user's UID

  try {
    // Save availability data to Firestore
    await firestore.collection('Guide')
      .doc(userId)  // Use the user's uid to store their data
      .collection('availability') // Sub-collection for availability
      .doc('data') // You can use a static document name like 'data' for availability
      .set({
        'isSelected': isSelected,
        'startTime': {
          'hour': _startTime.hour,
          'minute': _startTime.minute,
        },
        'endTime': {
          'hour': _endTime.hour,
          'minute': _endTime.minute,
        },
        'selectedDays': _selectedDays.asMap().entries
          .where((entry) => entry.value)
          .map((entry) => _daysOfWeek[entry.key])
          .toList(),
      });

    print("Availability saved successfully!");
  } catch (e) {
    print("Error saving availability: $e");
  }
}


  // Function to show the time picker
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    if (!isSelected) {
      return; // Do nothing if availability is not selected
    }

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = pickedTime;
        } else {
          if (pickedTime.hour > _startTime.hour ||
              (pickedTime.hour == _startTime.hour && pickedTime.minute > _startTime.minute)) {
            _endTime = pickedTime;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('End time must be after start time')),
            );
          }
        }
      });
      _saveAvailabilityStatus(); // Save the time after selecting
    }
  }

  // Function to show the dropdown with checkboxes to select days
  Future<void> _selectDays(BuildContext context) async {
  if (!isSelected) {
    return; // Do nothing if availability is not selected
  }

  // Show the dialog with updated state handling
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setStateDialog) {
          return AlertDialog(
            title: const Text("Select Days"),
            content: SingleChildScrollView(
              child: Column(
                children: List.generate(_daysOfWeek.length, (index) {
                  return CheckboxListTile(
                    title: Text(_daysOfWeek[index]),
                    value: _selectedDays[index],
                    onChanged: (bool? value) {
                      setStateDialog(() {
                        _selectedDays[index] = value ?? false; // Update the state inside the dialog
                      });
                      _saveAvailabilityStatus(); // Save selected days
                    },
                  );
                }),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
              TextButton(
                onPressed: () {
                  setStateDialog(() {
                    // Reset selection
                    _selectedDays.fillRange(0, _selectedDays.length, false);
                  });
                  _saveAvailabilityStatus(); // Save reset selection
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
            ],
          );
        },
      );
    },
  );
}



  void _navigateToGuideHomepage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GuideHomepage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 42, 41, 41),
        title: Row(
          children: const [
            SizedBox(width: 20),
            Text(
              'Set availability',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Image.asset(
              'asset/tick_mark.png',
              width: 40,
              height: 40,
            ),
            onPressed: _navigateToGuideHomepage,
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Availability Status:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected = !isSelected;
                    });
                    _saveAvailabilityStatus(); // Save state to SharedPreferences when toggled
                  },
                  child: Container(
                    width: 60,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: isSelected ? Colors.green : Colors.grey,
                    ),
                    child: Align(
                      alignment: isSelected
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          width: 20,
height: 20,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Text(
              'Select Time Interval:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: isSelected ? () => _selectTime(context, true) : null,
                  child: Text(
                    'Start: ${_startTime.format(context)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                ElevatedButton(
                  onPressed: isSelected ? () => _selectTime(context, false) : null,
                  child: Text(
                    'End: ${_endTime.format(context)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Days of the Week Selection Section
            const Text(
              'Select Days of the Week:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: isSelected ? () => _selectDays(context) : null, // Only enable if selected
              child: const Text('Select Days'),
            ),
          ],
        ),
      ),
    );
  }
}
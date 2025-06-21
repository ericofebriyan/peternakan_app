// calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _currentMonth;
  late DateTime _selectedDate;
  final Map<DateTime, List<CalendarEvent>> _events = {
    DateTime(2025, 6, 10): [
      CalendarEvent(
        title: 'Vaksinasi Sapi',
        time: '09:00 - 11:00',
        location: 'Kandang Utara',
        color: Colors.blue,
      ),
    ],
    DateTime(2025, 6, 15): [
      CalendarEvent(
        title: 'Pemeriksaan Kesehatan',
        time: '08:00 - 10:00',
        location: 'Kandang Selatan',
        color: Colors.green,
      ),
      CalendarEvent(
        title: 'Pengiriman Pakan',
        time: '13:00 - 14:00',
        location: 'Gudang Pakan',
        color: Colors.orange,
      ),
    ],
    DateTime(2025, 6, 20): [
      CalendarEvent(
        title: 'Pemotongan Ternak',
        time: '10:00 - 12:00',
        location: 'Rumah Potong',
        color: Colors.red,
      ),
    ],
    DateTime(2025, 6, 25): [
      CalendarEvent(
        title: 'Pengecekan Kandang',
        time: '07:00 - 09:00',
        location: 'Semua Kandang',
        color: Colors.purple,
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _selectedDate = DateTime.now();
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  List<DateTime> _getDaysInMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);

    final days = <DateTime>[];
    for (int i = 0; i < firstDay.weekday; i++) {
      days.add(firstDay.subtract(Duration(days: firstDay.weekday - i)));
    }

    for (int i = 0; i < lastDay.day; i++) {
      days.add(DateTime(month.year, month.month, i + 1));
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _getDaysInMonth(_currentMonth);
    final monthName = DateFormat('MMMM yyyy').format(_currentMonth);
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(title: const Text('Kalender Kegiatan Peternakan')),
      body: Column(
        children: [
          // Header bulan
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: _previousMonth,
                ),
                Text(
                  monthName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: _nextMonth,
                ),
              ],
            ),
          ),

          // Nama hari dalam seminggu
          const Row(
            children: [
              Expanded(child: Center(child: Text('M'))),
              Expanded(child: Center(child: Text('S'))),
              Expanded(child: Center(child: Text('S'))),
              Expanded(child: Center(child: Text('R'))),
              Expanded(child: Center(child: Text('K'))),
              Expanded(child: Center(child: Text('J'))),
              Expanded(child: Center(child: Text('S'))),
            ],
          ),

          // Kalender
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
              ),
              itemCount: daysInMonth.length,
              itemBuilder: (context, index) {
                final date = daysInMonth[index];
                final isCurrentMonth = date.month == _currentMonth.month;
                final isToday =
                    date.year == today.year &&
                    date.month == today.month &&
                    date.day == today.day;
                final isSelected =
                    date.year == _selectedDate.year &&
                    date.month == _selectedDate.month &&
                    date.day == _selectedDate.day;
                final hasEvents = _events.containsKey(
                  DateTime(date.year, date.month, date.day),
                );

                return GestureDetector(
                  onTap: () => _selectDate(date),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.green[100]
                          : isToday
                          ? Colors.blue[50]
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday ? Border.all(color: Colors.blue) : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          date.day.toString(),
                          style: TextStyle(
                            color: isCurrentMonth ? Colors.black : Colors.grey,
                            fontWeight: isToday
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        if (hasEvents)
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            height: 4,
                            width: 4,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Daftar kegiatan untuk tanggal terpilih
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Kegiatan Hari Ini',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Daftar kegiatan
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                if (_events[_selectedDate] != null)
                  ..._events[_selectedDate]!.map(
                    (event) => _buildEventCard(event),
                  )
                else
                  const Center(
                    child: Text(
                      'Tidak ada kegiatan untuk hari ini',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(CalendarEvent event) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: event.color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.event, color: event.color, size: 30),
        ),
        title: Text(event.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text(event.time),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 4),
                Text(event.location),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // Aksi ketika event diklik
        },
      ),
    );
  }
}

class CalendarEvent {
  final String title;
  final String time;
  final String location;
  final Color color;

  CalendarEvent({
    required this.title,
    required this.time,
    required this.location,
    required this.color,
  });
}

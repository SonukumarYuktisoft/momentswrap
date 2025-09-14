// ======================== DATA MODELS ========================

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:momentswrap/util/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Event {
  final String id;
  final String title;
  final String subtitle;
  final DateTime date;
  final EventType type;
  final IconData icon;
  final String? description;
  final List<String>? giftSuggestions;
  final bool isRecurring;
  final RecurrenceType? recurrenceType;

  Event({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.type,
    required this.icon,
    this.description,
    this.giftSuggestions,
    this.isRecurring = false,
    this.recurrenceType,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'date': date.millisecondsSinceEpoch,
      'type': type.index,
      'icon': icon.codePoint,
      'description': description,
      'giftSuggestions': giftSuggestions,
      'isRecurring': isRecurring,
      'recurrenceType': recurrenceType?.index,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      type: EventType.values[json['type']],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      description: json['description'],
      giftSuggestions: json['giftSuggestions'] != null
          ? List<String>.from(json['giftSuggestions'])
          : null,
      isRecurring: json['isRecurring'] ?? false,
      recurrenceType: json['recurrenceType'] != null
          ? RecurrenceType.values[json['recurrenceType']]
          : null,
    );
  }
}

enum EventType { festival, birthday, anniversary, custom }

enum RecurrenceType { yearly, monthly, none }

// ======================== FESTIVAL DATA SERVICE ========================

class FestivalDataService {
  static List<Event> getIndianFestivals2024_2025() {
    return [
      // 2024 Festivals
      Event(
        id: 'diwali_2024',
        title: 'Diwali',
        subtitle: 'Festival of Lights',
        date: DateTime(2024, 11, 1),
        type: EventType.festival,
        icon: Icons.celebration,
        description: 'Hindu festival of lights celebrating good over evil',
        giftSuggestions: [
          'Sweets',
          'Diyas',
          'Jewelry',
          'Gold Coins',
          'Rangoli Sets',
        ],
        isRecurring: true,
        recurrenceType: RecurrenceType.yearly,
      ),
      Event(
        id: 'karva_chauth_2024',
        title: 'Karva Chauth',
        subtitle: 'Fast for Husband',
        date: DateTime(2024, 10, 20),
        type: EventType.festival,
        icon: Icons.favorite,
        giftSuggestions: ['Sargi Thali', 'Jewelry', 'Clothes', 'Mehndi Sets'],
      ),
      Event(
        id: 'dhanteras_2024',
        title: 'Dhanteras',
        subtitle: 'Wealth & Prosperity',
        date: DateTime(2024, 10, 29),
        type: EventType.festival,
        icon: Icons.monetization_on,
        giftSuggestions: ['Gold', 'Silver Items', 'Utensils', 'Electronics'],
      ),
      Event(
        id: 'bhai_dooj_2024',
        title: 'Bhai Dooj',
        subtitle: 'Brother-Sister Bond',
        date: DateTime(2024, 11, 3),
        type: EventType.festival,
        icon: Icons.family_restroom,
        giftSuggestions: ['Tilak Items', 'Sweets', 'Gifts for Siblings'],
      ),

      // 2025 Festivals
      Event(
        id: 'makar_sankranti_2025',
        title: 'Makar Sankranti',
        subtitle: 'Kite Festival',
        date: DateTime(2025, 1, 14),
        type: EventType.festival,
        icon: Icons.airplanemode_active,
        giftSuggestions: ['Kites', 'Til-Gud', 'Warm Clothes'],
      ),
      Event(
        id: 'republic_day_2025',
        title: 'Republic Day',
        subtitle: 'National Holiday',
        date: DateTime(2025, 1, 26),
        type: EventType.festival,
        icon: Icons.flag,
        giftSuggestions: ['Patriotic Items', 'Books', 'Indian Handicrafts'],
      ),
      Event(
        id: 'vasant_panchami_2025',
        title: 'Vasant Panchami',
        subtitle: 'Saraswati Puja',
        date: DateTime(2025, 2, 2),
        type: EventType.festival,
        icon: Icons.school,
        giftSuggestions: ['Books', 'Music Instruments', 'Yellow Clothes'],
      ),
      Event(
        id: 'maha_shivratri_2025',
        title: 'Maha Shivratri',
        subtitle: 'Lord Shiva Festival',
        date: DateTime(2025, 2, 26),
        type: EventType.festival,
        icon: Icons.temple_hindu,
        giftSuggestions: ['Rudraksha', 'Shiva Items', 'Fast Items'],
      ),
      Event(
        id: 'holi_2025',
        title: 'Holi',
        subtitle: 'Festival of Colors',
        date: DateTime(2025, 3, 14),
        type: EventType.festival,
        icon: Icons.palette,
        giftSuggestions: ['Colors', 'Water Guns', 'Sweets', 'Party Items'],
      ),
      Event(
        id: 'ram_navami_2025',
        title: 'Ram Navami',
        subtitle: 'Lord Rama Birthday',
        date: DateTime(2025, 4, 6),
        type: EventType.festival,
        icon: Icons.temple_hindu,
        giftSuggestions: ['Religious Books', 'Idol', 'Prasad Items'],
      ),
      Event(
        id: 'hanuman_jayanti_2025',
        title: 'Hanuman Jayanti',
        subtitle: 'Hanuman Birthday',
        date: DateTime(2025, 4, 13),
        type: EventType.festival,
        icon: Icons.fitness_center,
        giftSuggestions: ['Hanuman Items', 'Sindoor', 'Religious Books'],
      ),
      Event(
        id: 'akshaya_tritiya_2025',
        title: 'Akshaya Tritiya',
        subtitle: 'Gold Buying Day',
        date: DateTime(2025, 5, 1),
        type: EventType.festival,
        icon: Icons.star,
        giftSuggestions: ['Gold', 'Silver', 'New Ventures Items'],
      ),
      Event(
        id: 'mothers_day_2025',
        title: 'Mother\'s Day',
        subtitle: 'Celebrate Mom',
        date: DateTime(2025, 5, 11),
        type: EventType.festival,
        icon: Icons.favorite,
        giftSuggestions: [
          'Flowers',
          'Jewelry',
          'Spa Items',
          'Personalized Gifts',
        ],
      ),
      Event(
        id: 'raksha_bandhan_2025',
        title: 'Raksha Bandhan',
        subtitle: 'Brother-Sister Love',
        date: DateTime(2025, 8, 9),
        type: EventType.festival,
        icon: Icons.favorite,
        giftSuggestions: ['Rakhi', 'Sweets', 'Gifts for Siblings'],
      ),
      Event(
        id: 'krishna_janmashtami_2025',
        title: 'Krishna Janmashtami',
        subtitle: 'Lord Krishna Birthday',
        date: DateTime(2025, 8, 16),
        type: EventType.festival,
        icon: Icons.child_care,
        giftSuggestions: ['Krishna Items', 'Sweets', 'Decorations'],
      ),
      Event(
        id: 'ganesh_chaturthi_2025',
        title: 'Ganesh Chaturthi',
        subtitle: 'Lord Ganesha Festival',
        date: DateTime(2025, 8, 27),
        type: EventType.festival,
        icon: Icons.celebration,
        giftSuggestions: ['Ganesha Idol', 'Modak', 'Decorations'],
      ),
    ];
  }
}

// ======================== USER EVENTS STORAGE ========================

class UserEventStorage {
  static const String _eventsKey = 'user_events';

  static Future<List<Event>> getUserEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getStringList(_eventsKey) ?? [];
    // Fixed: Changed Event.tojson to Event.fromJson
    return eventsJson.map((json) => Event.fromJson(jsonDecode(json))).toList();
  }

  // Rest of the methods remain the same...
  static Future<void> saveUserEvent(Event event) async {
    final events = await getUserEvents();
    events.add(event);
    await _saveEvents(events);
  }

  static Future<void> updateUserEvent(
    String eventId,
    Event updatedEvent,
  ) async {
    final events = await getUserEvents();
    final index = events.indexWhere((e) => e.id == eventId);
    if (index != -1) {
      events[index] = updatedEvent;
      await _saveEvents(events);
    }
  }

  static Future<void> deleteUserEvent(String eventId) async {
    final events = await getUserEvents();
    events.removeWhere((e) => e.id == eventId);
    await _saveEvents(events);
  }

  static Future<void> _saveEvents(List<Event> events) async {
    final prefs = await SharedPreferences.getInstance();
    // This line is already correct - no change needed
    final eventsJson = events.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_eventsKey, eventsJson);
  }
}

// ======================== EVENTS SERVICE ========================

class EventsService {
  static List<Event> getUpcomingEvents({int days = 30}) {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: days));

    final festivals = FestivalDataService.getIndianFestivals2024_2025();

    return festivals.where((event) {
      return event.date.isAfter(now) && event.date.isBefore(endDate);
    }).toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  static Future<List<Event>> getUpcomingUserEvents({int days = 30}) async {
    final now = DateTime.now();
    final endDate = now.add(Duration(days: days));

    final userEvents = await UserEventStorage.getUserEvents();

    return userEvents.where((event) {
      return event.date.isAfter(now) && event.date.isBefore(endDate);
    }).toList()..sort((a, b) => a.date.compareTo(b.date));
  }

  static List<Event> getEventsByMonth(DateTime month) {
    final festivals = FestivalDataService.getIndianFestivals2024_2025();
    return festivals.where((event) {
      return event.date.month == month.month && event.date.year == month.year;
    }).toList();
  }
}

// ======================== MODERN UPCOMING EVENTS CARD ========================

class ModernUpcomingEventsCard extends StatelessWidget {
  final String title;
  final List<Event> events;
  final VoidCallback? onSeeMore;
  final VoidCallback? onAddEvent;

  const ModernUpcomingEventsCard({
    super.key,
    required this.title,
    required this.events,
    this.onSeeMore,
    this.onAddEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accentColor,
            AppColors.accentColor.withOpacity(0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.15),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Modern Title Row
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.primaryColor,
                  size: 18,
                ),
              ),
              SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              Spacer(),
              if (onAddEvent != null)
                GestureDetector(
                  onTap: onAddEvent,
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.add,
                      color: AppColors.primaryColor,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Event Items
          if (events.isEmpty)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.event_busy, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    'No upcoming events',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          else
            ...events
                .take(3)
                .map(
                  (event) => Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: ModernEventRow(
                      event: event,
                      onTap: () => _showEventDetails(context, event),
                    ),
                  ),
                ),

          if (events.length > 3 && onSeeMore != null) ...[
            const SizedBox(height: 16),
            // Modern See More Button
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton.icon(
                  onPressed: onSeeMore,
                  icon: Text(
                    'See More (${events.length - 3}+)',
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  label: Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.primaryColor,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showEventDetails(BuildContext context, Event event) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EventDetailsBottomSheet(event: event),
    );
  }
}

// ======================== MODERN EVENT ROW ========================

class ModernEventRow extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;

  const ModernEventRow({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    final daysUntil = event.date.difference(DateTime.now()).inDays;
    final isToday = daysUntil == 0;
    final isTomorrow = daysUntil == 1;

    String dateText;
    if (isToday) {
      dateText = "Today";
    } else if (isTomorrow) {
      dateText = "Tomorrow";
    } else if (daysUntil < 7) {
      dateText = "${daysUntil} days";
    } else {
      dateText = DateFormat('d MMM').format(event.date);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isToday
              ? AppColors.primaryColor.withOpacity(0.15)
              : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: isToday
              ? Border.all(color: AppColors.primaryColor, width: 1.5)
              : null,
        ),
        child: Row(
          children: [
            // Event Icon
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getEventColor(event.type).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                event.icon,
                color: _getEventColor(event.type),
                size: 20,
              ),
            ),
            SizedBox(width: 12),

            // Event Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textColor,
                    ),
                  ),
                  if (event.subtitle.isNotEmpty)
                    Text(
                      event.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textColor.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
            ),

            // Date & Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  dateText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isToday
                        ? AppColors.primaryColor
                        : AppColors.textColor.withOpacity(0.8),
                  ),
                ),
                if (event.type == EventType.festival)
                  Container(
                    margin: EdgeInsets.only(top: 2),
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Festival',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),

            // Chevron
            SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: AppColors.textColor.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Color _getEventColor(EventType type) {
    switch (type) {
      case EventType.festival:
        return Colors.orange;
      case EventType.birthday:
        return Colors.pink;
      case EventType.anniversary:
        return Colors.purple;
      case EventType.custom:
        return Colors.blue;
    }
  }
}

// ======================== ADD EVENT BOTTOM SHEET ========================

class AddEventBottomSheet extends StatefulWidget {
  @override
  _AddEventBottomSheetState createState() => _AddEventBottomSheetState();
}

class _AddEventBottomSheetState extends State<AddEventBottomSheet> {
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  EventType _selectedType = EventType.birthday;
  IconData _selectedIcon = Icons.cake;
  bool _isRecurring = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Add Family Event',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Event Title
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Event Title',
                      hintText: 'e.g., Papa\'s Birthday',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Event Subtitle
                  TextField(
                    controller: _subtitleController,
                    decoration: InputDecoration(
                      labelText: 'Subtitle (Optional)',
                      hintText: 'e.g., 55 Years, 25th Anniversary',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Event Type
                  DropdownButtonFormField<EventType>(
                    value: _selectedType,
                    decoration: InputDecoration(
                      labelText: 'Event Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: EventType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(_getEventTypeName(type)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                        _selectedIcon = _getEventTypeIcon(value);
                      });
                    },
                  ),
                  SizedBox(height: 16),

                  // Date Picker
                  GestureDetector(
                    onTap: _selectDate,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today),
                          SizedBox(width: 12),
                          Text(
                            DateFormat('dd MMMM yyyy').format(_selectedDate),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Recurring Switch
                  SwitchListTile(
                    title: Text('Repeat every year'),
                    subtitle: Text('Birthday and anniversary events'),
                    value: _isRecurring,
                    onChanged: (value) {
                      setState(() {
                        _isRecurring = value;
                      });
                    },
                  ),
                  SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveEvent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Save Event',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365 * 5)),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _saveEvent() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter event title')));
      return;
    }

    final event = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      subtitle: _subtitleController.text.trim(),
      date: _selectedDate,
      type: _selectedType,
      icon: _selectedIcon,
      isRecurring: _isRecurring,
      recurrenceType: _isRecurring
          ? RecurrenceType.yearly
          : RecurrenceType.none,
    );

    await UserEventStorage.saveUserEvent(event);
    Navigator.pop(context);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Event saved successfully!')));
  }

  String _getEventTypeName(EventType type) {
    switch (type) {
      case EventType.birthday:
        return 'Birthday';
      case EventType.anniversary:
        return 'Anniversary';
      case EventType.custom:
        return 'Custom Event';
      case EventType.festival:
        return 'Festival';
    }
  }

  IconData _getEventTypeIcon(EventType type) {
    switch (type) {
      case EventType.birthday:
        return Icons.cake;
      case EventType.anniversary:
        return Icons.favorite;
      case EventType.custom:
        return Icons.event;
      case EventType.festival:
        return Icons.celebration;
    }
  }
}

// ======================== EVENT DETAILS BOTTOM SHEET ========================

class EventDetailsBottomSheet extends StatelessWidget {
  final Event event;

  const EventDetailsBottomSheet({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final daysUntil = event.date.difference(DateTime.now()).inDays;

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _getEventColor(event.type).withOpacity(0.1),
                            _getEventColor(event.type).withOpacity(0.05),
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          // Event Icon
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: _getEventColor(
                                event.type,
                              ).withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              event.icon,
                              color: _getEventColor(event.type),
                              size: 40,
                            ),
                          ),
                          SizedBox(height: 16),

                          // Event Title & Subtitle
                          Text(
                            event.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (event.subtitle.isNotEmpty)
                            Text(
                              event.subtitle,
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textColor.withOpacity(0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),

                          SizedBox(height: 16),

                          // Date & Countdown
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _getEventColor(
                                event.type,
                              ).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              daysUntil == 0
                                  ? "Today!"
                                  : daysUntil == 1
                                  ? "Tomorrow"
                                  : "$daysUntil days to go",
                              style: TextStyle(
                                color: _getEventColor(event.type),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Event Details
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date Info
                          _buildInfoRow(
                            Icons.calendar_today,
                            "Date",
                            DateFormat('EEEE, MMMM d, yyyy').format(event.date),
                          ),
                          SizedBox(height: 16),

                          // Event Type
                          _buildInfoRow(
                            Icons.category,
                            "Type",
                            _getEventTypeName(event.type),
                          ),

                          if (event.isRecurring) ...[
                            SizedBox(height: 16),
                            _buildInfoRow(
                              Icons.refresh,
                              "Recurring",
                              "Every Year",
                            ),
                          ],

                          if (event.description != null &&
                              event.description!.isNotEmpty) ...[
                            SizedBox(height: 24),
                            Text(
                              "Description",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textColor,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              event.description!,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textColor.withOpacity(0.8),
                                height: 1.5,
                              ),
                            ),
                          ],

                          // Gift Suggestions
                          if (event.giftSuggestions != null &&
                              event.giftSuggestions!.isNotEmpty) ...[
                            SizedBox(height: 24),
                            Text(
                              "🎁 Gift Ideas",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textColor,
                              ),
                            ),
                            SizedBox(height: 12),

                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: event.giftSuggestions!.map((gift) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.primaryColor.withOpacity(
                                        0.3,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    gift,
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action Buttons
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  // Set Reminder Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _setReminder(context, event),
                      icon: Icon(Icons.notifications, size: 18),
                      label: Text("Set Reminder"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: AppColors.textColor,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),

                  // Shop Gifts Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _shopForGifts(context, event),
                      icon: Icon(Icons.shopping_bag, size: 18),
                      label: Text("Shop Gifts"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textColor.withOpacity(0.6)),
        SizedBox(width: 12),
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textColor.withOpacity(0.8),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 14, color: AppColors.textColor),
          ),
        ),
      ],
    );
  }

  Color _getEventColor(EventType type) {
    switch (type) {
      case EventType.festival:
        return Colors.orange;
      case EventType.birthday:
        return Colors.pink;
      case EventType.anniversary:
        return Colors.purple;
      case EventType.custom:
        return Colors.blue;
    }
  }

  String _getEventTypeName(EventType type) {
    switch (type) {
      case EventType.birthday:
        return 'Birthday';
      case EventType.anniversary:
        return 'Anniversary';
      case EventType.custom:
        return 'Custom Event';
      case EventType.festival:
        return 'Festival';
    }
  }

  void _setReminder(BuildContext context, Event event) {
    // Implement notification scheduling
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Reminder set for ${event.title}!')));
    Navigator.pop(context);
  }

  void _shopForGifts(BuildContext context, Event event) {
    // Navigate to gift shopping with event context
    Navigator.pop(context);
    Get.to(() => GiftShoppingScreen(event: event));
  }
}

// ======================== GIFT SHOPPING SCREEN ========================

class GiftShoppingScreen extends StatelessWidget {
  final Event event;

  const GiftShoppingScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gifts for ${event.title}'),
        backgroundColor: _getEventColor(event.type),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Event Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _getEventColor(event.type),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Icon(event.icon, color: Colors.white, size: 40),
                SizedBox(height: 8),
                Text(
                  event.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (event.subtitle.isNotEmpty)
                  Text(
                    event.subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
              ],
            ),
          ),

          // Gift Categories
          Expanded(
            child:
                event.giftSuggestions != null &&
                    event.giftSuggestions!.isNotEmpty
                ? ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: event.giftSuggestions!.length,
                    itemBuilder: (context, index) {
                      final giftCategory = event.giftSuggestions![index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Icon(
                            _getGiftCategoryIcon(giftCategory),
                            color: _getEventColor(event.type),
                          ),
                          title: Text(giftCategory),
                          subtitle: Text(
                            'Perfect for ${event.title.toLowerCase()}',
                          ),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Navigate to specific gift category
                            _navigateToGiftCategory(
                              context,
                              giftCategory,
                              event,
                            );
                          },
                        ),
                      );
                    },
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Browse All Gift Categories',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Color _getEventColor(EventType type) {
    switch (type) {
      case EventType.festival:
        return Colors.orange;
      case EventType.birthday:
        return Colors.pink;
      case EventType.anniversary:
        return Colors.purple;
      case EventType.custom:
        return Colors.blue;
    }
  }

  IconData _getGiftCategoryIcon(String category) {
    final categoryLower = category.toLowerCase();
    if (categoryLower.contains('jewelry') || categoryLower.contains('gold')) {
      return Icons.diamond;
    } else if (categoryLower.contains('sweet') ||
        categoryLower.contains('cake')) {
      return Icons.cake;
    } else if (categoryLower.contains('clothes') ||
        categoryLower.contains('saree')) {
      return Icons.shopping_bag;
    } else if (categoryLower.contains('flower')) {
      return Icons.local_florist;
    } else if (categoryLower.contains('book')) {
      return Icons.book;
    } else if (categoryLower.contains('electronic')) {
      return Icons.devices;
    }
    return Icons.card_giftcard;
  }

  void _navigateToGiftCategory(
    BuildContext context,
    String category,
    Event event,
  ) {
    // Navigate to your main gift category screen with filters
    // Example: Get.to(() => GiftCategoryScreen(category: category, event: event));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Opening $category gifts...')));
  }
}

// ======================== NOTIFICATIONS SERVICE ========================

class NotificationService {
  static Future<void> scheduleEventReminder(Event event) async {
    // Schedule notifications for 1 day before and day of event
    final oneDayBefore = event.date.subtract(Duration(days: 1));
    final eventDay = event.date;

    // Implementation with flutter_local_notifications
    // This is a placeholder - implement according to your notification setup
    print('Scheduling reminders for ${event.title}');
    print('Reminder 1: ${oneDayBefore}');
    print('Reminder 2: ${eventDay}');
  }

  static Future<void> cancelEventReminder(String eventId) async {
    // Cancel specific event notifications
    print('Cancelling reminders for event: $eventId');
  }
}

// ======================== GIFT PLANNING SERVICE ========================

class GiftPlanningService {
  static const String _planningKey = 'gift_planning';

  static Future<void> saveGiftPlan({
    required String eventId,
    required String giftCategory,
    required double budget,
    String? notes,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final plans = prefs.getStringList(_planningKey) ?? [];

    final plan = {
      'eventId': eventId,
      'giftCategory': giftCategory,
      'budget': budget,
      'notes': notes,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
    };

    plans.add(jsonEncode(plan));
    await prefs.setStringList(_planningKey, plans);
  }

  static Future<List<Map<String, dynamic>>> getGiftPlans() async {
    final prefs = await SharedPreferences.getInstance();
    final plans = prefs.getStringList(_planningKey) ?? [];

    return plans
        .map((plan) => jsonDecode(plan) as Map<String, dynamic>)
        .toList();
  }
}

// ======================== MAIN EVENTS SECTION ========================
class EventsSection extends StatefulWidget {
  @override
  _EventsSectionState createState() => _EventsSectionState();
}

class _EventsSectionState extends State<EventsSection> {
  List<Event> festivals = [];
  List<Event> userEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() async {
    setState(() => isLoading = true);

    try {
      final upcomingFestivals = EventsService.getUpcomingEvents(days: 30);
      final upcomingUserEvents = await EventsService.getUpcomingUserEvents(
        days: 30,
      );

      setState(() {
        festivals = upcomingFestivals;
        userEvents = upcomingUserEvents;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error loading events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    // Remove RefreshIndicator and SingleChildScrollView - sirf content return karo
    return Column(
      children: [
        // Quick Stats
        if (festivals.isNotEmpty || userEvents.isNotEmpty)
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${festivals.length}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Text(
                        'Festivals',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColors.primaryColor.withOpacity(0.3),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${userEvents.length}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Text(
                        'Family Events',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        // Upcoming Festivals
        ModernUpcomingEventsCard(
          title: "🎉 Upcoming Festivals",
          events: festivals,
          onSeeMore: () => Get.to(() => FestivalScreen()),
        ),

        // Family / User Events
        ModernUpcomingEventsCard(
          title: "👨‍👩‍👧‍👦 My Family Events",
          events: userEvents,
          onSeeMore: () => Get.to(() => UserEventsScreen()),
          onAddEvent: () => _showAddEventDialog(),
        ),
      ],
    );
  }

  void _showAddEventDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddEventBottomSheet(),
    ).then((_) => _loadEvents());
  }
}

// Festival Screen
class FestivalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final festivals = FestivalDataService.getIndianFestivals2024_2025();

    return Scaffold(
      appBar: AppBar(
        title: Text('All Festivals'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: festivals.length,
        itemBuilder: (context, index) {
          final event = festivals[index];
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: ModernEventRow(
              event: event,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => EventDetailsBottomSheet(event: event),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// User Events Screen
class UserEventsScreen extends StatefulWidget {
  @override
  _UserEventsScreenState createState() => _UserEventsScreenState();
}

class _UserEventsScreenState extends State<UserEventsScreen> {
  List<Event> userEvents = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserEvents();
  }

  void _loadUserEvents() async {
    setState(() => isLoading = true);
    try {
      final events = await UserEventStorage.getUserEvents();
      setState(() {
        userEvents = events;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error loading user events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Family Events'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => AddEventBottomSheet(),
              ).then((_) => _loadUserEvents());
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : userEvents.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                  SizedBox(height: 16),
                  Text(
                    'No family events added yet',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => AddEventBottomSheet(),
                      ).then((_) => _loadUserEvents());
                    },
                    icon: Icon(Icons.add),
                    label: Text('Add Event'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: userEvents.length,
              itemBuilder: (context, index) {
                final event = userEvents[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Dismissible(
                    key: Key(event.id),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) async {
                      await UserEventStorage.deleteUserEvent(event.id);
                      _loadUserEvents();
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Event deleted')));
                    },
                    child: ModernEventRow(
                      event: event,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) =>
                              EventDetailsBottomSheet(event: event),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: userEvents.isNotEmpty
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => AddEventBottomSheet(),
                ).then((_) => _loadUserEvents());
              },
              child: Icon(Icons.add),
              backgroundColor: AppColors.primaryColor,
            )
          : null,
    );
  }
}

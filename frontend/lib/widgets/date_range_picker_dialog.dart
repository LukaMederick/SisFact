import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';

class DateRangePickerPopup extends StatefulWidget {
  final AppState state;

  const DateRangePickerPopup({super.key, required this.state});

  @override
  State<DateRangePickerPopup> createState() => _DateRangePickerPopupState();
}

class _DateRangePickerPopupState extends State<DateRangePickerPopup> {
  late DateTime currentMonth;
  late DateTime selectedDay;
  late String activePreset;

  final List<String> presets = [
    'Hoy',
    'Ayer',
    'Últimos 7 días',
    'Últimos 30 días',
    'Este mes',
    'Mes anterior',
  ];

  @override
  void initState() {
    super.initState();
    selectedDay = widget.state.selectedDate;
    currentMonth = DateTime(selectedDay.year, selectedDay.month, 1);
    activePreset = widget.state.dateFilterLabel;
  }

  void _applyPreset(String preset) {
    final now = DateTime(2026, 8, 30); // Reference date matching system screenshot
    DateTime start;
    DateTime end;

    switch (preset) {
      case 'Hoy':
        start = DateTime(now.year, now.month, now.day, 0, 0, 0);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        selectedDay = now;
        break;
      case 'Ayer':
        final yesterday = now.subtract(const Duration(days: 1));
        start = DateTime(yesterday.year, yesterday.month, yesterday.day, 0, 0, 0);
        end = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
        selectedDay = yesterday;
        break;
      case 'Últimos 7 días':
        start = now.subtract(const Duration(days: 6));
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        selectedDay = now;
        break;
      case 'Últimos 30 días':
        start = now.subtract(const Duration(days: 29));
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        selectedDay = now;
        break;
      case 'Este mes':
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        selectedDay = now;
        break;
      case 'Mes anterior':
        start = DateTime(now.year, now.month - 1, 1);
        end = DateTime(now.year, now.month, 0, 23, 59, 59);
        selectedDay = start;
        break;
      default:
        start = now;
        end = now;
    }

    setState(() {
      activePreset = preset;
      currentMonth = DateTime(selectedDay.year, selectedDay.month, 1);
    });

    widget.state.setDateFilter(preset, start, end, specificDate: selectedDay);
    Navigator.of(context).pop();
  }

  void _selectSpecificDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day, 0, 0, 0);
    final end = DateTime(day.year, day.month, day.day, 23, 59, 59);

    setState(() {
      selectedDay = day;
      activePreset = 'Personalizado';
    });

    widget.state.setDateFilter('Personalizado', start, end, specificDate: day);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: 540,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Presets Column
              Container(
                width: 170,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: presets.map((p) {
                    final isSelected = activePreset == p;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: InkWell(
                        onTap: () => _applyPreset(p),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            p,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Right Calendar View
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Month Header with arrows
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left_rounded, size: 20),
                            onPressed: () {
                              setState(() {
                                currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
                              });
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          Text(
                            DateFormat('MMMM yyyy', 'es').format(currentMonth).capitalize(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right_rounded, size: 20),
                            onPressed: () {
                              setState(() {
                                currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
                              });
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Weekdays Header (Dom, Lun, Mar, Mié, Jue, Vie, Sáb)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'].map((day) {
                          return SizedBox(
                            width: 36,
                            child: Text(
                              day,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textMuted,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),

                      // Month Grid Days
                      _buildDaysGrid(isDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDaysGrid(bool isDark) {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final startingWeekday = firstDayOfMonth.weekday % 7; // 0 for Sunday

    final daysInPrevMonth = DateTime(currentMonth.year, currentMonth.month, 0).day;

    final List<Widget> dayWidgets = [];

    // Previous month trailing days
    for (int i = startingWeekday - 1; i >= 0; i--) {
      final dayNum = daysInPrevMonth - i;
      dayWidgets.add(
        Center(
          child: Text(
            '$dayNum',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textLight,
            ),
          ),
        ),
      );
    }

    // Current month days
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(currentMonth.year, currentMonth.month, day);
      final isSelected = selectedDay.year == date.year &&
          selectedDay.month == date.month &&
          selectedDay.day == date.day;

      dayWidgets.add(
        InkWell(
          onTap: () => _selectSpecificDay(date),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Next month leading days to complete grid rows
    final totalCells = dayWidgets.length;
    final remaining = (7 - (totalCells % 7)) % 7;
    for (int day = 1; day <= remaining; day++) {
      dayWidgets.add(
        Center(
          child: Text(
            '$day',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textLight,
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: dayWidgets,
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

import 'package:flutter/material.dart';
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
    DateTime sel = selectedDay;

    switch (preset) {
      case 'Hoy':
        start = DateTime(now.year, now.month, now.day, 0, 0, 0);
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        sel = now;
        break;
      case 'Ayer':
        final yesterday = now.subtract(const Duration(days: 1));
        start = DateTime(yesterday.year, yesterday.month, yesterday.day, 0, 0, 0);
        end = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
        sel = yesterday;
        break;
      case 'Últimos 7 días':
        start = now.subtract(const Duration(days: 6));
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        sel = now;
        break;
      case 'Últimos 30 días':
        start = now.subtract(const Duration(days: 29));
        end = DateTime(now.year, now.month, now.day, 23, 59, 59);
        sel = now;
        break;
      case 'Este mes':
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
        sel = now;
        break;
      case 'Mes anterior':
        start = DateTime(now.year, now.month - 1, 1);
        end = DateTime(now.year, now.month, 0, 23, 59, 59);
        sel = start;
        break;
      default:
        start = now;
        end = now;
        sel = now;
    }

    Navigator.of(context).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.state.setDateFilter(preset, start, end, specificDate: sel);
    });
  }

  void _selectSpecificDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day, 0, 0, 0);
    final end = DateTime(day.year, day.month, day.day, 23, 59, 59);

    Navigator.of(context).pop();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.state.setDateFilter('Personalizado', start, end, specificDate: day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Container(
        width: 530,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.16),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Presets Column
              Container(
                width: 165,
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
                      child: Material(
                        key: ValueKey('preset-mat-$p'),
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          key: ValueKey('preset-btn-$p'),
                          onTap: () => _applyPreset(p),
                          borderRadius: BorderRadius.circular(8),
                          hoverColor: isSelected
                              ? null
                              : (isDark
                                  ? Colors.white.withValues(alpha: 0.06)
                                  : Colors.black.withValues(alpha: 0.04)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                            key: const ValueKey('cal-prev-month'),
                            icon: const Icon(Icons.chevron_left_rounded, size: 22),
                            onPressed: () {
                              setState(() {
                                currentMonth = DateTime(currentMonth.year, currentMonth.month - 1, 1);
                              });
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          Text(
                            _formatMonthYear(currentMonth),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                            ),
                          ),
                          IconButton(
                            key: const ValueKey('cal-next-month'),
                            icon: const Icon(Icons.chevron_right_rounded, size: 22),
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
                      const SizedBox(height: 14),

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
                      const SizedBox(height: 8),

                      // Month Grid Days (6 rows x 7 columns matrix)
                      _buildDaysMatrix(isDark),
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

  Widget _buildDaysMatrix(bool isDark) {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
    final startingWeekday = firstDayOfMonth.weekday % 7; // 0 for Sunday
    final daysInPrevMonth = DateTime(currentMonth.year, currentMonth.month, 0).day;

    final List<Widget> allCells = [];

    // Previous month trailing days
    for (int i = startingWeekday - 1; i >= 0; i--) {
      final dayNum = daysInPrevMonth - i;
      allCells.add(
        _buildInactiveDayCell(
          key: ValueKey('prev-$i-$dayNum'),
          dayNum: dayNum,
          isDark: isDark,
        ),
      );
    }

    // Current month days
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(currentMonth.year, currentMonth.month, day);
      final isSelected = selectedDay.year == date.year &&
          selectedDay.month == date.month &&
          selectedDay.day == date.day;

      allCells.add(
        _buildActiveDayCell(
          key: ValueKey('curr-${date.year}-${date.month}-$day'),
          date: date,
          dayNum: day,
          isSelected: isSelected,
          isDark: isDark,
        ),
      );
    }

    // Next month leading days to complete full 42 cells (6 rows x 7 columns)
    int nextMonthDay = 1;
    while (allCells.length < 42) {
      final nextDayNum = nextMonthDay;
      allCells.add(
        _buildInactiveDayCell(
          key: ValueKey('next-$nextMonthDay'),
          dayNum: nextDayNum,
          isDark: isDark,
        ),
      );
      nextMonthDay++;
    }

    // Split into 6 rows of 7 columns
    final List<Widget> rows = [];
    for (int r = 0; r < 6; r++) {
      final rowCells = allCells.sublist(r * 7, (r + 1) * 7);
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: rowCells.map((cell) => Expanded(child: cell)).toList(),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows,
    );
  }

  Widget _buildActiveDayCell({
    required Key key,
    required DateTime date,
    required int dayNum,
    required bool isSelected,
    required bool isDark,
  }) {
    return Container(
      key: key,
      height: 36,
      margin: const EdgeInsets.all(2),
      child: Material(
        color: isSelected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          key: ValueKey('day-btn-${date.year}-${date.month}-$dayNum'),
          onTap: () => _selectSpecificDay(date),
          borderRadius: BorderRadius.circular(8),
          hoverColor: isSelected
              ? null
              : (isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : AppColors.primary.withValues(alpha: 0.08)),
          child: Center(
            child: Text(
              '$dayNum',
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInactiveDayCell({
    required Key key,
    required int dayNum,
    required bool isDark,
  }) {
    return Container(
      key: key,
      height: 36,
      margin: const EdgeInsets.all(2),
      child: Center(
        child: Text(
          '$dayNum',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }

  String _formatMonthYear(DateTime date) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

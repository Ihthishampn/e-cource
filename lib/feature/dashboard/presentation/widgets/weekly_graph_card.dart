import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class WeeklyGraphCard extends StatefulWidget {
  const WeeklyGraphCard({super.key});

  @override
  State<WeeklyGraphCard> createState() => _WeeklyGraphCardState();
}

class _WeeklyGraphCardState extends State<WeeklyGraphCard> {
  // Currently selected week range
  late DateTime _weekStart;
  late DateTime _weekEnd;

  @override
  void initState() {
    super.initState();
    // Default to current week (Friday to Thursday like reference)
    final now = DateTime.now();
    _weekStart = now.subtract(Duration(days: now.weekday % 7));
    _weekEnd = _weekStart.add(const Duration(days: 6));
  }

  String _formatDateRange() {
    final months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[_weekStart.month]} ${_weekStart.day} – ${_weekEnd.day}';
  }

  // Dummy spots — replace with real data keyed by week later
  final List<FlSpot> _spots = [
    const FlSpot(0, 0),
    const FlSpot(1, 0),
    const FlSpot(2, 0),
    const FlSpot(3, 3.2),
    const FlSpot(4, 3.2),
    const FlSpot(5, 0.2),
    const FlSpot(6, 1.2),
  ];

  final List<String> _days = ['Fri', 'Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu'];

  Future<void> _showWeekPicker() async {
    DateTime? pickedStart = _weekStart;
    DateTime? pickedEnd = _weekEnd;
    DateTime displayMonth = DateTime(_weekStart.year, _weekStart.month);

    await showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final daysInMonth =
                DateUtils.getDaysInMonth(displayMonth.year, displayMonth.month);
            final firstWeekday =
                DateTime(displayMonth.year, displayMonth.month, 1).weekday % 7;

            final monthNames = [
              '', 'January', 'February', 'March', 'April', 'May', 'June',
              'July', 'August', 'September', 'October', 'November', 'December'
            ];

            void selectWeekContaining(DateTime tapped) {
              // Find Monday of that week
              final monday =
                  tapped.subtract(Duration(days: (tapped.weekday - 1) % 7));
              final sunday = monday.add(const Duration(days: 6));
              setDialogState(() {
                pickedStart = monday;
                pickedEnd = sunday;
              });
            }

            bool isInSelectedRange(int day) {
              if (pickedStart == null || pickedEnd == null) return false;
              final date =
                  DateTime(displayMonth.year, displayMonth.month, day);
              return (date.isAtSameMomentAs(pickedStart!) ||
                      date.isAfter(pickedStart!)) &&
                  (date.isAtSameMomentAs(pickedEnd!) ||
                      date.isBefore(pickedEnd!));
            }

            bool isRangeStart(int day) {
              if (pickedStart == null) return false;
              final date =
                  DateTime(displayMonth.year, displayMonth.month, day);
              return date.year == pickedStart!.year &&
                  date.month == pickedStart!.month &&
                  date.day == pickedStart!.day;
            }

            bool isRangeEnd(int day) {
              if (pickedEnd == null) return false;
              final date =
                  DateTime(displayMonth.year, displayMonth.month, day);
              return date.year == pickedEnd!.year &&
                  date.month == pickedEnd!.month &&
                  date.day == pickedEnd!.day;
            }

            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: SizedBox(
                width: 340,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Text(
                        'Select Week',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Gap(16),
                      // Month navigator
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0EEFF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${monthNames[displayMonth.month]} ${displayMonth.year}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => setDialogState(() {
                                displayMonth = DateTime(displayMonth.year,
                                    displayMonth.month - 1);
                              }),
                              child: const Icon(Icons.chevron_left, size: 20),
                            ),
                            const Gap(8),
                            GestureDetector(
                              onTap: () => setDialogState(() {
                                displayMonth = DateTime(displayMonth.year,
                                    displayMonth.month + 1);
                              }),
                              child: const Icon(Icons.chevron_right, size: 20),
                            ),
                          ],
                        ),
                      ),
                      const Gap(16),
                      // Day-of-week headers
                      Row(
                        children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                            .map((d) => Expanded(
                                  child: Center(
                                    child: Text(
                                      d,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      const Gap(8),
                      // Calendar grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          childAspectRatio: 1,
                        ),
                        itemCount: firstWeekday + daysInMonth,
                        itemBuilder: (ctx, i) {
                          if (i < firstWeekday) return const SizedBox();
                          final day = i - firstWeekday + 1;
                          final inRange = isInSelectedRange(day);
                          final isStart = isRangeStart(day);
                          final isEnd = isRangeEnd(day);

                          return GestureDetector(
                            onTap: () => selectWeekContaining(DateTime(
                                displayMonth.year, displayMonth.month, day)),
                            child: Container(
                              margin: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: inRange && !isStart && !isEnd
                                    ? const Color(0xFFF3F0FF)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.horizontal(
                                  left: isStart
                                      ? const Radius.circular(50)
                                      : Radius.zero,
                                  right: isEnd
                                      ? const Radius.circular(50)
                                      : Radius.zero,
                                ),
                              ),
                              child: Center(
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (isStart || isEnd)
                                        ? Colors.blue
                                        : Colors.transparent,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$day',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: (isStart || isEnd)
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const Gap(20),
                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(ctx),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                              ),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const Gap(12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                setState(() {
                                  _weekStart = pickedStart!;
                                  _weekEnd = pickedEnd!;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Confirm',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.fromLTRB(16, 24, 24, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0x05000000),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Users',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              GestureDetector(
                onTap: _showWeekPicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _formatDateRange(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF616161),
                        ),
                      ),
                      const Gap(8),
                      const Icon(Icons.calendar_today_outlined,
                          size: 16, color: Color(0xFF757575)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Gap(24),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: Color(0xFFF5F5F5),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        if (value == value.roundToDouble()) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9E9E9E),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= _days.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            _days[idx],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9E9E9E),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 4,
                lineBarsData: [
                  LineChartBarData(
                    spots: _spots,
                    isCurved: true,
                    curveSmoothness: 0.4,
                    color: Colors.black87,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
              duration: Duration.zero,
            ),
          ),
        ],
      ),
    );
  }
}

/**
 * Tên file: practice_screen.dart
 * Tên tác giả: La Văn Thanh
 * Mô tả: Màn hình Tu Tập hiển thị Chuỗi ngày liên tục, Nhật ký tu tập và Sự kiện Lịch Phật giáo. [WEBVNZ.COM]
 */
library;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:remixicon/remixicon.dart';
import 'package:lunar/lunar.dart';
import '../../providers/practice_provider.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
  }

  // Hàm chuyển đổi sang tháng trước/sau
  void _changeMonth(int offset) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + offset,
        1,
      );
    });
  }

  // Kiểm tra 2 ngày có trùng nhau không
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Lấy danh sách sự kiện Phật giáo trong tháng hiện tại
  List<Map<String, dynamic>> _getBuddhistEvents() {
    List<Map<String, dynamic>> events = [];
    final daysInMonth = DateUtils.getDaysInMonth(
      _selectedMonth.year,
      _selectedMonth.month,
    );

    for (int day = 1; day <= daysInMonth; day++) {
      final solarDate = DateTime(
        _selectedMonth.year,
        _selectedMonth.month,
        day,
      );
      final lunar = Lunar.fromDate(solarDate);

      // Thêm các ngày rằm, mùng 1
      if (lunar.getDay() == 1 || lunar.getDay() == 15) {
        events.add({
          'solarDate': solarDate,
          'lunarDate': '${lunar.getDay()}/${lunar.getMonth()}',
          'title': lunar.getDay() == 1
              ? 'Ngày Sóc (Mùng 1)'
              : 'Ngày Vọng (Rằm)',
          'desc': 'Ngày trai giới, ăn chay niệm Phật.',
          'type': 'chay',
        });
      }

      // Có thể mở rộng thêm logic kiểm tra các ngày vía Phật tại đây
    }
    return events;
  }

  @override
  Widget build(BuildContext context) {
    final practiceProvider = Provider.of<PracticeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;
    final textColor = Theme.of(context).colorScheme.onSurface;

    final events = _getBuddhistEvents();

    return Scaffold(
      appBar: AppBar(title: const Text('Nhật Ký Tu Tập')),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thẻ hiển thị Chuỗi ngày liên tục (Streak)
              _buildStreakCard(
                context,
                practiceProvider.currentStreak,
                cardColor,
                textColor,
              ),

              const SizedBox(height: 24),
              Text(
                'Lịch Sử Tu Tập',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),

              // Lịch đánh dấu ngày đã tu tập
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.2 : 0.03,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header của Lịch
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Remix.arrow_left_s_line),
                          onPressed: () => _changeMonth(-1),
                        ),
                        Text(
                          'Tháng ${_selectedMonth.month}, ${_selectedMonth.year}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Remix.arrow_right_s_line),
                          onPressed: () => _changeMonth(1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildCalendarGrid(
                      context,
                      practiceProvider.practiceLogs,
                      textColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Text(
                'Sự Kiện Phật Giáo Tháng ${_selectedMonth.month}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),

              // Danh sách sự kiện
              events.isEmpty
                  ? Text(
                      'Không có sự kiện đặc biệt trong tháng này.',
                      style: TextStyle(color: Colors.grey.shade500),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        final solarDate = event['solarDate'] as DateTime;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border(
                              left: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 4.0,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '${solarDate.day}',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                  Text(
                                    event['lunarDate'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event['title'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      event['desc'],
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: isDark
                                            ? Colors.grey.shade400
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreakCard(
    BuildContext context,
    int streak,
    Color cardColor,
    Color textColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Icon(Remix.fire_fill, color: Colors.orange.shade400, size: 48),
              const SizedBox(height: 8),
              Text(
                'Liên tục',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                '$streak',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              Text(
                'Ngày',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(
    BuildContext context,
    List<DateTime> practiceLogs,
    Color textColor,
  ) {
    final daysInMonth = DateUtils.getDaysInMonth(
      _selectedMonth.year,
      _selectedMonth.month,
    );
    final firstDayOfMonth = DateTime(
      _selectedMonth.year,
      _selectedMonth.month,
      1,
    );

    // Ngày đầu tiên của tháng là thứ mấy (1: Thứ 2, 7: Chủ Nhật)
    final firstWeekday = firstDayOfMonth.weekday;

    List<Widget> dayWidgets = [];
    final List<String> weekDays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    // Header thứ
    for (var day in weekDays) {
      dayWidgets.add(
        Center(
          child: Text(
            day,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
              fontSize: 13,
            ),
          ),
        ),
      );
    }

    // Các ô trống trước mùng 1
    for (int i = 1; i < firstWeekday; i++) {
      dayWidgets.add(const SizedBox());
    }

    // Các ngày trong tháng
    for (int day = 1; day <= daysInMonth; day++) {
      final currentDate = DateTime(
        _selectedMonth.year,
        _selectedMonth.month,
        day,
      );
      final isPracticed = practiceLogs.any(
        (log) => _isSameDay(log, currentDate),
      );
      final isToday = _isSameDay(DateTime.now(), currentDate);

      dayWidgets.add(
        Center(
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPracticed
                  ? Theme.of(context).primaryColor
                  : (isToday
                        ? Colors.grey.withValues(alpha: 0.2)
                        : Colors.transparent),
              border: isToday && !isPracticed
                  ? Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1.5,
                    )
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              '$day',
              style: TextStyle(
                color: isPracticed ? Colors.white : textColor,
                fontWeight: isPracticed || isToday
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 7,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: dayWidgets,
    );
  }
}

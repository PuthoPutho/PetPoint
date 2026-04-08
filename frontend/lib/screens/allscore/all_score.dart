import 'package:flutter/material.dart';
import 'package:frontend/screens/quiz/quiz_detail_screen.dart';
import 'package:frontend/services/quiz_service.dart';
import 'package:frontend/providers/auth_provider.dart';
import '../../widgets/quiz_history_card.dart';

class AllScoreScreen extends StatefulWidget {
  const AllScoreScreen({Key? key}) : super(key: key);

  @override
  State<AllScoreScreen> createState() => _AllScoreScreenState();
}

class _AllScoreScreenState extends State<AllScoreScreen> {
  String selectedFilter = 'All';

  final List<String> filterOptions = [
    'All',
    'Vocab',
    'Grammar',
    'Meaning',
    'Sentence',
    'Reading',
  
  ];

  List<dynamic> _historyData = [];
  bool _isLoading = true;
  bool _isFirstLoad = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstLoad) {
      _isFirstLoad = false;
      _loadHistoryData();
    }
  }

  Future<void> _loadHistoryData() async {
    setState(() => _isLoading = true);
    try {
      final userId = AuthProvider.of(context).userId ?? '';
      if (userId.isNotEmpty) {
        final history = await QuizService.getUserQuizHistory(userId);
        setState(() {
          //  ตรวจสอบประเภทข้อมูลให้ชัวร์ว่าเป็น List
          if (history is List) {
            _historyData = history;
          } else {
            _historyData = [];
            print('⚠️ Warning: History data is not a list');
          }
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('❌ Error loading history: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<dynamic> get filteredData {
    if (selectedFilter == 'All') {
      return _historyData;
    }
    return _historyData.where((data) {
      final category = (data['category'] ?? '').toString().toLowerCase();
      final filter = selectedFilter.toLowerCase();
      return category.contains(filter);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayData = filteredData;
    final currentScore = AuthProvider.of(context).currentScore;

    return Scaffold(
      backgroundColor: Colors.white,
      body: DefaultTextStyle(
        style: const TextStyle(fontFamily: 'GoogleSans', color: Colors.black),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopScoreCard(currentScore),

                const SizedBox(height: 32),

                const Text(
                  'Quiz History',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'GoogleSans',
                  ),
                ),

                const SizedBox(height: 16),

                // Dropdown
                Theme(
                  data: Theme.of(context).copyWith(
                    popupMenuTheme: const PopupMenuThemeData(
                      menuPadding: EdgeInsets.zero,
                    ),
                  ),
                  child: PopupMenuButton<String>(
                    position: PopupMenuPosition.under,
                    offset: const Offset(0, 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    color: Colors.white,
                    elevation: 2,
                    clipBehavior: Clip.hardEdge,
                    constraints: const BoxConstraints(
                      minWidth: 160,
                      maxWidth: 160,
                    ),
                    onSelected: (String newValue) {
                      setState(() {
                        selectedFilter = newValue;
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return filterOptions.map((String value) {
                        final isFirst = value == filterOptions.first;
                        final isLast = value == filterOptions.last;

                        return PopupMenuItem<String>(
                          value: value,
                          padding: EdgeInsets.zero,
                          height: 44,
                          child: _HoverMenuItem(
                            value: value,
                            isFirst: isFirst,
                            isLast: isLast,
                          ),
                        );
                      }).toList();
                    },
                    child: Container(
                      width: 160,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              selectedFilter,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: Center(child: CircularProgressIndicator(color: Color(0xFF59AC77))),
                  )
                else if (displayData.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: Center(
                      child: Text(
                        'No history found.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'GoogleSans',
                        ),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayData.length,
                    itemBuilder: (context, index) {
                      final data = displayData[index];
                      String dateStr = "";
                      if (data['createdAt'] != null) {
                        try {
                          final dt = DateTime.parse(data['createdAt'].toString());
                          dateStr = "${dt.day}/${dt.month}/${dt.year}";
                        } catch(_) {}
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: QuizHistoryCard(
                          title: data['quizTitle'] ?? 'No Title',
                          subtitle: "${data['category'] ?? 'General'} • $dateStr",
                          score: "Score: ${data['score'] ?? 0}",
                          points: "Done",
                          imagePath: data['quizImage'] ?? "",
                          onTap: () async {
                            final userId = AuthProvider.of(context).userId ?? '';
                            if (userId.isEmpty) return;

                            // 1. โชว์ Loading นิดนึงก่อนไปหน้าถัดไป (กันค้าง)
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (ctx) => const Center(child: CircularProgressIndicator(color: Color(0xFF59AC77))),
                            );

                            try {
                              // 2. ดึงข้อมูลควิซแบบละเอียด (พร้อมสถานะ isCompleted)
                              final fullQuiz = await QuizService.getQuizDetails(
                                data['quizId']?.toString() ?? '',
                                userId: userId
                              );

                              if (!mounted) return;
                              Navigator.pop(context); // ปิด Loading

                              // 3. พาไปหน้า Quiz Detail
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuizDetailScreen(quizData: fullQuiz),
                                ),
                              );
                            } catch (e) {
                              if (!mounted) return;
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopScoreCard(int currentScore) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'All Score',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Image.asset(
            'assets/trophy.png',
            height: 120,
            width: 80,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 32),
          _buildPointRow(
            title: 'Your Score :',
            value: '$currentScore',
            unit: 'Points',
            backgroundColor: const Color(0xFFFFCCDE),
          ),
          const SizedBox(height: 12),
          _buildPointRow(
            title: 'Your Donated :',
            value: '${AuthProvider.of(context).donatedScore}',
            unit: 'Points',
            backgroundColor: const Color(0xFFFFE97E),
          ),
        ],
      ),
    );
  }

  Widget _buildPointRow({
    required String title,
    required String value,
    required String unit,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              unit,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class _HoverMenuItem extends StatefulWidget {
  final String value;
  final bool isFirst;
  final bool isLast;

  const _HoverMenuItem({
    Key? key,
    required this.value,
    required this.isFirst,
    required this.isLast,
  }) : super(key: key);

  @override
  State<_HoverMenuItem> createState() => _HoverMenuItemState();
}

class _HoverMenuItemState extends State<_HoverMenuItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isHovered ? const Color(0xFFE8F5E9) : Colors.transparent,
          borderRadius: BorderRadius.vertical(
            top: widget.isFirst ? const Radius.circular(16) : Radius.zero,
            bottom: widget.isLast ? const Radius.circular(16) : Radius.zero,
          ),
          border: Border(
            bottom: BorderSide(
              color: widget.isLast ? Colors.transparent : Colors.grey.shade100,
            ),
          ),
        ),
        child: Text(
          widget.value,
          style: TextStyle(
            color: isHovered ? Colors.black87 : Colors.grey.shade600,
            fontSize: 14,
            fontFamily: 'GoogleSans',
          ),
        ),
      ),
    );
  }
}

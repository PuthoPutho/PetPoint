import 'package:flutter/material.dart';
import 'package:frontend/models/quiz.dart';
import 'package:frontend/screens/quiz/quiz_detail_screen.dart';
import 'package:frontend/services/mock_quiz_service.dart';

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
    'Conversation',
    'Meaning',
    'Sentence',
  ];

  final List<Map<String, String>> quizHistoryData = const [
    {
      'title': 'Vocabulary   A1',
      'subtitle': 'Part 1',
      'score': '8/10',
      'points': '10 Points',
      'imagePath': 'assets/vocab_a1_part1.png',
    },
    {
      'title': 'Grammar   B1',
      'subtitle': 'Part 2',
      'score': '9/10',
      'points': '15 Points',
      'imagePath': 'assets/vocab_a1_part1.png',
    },
  ];

  List<Map<String, String>> get filteredData {
    if (selectedFilter == 'All') {
      return quizHistoryData;
    }
    return quizHistoryData.where((data) {
      final title = (data['title'] ?? '').toLowerCase();
      final subtitle = (data['subtitle'] ?? '').toLowerCase();
      final filter = selectedFilter.toLowerCase();

      if (filter == 'vocab' && title.contains('vocabulary')) return true;
      return title.contains(filter) || subtitle.contains(filter);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayData = MockQuizService.getMockQuizzes();

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
                _buildTopScoreCard(),

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

                //end
                const SizedBox(height: 20),

                if (displayData.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: Text(
                        'No history found for this category.',
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
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: QuizHistoryCard(
                          title: data.title,
                          subtitle: data.category,
                          score: "0",
                          points: "0",
                          imagePath: "assets/vocab_a1_part1.png",
                          //onTap
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuizDetailScreen(
                                  quizData: Quiz(
                                    uuid: data.uuid,
                                    title: data.title,
                                    description: data.description,
                                    category: data.category,
                                    points: data.points,
                                    duration: data.duration,
                                    questionCount: data.questionCount,
                                    level: data.level,
                                    tag: data.tag,
                                    createdAt: DateTime.now(),
                                  ),
                                ),
                              ),
                            );
                          },
                          // -----------------------------------------------------------
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

  Widget _buildTopScoreCard() {
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
            title: 'Your Balance :',
            value: '73',
            unit: 'Points',
            backgroundColor: const Color(0xFFFFCCDE),
          ),
          const SizedBox(height: 12),
          _buildPointRow(
            title: 'Your Donated :',
            value: '1000',
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

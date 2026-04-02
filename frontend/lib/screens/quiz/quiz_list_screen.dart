import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../services/mock_quiz_service.dart';
import '../../widgets/quiz_card.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({super.key});

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  bool _isCategoryExpanded = false;
  bool _isTimeFilterExpanded = false;
  
  final List<String> categories = [
    'All Category',
    'Vocabulary',
    'Grammar',
    'Reading',
    'Conversation',
    'Sentence',
  ];
  String selectedCategory = 'All Category';

  final List<String> timeFilters = [
    'All time',
    'Last week',
    'Last month',
    'Last year',
  ];
  String selectedTimeFilter = 'All time';
  String searchQuery = '';


  @override
  Widget build(BuildContext context) {
    // โหลดข้อมูลจำลองและฟิลเตอร์ตามหมวดหมู่ที่เลือก
    final allQuizzes = MockQuizService.getMockQuizzes();
    
    final quizzes = allQuizzes.where((quiz) {
      final matchesCategory = 
          selectedCategory == 'All Category' || quiz.category == selectedCategory;
      
      final now = DateTime.now();
      final difference = now.difference(quiz.createdAt);
      
      bool matchesTime = true;
      if (selectedTimeFilter == 'Last week') {
        matchesTime = difference.inDays <= 7;
      } else if (selectedTimeFilter == 'Last month') {
        matchesTime = difference.inDays <= 30;
      } else if (selectedTimeFilter == 'Last year') {
        matchesTime = difference.inDays <= 365;
      }
      
      bool matchesSearch = true;
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        matchesSearch = quiz.title.toLowerCase().contains(query) ||
                        quiz.category.toLowerCase().contains(query) ||
                        quiz.tag.toLowerCase().contains(query);
      }
      
      return matchesCategory && matchesTime && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white, 
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
          children: [
            const SizedBox(height: 18),
            // 1. ช่องค้นหา (Search Bar)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(fontFamily: 'GoogleSans', color: Colors.grey),
                  suffixIcon: const Icon(LucideIcons.search, color: Colors.grey), // ไอคอนอยู่ขวา
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. ดรอปดาวน์ฟิลเตอร์ (หมวดหมู่ และ Last month)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isCategoryExpanded = !_isCategoryExpanded;
                        if (_isCategoryExpanded) _isTimeFilterExpanded = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              selectedCategory,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontFamily: 'GoogleSans', color: Colors.grey),
                            ),
                          ),
                          Icon(_isCategoryExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown, color: Colors.grey, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isTimeFilterExpanded = !_isTimeFilterExpanded;
                        if (_isTimeFilterExpanded) _isCategoryExpanded = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.withOpacity(0.1)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              selectedTimeFilter,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontFamily: 'GoogleSans', color: Colors.grey),
                            ),
                          ),
                          Icon(_isTimeFilterExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown, color: Colors.grey, size: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 3. รายการการ์ดแบบเลื่อนได้ (และลอยทับเมนู)
            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    itemCount: quizzes.length,
                    itemBuilder: (context, index) {
                      return QuizCard(quizData: quizzes[index]);
                    },
                  ),
                  
                  // เลเยอร์จับการกดพื้นหลังเพื่อปิดเมนู
                  if (_isCategoryExpanded || _isTimeFilterExpanded)
                    Positioned.fill(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            _isCategoryExpanded = false;
                            _isTimeFilterExpanded = false;
                          });
                        },
                      ),
                    ),

                  // เลเยอร์เมนูแบบลอยทับ
                  if (_isCategoryExpanded || _isTimeFilterExpanded)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _isCategoryExpanded
                                ? _buildCustomMenu(categories, selectedCategory, (val) {
                                    setState(() {
                                      selectedCategory = val;
                                      _isCategoryExpanded = false;
                                    });
                                  })
                                : const SizedBox.shrink(),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _isTimeFilterExpanded
                                ? _buildCustomMenu(timeFilters, selectedTimeFilter, (val) {
                                    setState(() {
                                      selectedTimeFilter = val;
                                      _isTimeFilterExpanded = false;
                                    });
                                  })
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildCustomMenu(List<String> items, String selectedValue, Function(String) onSelect) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: items.map((item) {
            final isSelected = item == selectedValue;
            return InkWell(
              onTap: () => onSelect(item),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                color: isSelected ? const Color(0xFFF0FDF4) : Colors.transparent, // เขียวเป๊ะถึงขอบ
                child: Text(
                  item,
                  style: TextStyle(
                    fontFamily: 'GoogleSans',
                    color: Colors.grey.shade700,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
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
      backgroundColor: const Color(0xFFFBFBFB), // สีพื้นหลังเทาอ่อนมากๆ เสมือนขาว
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
          children: [
            const SizedBox(height: 18),
            // 1. ช่องค้นหา (Search Bar)
            TextField(
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
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 2. ดรอปดาวน์ฟิลเตอร์ (หมวดหมู่ และ Last month)
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedCategory,
                        isExpanded: true,
                        icon: const Icon(LucideIcons.chevronDown, color: Colors.grey),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        elevation: 2,
                        selectedItemBuilder: (BuildContext context) {
                          return categories.map<Widget>((String item) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item,
                                style: const TextStyle(fontFamily: 'GoogleSans', color: Colors.grey),
                              ),
                            );
                          }).toList();
                        },
                        items: categories.map((String category) {
                          final isSelected = category == selectedCategory;
                          return DropdownMenuItem<String>(
                            value: category,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  category,
                                  style: TextStyle(fontFamily: 'GoogleSans', 
                                    color: isSelected ? Colors.black87 : Colors.grey.shade700,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(LucideIcons.check, size: 18, color: Colors.black87),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedCategory = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedTimeFilter,
                        isExpanded: true,
                        icon: const Icon(LucideIcons.chevronDown, color: Colors.grey),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        elevation: 2,
                        selectedItemBuilder: (BuildContext context) {
                          return timeFilters.map<Widget>((String item) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item,
                                style: const TextStyle(fontFamily: 'GoogleSans', color: Colors.grey),
                              ),
                            );
                          }).toList();
                        },
                        items: timeFilters.map((String filter) {
                          final isSelected = filter == selectedTimeFilter;
                          return DropdownMenuItem<String>(
                            value: filter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  filter,
                                  style: TextStyle(fontFamily: 'GoogleSans', 
                                    color: isSelected ? Colors.black87 : Colors.grey.shade700,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(LucideIcons.check, size: 18, color: Colors.black87),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedTimeFilter = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 3. รายการการ์ดแบบเลื่อนได้ (List of Cards)
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: quizzes.length,
                itemBuilder: (context, index) {
                  // เรียกใช้เลโก้ QuizCard ที่เราสร้างไว้
                  return QuizCard(quizData: quizzes[index]);
                },
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

}
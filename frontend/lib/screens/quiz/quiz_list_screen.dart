import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/quiz.dart';
import '../../services/quiz_service.dart';
import '../../widgets/quiz_card.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({super.key});

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  // สถานะการโหลดและข้อมูล
  List<Quiz> allQuizzes = [];
  bool isLoading = true;
  String? errorMessage;

  // สถานะ UI สำหรับเมนู Dropdown แบบลอย
  bool _isCategoryExpanded = false;
  bool _isTimeFilterExpanded = false;

  // ตัวเลือกฟิลเตอร์
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
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  // ฟังก์ชันโหลดข้อมูลจาก Backend
  Future<void> _loadQuizzes() async {
    try {
      final quizzes = await QuizService.getAllQuizzes();
      setState(() {
        allQuizzes = quizzes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'ไม่สามารถโหลดข้อมูลได้: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🌟 ส่วนลอจิกการกรอง (Filter Logic)
    final filteredQuizzes = allQuizzes.where((quiz) {
      // 1. กรองตามหมวดหมู่
      final matchesCategory =
          selectedCategory == 'All Category' || quiz.category == selectedCategory;

      // 2. กรองตามเวลา (ที่เพิ่งแก้ไป)
      bool matchesTime = true;
      
      if (quiz.createdAt != null) {
        final now = DateTime.now();
        final difference = now.difference(quiz.createdAt!);

        if (selectedTimeFilter == 'Last week') {
          matchesTime = difference.inDays <= 7;
        } else if (selectedTimeFilter == 'Last month') {
          matchesTime = difference.inDays <= 30;
        } else if (selectedTimeFilter == 'Last year') {
          matchesTime = difference.inDays <= 365;
        }
      }

      

      // 3. กรองตามการค้นหา
      bool matchesSearch = true;
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        matchesSearch = quiz.title.toLowerCase().contains(query) ||
            quiz.category.toLowerCase().contains(query) ||
            (quiz.tag != null && quiz.tag!.toLowerCase().contains(query));
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
              // --- 1. Search Bar ---
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
                  onChanged: (value) => setState(() => searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: const Icon(LucideIcons.search, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // --- 2. Filter Bar ---
              Row(
                children: [
                  _buildFilterButton(
                    label: selectedCategory,
                    isExpanded: _isCategoryExpanded,
                    onTap: () => setState(() {
                      _isCategoryExpanded = !_isCategoryExpanded;
                      _isTimeFilterExpanded = false;
                    }),
                  ),
                  const SizedBox(width: 16),
                  _buildFilterButton(
                    label: selectedTimeFilter,
                    isExpanded: _isTimeFilterExpanded,
                    onTap: () => setState(() {
                      _isTimeFilterExpanded = !_isTimeFilterExpanded;
                      _isCategoryExpanded = false;
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // --- 3. Content Area (ที่แก้ Error) ---
              Expanded(
                child: Stack(
                  children: [
                    // ส่วนแสดงรายการ
                    _buildMainContent(filteredQuizzes),

                    // เลเยอร์พื้นหลังเมื่อเปิดเมนู (คลิกเพื่อปิด)
                    if (_isCategoryExpanded || _isTimeFilterExpanded)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => setState(() {
                          _isCategoryExpanded = false;
                          _isTimeFilterExpanded = false;
                        }),
                        child: Container(color: Colors.transparent),
                      ),

                    // เมนูแบบลอย
                    if (_isCategoryExpanded)
                      Positioned(
                        top: 0, left: 0, width: (MediaQuery.of(context).size.width - 48) / 2,
                        child: _buildFloatingMenu(categories, selectedCategory, (val) {
                          setState(() { selectedCategory = val; _isCategoryExpanded = false; });
                        }),
                      ),
                    if (_isTimeFilterExpanded)
                      Positioned(
                        top: 0, right: 0, width: (MediaQuery.of(context).size.width - 48) / 2,
                        child: _buildFloatingMenu(timeFilters, selectedTimeFilter, (val) {
                          setState(() { selectedTimeFilter = val; _isTimeFilterExpanded = false; });
                        }),
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

  // แยกส่วนการแสดงผลหลักออกมาเพื่อความสะอาดของโค้ด
  Widget _buildMainContent(List<Quiz> filteredList) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.green));
    }
    if (errorMessage != null) {
      return Center(child: Text(errorMessage!, style: const TextStyle(color: Colors.red)));
    }
    if (filteredList.isEmpty) {
      return const Center(child: Text('No quizzes found', style: TextStyle(color: Colors.grey)));
    }
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      itemCount: filteredList.length,
      itemBuilder: (context, index) => QuizCard(quizData: filteredList[index]),
    );
  }

  // วิดเจ็ตปุ่มฟิลเตอร์
  Widget _buildFilterButton({required String label, required bool isExpanded, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4))],
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey))),
              Icon(isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  // วิดเจ็ตเมนูแบบลอย
  Widget _buildFloatingMenu(List<String> items, String selectedValue, Function(String) onSelect) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4))],
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
                color: isSelected ? const Color(0xFFF0FDF4) : Colors.transparent,
                child: Text(item, style: TextStyle(color: Colors.grey.shade700)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import '../models/quote.dart';
import '../models/philosopher.dart';
import '../services/database_service.dart';
import '../utils/constants.dart';
import 'deep_dive_screen.dart';
import 'philosopher_profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Quote> _allQuotes = [];
  List<Philosopher> _allPhilosophers = [];
  List<Quote> _filteredQuotes = [];
  List<Philosopher> _filteredPhilosophers = [];
  String? _selectedCategory;
  bool _isLoading = true;

  final List<String> _categories = [
    'All',
    'Ancient Philosophy',
    'Stoicism',
    'Existentialism',
    'Eastern Philosophy',
    'Modern Philosophy',
    'Enlightenment',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadData() async {
    final quotes = await DatabaseService.instance.getAllQuotes();
    final philosophers = await DatabaseService.instance.getAllPhilosophers();
    
    setState(() {
      _allQuotes = quotes;
      _allPhilosophers = philosophers;
      _filteredQuotes = quotes;
      _filteredPhilosophers = philosophers;
      _isLoading = false;
    });
  }

  void _onSearchChanged() {
    _filterResults();
  }

  void _filterResults() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      // Filter quotes
      _filteredQuotes = _allQuotes.where((quote) {
        final matchesSearch = query.isEmpty ||
            quote.text.toLowerCase().contains(query) ||
            quote.author.toLowerCase().contains(query);
        
        final matchesCategory = _selectedCategory == null ||
            _selectedCategory == 'All' ||
            quote.category == _selectedCategory;
        
        return matchesSearch && matchesCategory;
      }).toList();

      // Filter philosophers
      _filteredPhilosophers = _allPhilosophers.where((philosopher) {
        final matchesSearch = query.isEmpty ||
            philosopher.name.toLowerCase().contains(query) ||
            philosopher.school.toLowerCase().contains(query);
            
        final matchesCategory = _selectedCategory == null ||
            _selectedCategory == 'All'; 
            
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Search', style: AppTextStyles.heading3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : Column(
                    children: [
                      // Search bar
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: AppShadows.light,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: AppTextStyles.body,
                            decoration: InputDecoration(
                              hintText: 'Search quotes or philosophers...',
                              hintStyle: AppTextStyles.caption.copyWith(fontSize: 14),
                              prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, color: AppColors.textLight),
                                      onPressed: () {
                                        _searchController.clear();
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: AppColors.surface,
                              contentPadding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.2, end: 0),

                      // Category filter
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            final isSelected = _selectedCategory == category ||
                                (_selectedCategory == null && category == 'All');

                            return Padding(
                              padding: const EdgeInsets.only(right: AppSpacing.sm),
                              child: AnimatedContainer(
                                duration: 300.ms,
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary : AppColors.surface,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected ? AppColors.primary : AppColors.textLight.withOpacity(0.3),
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedCategory = category == 'All' ? null : category;
                                      _filterResults();
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    child: Center(
                                      child: Text(
                                        category,
                                        style: AppTextStyles.caption.copyWith(
                                          color: isSelected ? Colors.white : AppColors.textPrimary,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ).animate().fadeIn(delay: (300 + (index * 50)).ms).slideX();
                          },
                        ),
                      ),

                      const SizedBox(height: AppSpacing.md),

                      // Results
                      Expanded(
                        child: _filteredQuotes.isEmpty && _filteredPhilosophers.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.spa_outlined,
                                      size: 80,
                                      color: AppColors.textLight.withOpacity(0.3),
                                    ),
                                    const SizedBox(height: AppSpacing.md),
                                    Text(
                                      'No results in the garden',
                                      style: AppTextStyles.heading3.copyWith(
                                        color: AppColors.textLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ).animate().fadeIn()
                            : ListView(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(AppSpacing.md),
                                children: [
                                  // Philosophers section
                                  if (_filteredPhilosophers.isNotEmpty) ...[
                                    Text(
                                      'Philosophers (${_filteredPhilosophers.length})',
                                      style: AppTextStyles.heading3,
                                    ).animate().fadeIn(),
                                    const SizedBox(height: AppSpacing.md),
                                    ..._filteredPhilosophers.map((philosopher) =>
                                        _buildPhilosopherCard(philosopher)),
                                    const SizedBox(height: AppSpacing.lg),
                                  ],

                                  // Quotes section
                                  if (_filteredQuotes.isNotEmpty) ...[
                                    Text(
                                      'Quotes (${_filteredQuotes.length})',
                                      style: AppTextStyles.heading3,
                                    ).animate().fadeIn(),
                                    const SizedBox(height: AppSpacing.md),
                                    ..._filteredQuotes.map((quote) => _buildQuoteCard(quote)),
                                  ],
                                ],
                              ),
                      ),
                    ],
                  ),
          ),
    );
  }

  Widget _buildPhilosopherCard(Philosopher philosopher) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.light,
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: AppColors.primary),
          ),
          title: Text(philosopher.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
          subtitle: Text('${philosopher.school} • ${philosopher.era}', style: AppTextStyles.caption),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textLight),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhilosopherProfileScreen(philosopher: philosopher),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuoteCard(Quote quote) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.light,
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeepDiveScreen(quote: quote),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quote.text,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Text(
                      '— ${quote.author}',
                      style: AppTextStyles.caption.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        quote.category,
                        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

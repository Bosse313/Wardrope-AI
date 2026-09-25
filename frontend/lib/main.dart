import 'package:flutter/material.dart';
import 'api_service.dart';
import 'models.dart';

void main() {
  runApp(const WardrobeAIApp());
}

class WardrobeAIApp extends StatelessWidget {
  const WardrobeAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wardrobe AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const WardrobeHome(),
    );
  }
}

class WardrobeHome extends StatefulWidget {
  const WardrobeHome({super.key});

  @override
  State<WardrobeHome> createState() => _WardrobeHomeState();
}

class _WardrobeHomeState extends State<WardrobeHome> {
  int _selectedIndex = 0;
  String _selectedCategory = 'Alle';
  List<WardrobeItem> _items = [];
  List<OutfitSuggestion> _outfits = [];
  bool _loading = true;

  final List<String> _categories = [
    'Alle',
    'T-Shirt',
    'Polo',
    'Hemd',
    'Hose',
    'Jeans',
    'Jacke',
    'Pullover',
    'Schuhe',
    'Accessoire',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);

    try {
      final wardrobeData = await ApiService.getWardrobe();
      final outfitData = await ApiService.generateOutfits();

      setState(() {
        _items = wardrobeData.map((json) => WardrobeItem.fromJson(json)).toList();
        _outfits = outfitData.map((json) => OutfitSuggestion.fromJson(json)).toList();
      });
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _addItemDialog() async {
    final nameController = TextEditingController();
    String category = 'T-Shirt';
    String color = 'Weiß';
    String style = 'Casual';

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Neue Kleidung hinzufügen'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: category,
                    items: const [
                      'T-Shirt',
                      'Polo',
                      'Hemd',
                      'Hose',
                      'Jeans',
                      'Jacke',
                      'Pullover',
                      'Schuhe',
                    ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
                    onChanged: (v) => setDialogState(() => category = v ?? 'T-Shirt'),
                    decoration: const InputDecoration(labelText: 'Kategorie'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: color,
                    items: const ['Weiß', 'Schwarz', 'Blau', 'Marine', 'Beige', 'Grau']
                        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                        .toList(),
                    onChanged: (v) => setDialogState(() => color = v ?? 'Weiß'),
                    decoration: const InputDecoration(labelText: 'Farbe'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: style,
                    items: const ['Casual', 'Smart Casual', 'Sportlich', 'Elegant']
                        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                        .toList(),
                    onChanged: (v) => setDialogState(() => style = v ?? 'Casual'),
                    decoration: const InputDecoration(labelText: 'Stil'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Abbrechen'),
                ),
                FilledButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;

                    await ApiService.createItem({
                      'name': name,
                      'category': category,
                      'color': color,
                      'style': style,
                      'status': 'clean',
                    });

                    Navigator.pop(context);
                    _loadData();
                  },
                  child: const Text('Speichern'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _setStatus(int itemId, String status) async {
    await ApiService.updateStatus(itemId, status);
    _loadData();
  }

  List<WardrobeItem> get filteredItems {
    if (_selectedCategory == 'Alle') return _items;
    return _items.where((item) => item.category == _selectedCategory).toList();
  }

  List<WardrobeItem> get cleanItems =>
      _items.where((item) => item.status == 'clean').toList();

  List<WardrobeItem> get washItems =>
      _items.where((item) => item.status == 'in_wash').toList();

  Widget _buildHomeTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),
        const Text(
          'Willkommen zurück',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _statCard('Gesamt', '${_items.length}'),
            _statCard('Sauber', '${cleanItems.length}'),
            _statCard('Wäsche', '${washItems.length}'),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Empfohlene Outfits',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ..._outfits.map((outfit) => OutfitCard(outfit: outfit)),
      ],
    );
  }

  Widget _buildWardrobeTab() {
    return Column(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.map((category) {
              final selected = _selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedCategory = category),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredItems.length,
            itemBuilder: (context, index) {
              final item = filteredItems[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text('${item.category} • ${item.color} • ${item.status}'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (status) => _setStatus(item.id, status),
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'clean', child: Text('Sauber')),
                      PopupMenuItem(value: 'worn', child: Text('Getragen')),
                      PopupMenuItem(value: 'in_wash', child: Text('In der Wäsche')),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLaundryTab() {
    final laundryItems = _items.where((item) => item.status == 'in_wash').toList();

    if (laundryItems.isEmpty) {
      return const Center(child: Text('Keine Kleidungsstücke in der Wäsche'));
    }

    return ListView.builder(
      itemCount: laundryItems.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final item = laundryItems[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(item.name),
            subtitle: Text(item.category),
            trailing: FilledButton(
              onPressed: () => _setStatus(item.id, 'clean'),
              child: const Text('Wieder verfügbar'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOutfitTab() {
    if (_outfits.isEmpty) {
      return const Center(child: Text('Keine Outfit-Vorschläge verfügbar'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: _outfits.map((o) => OutfitCard(outfit: o)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeTab(),
      _buildWardrobeTab(),
      _buildOutfitTab(),
      _buildLaundryTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wardrobe AI'),
        actions: [
          IconButton(
            onPressed: _addItemDialog,
            icon: const Icon(Icons.add_circle),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Start'),
          NavigationDestination(icon: Icon(Icons.inventory_2_outlined), label: 'Schrank'),
          NavigationDestination(icon: Icon(Icons.checkroom_outlined), label: 'Outfits'),
          NavigationDestination(icon: Icon(Icons.local_laundry_service_outlined), label: 'Wäsche'),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value) {
    return SizedBox(
      width: 120,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Text(title),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OutfitCard extends StatelessWidget {
  final OutfitSuggestion outfit;

  const OutfitCard({super.key, required this.outfit});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    outfit.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${(outfit.score * 100).round()}%',
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(outfit.reason),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('Top')),
                Chip(label: Text('Hose')),
                Chip(label: Text('Schuhe')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

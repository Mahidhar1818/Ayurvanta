// lib/screens/doctor/create_diet_plan_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/diet_plan/diet_plan_bloc.dart';
import '../../models/exercise_model.dart';

class CreateDietPlanScreen extends StatefulWidget {
  final String patientId;
  final String patientName;
  final String disease;

  const CreateDietPlanScreen({
    Key? key,
    required this.patientId,
    required this.patientName,
    required this.disease,
  }) : super(key: key);

  @override
  _CreateDietPlanScreenState createState() => _CreateDietPlanScreenState();
}

class _CreateDietPlanScreenState extends State<CreateDietPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _startDate;
  late DateTime _endDate;
  final List<Meal> _meals = [];
  final List<String> _foodsToEat = [];
  final List<String> _foodsToAvoid = [];
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _hydrationController = TextEditingController();
  final TextEditingController _foodToEatController = TextEditingController();
  final TextEditingController _foodToAvoidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = DateTime.now().add(Duration(days: 7));
    _initializeMeals();
  }

  void _initializeMeals() {
    _meals.addAll([
      Meal(
        type: 'Breakfast',
        time: '8:00 AM',
        items: [],
        notes: '',
      ),
      Meal(
        type: 'Morning Snack',
        time: '11:00 AM',
        items: [],
        notes: '',
      ),
      Meal(
        type: 'Lunch',
        time: '1:00 PM',
        items: [],
        notes: '',
      ),
      Meal(
        type: 'Evening Snack',
        time: '4:00 PM',
        items: [],
        notes: '',
      ),
      Meal(
        type: 'Dinner',
        time: '7:00 PM',
        items: [],
        notes: '',
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Diet Plan for \${widget.patientName}'),
        backgroundColor: Colors.green,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Disease: \${widget.disease}',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildDateRangeCard(),
            SizedBox(height: 16),
            _buildFoodsToEatCard(),
            SizedBox(height: 16),
            _buildFoodsToAvoidCard(),
            SizedBox(height: 16),
            _buildMealsCard(),
            SizedBox(height: 16),
            _buildInstructionsCard(),
            SizedBox(height: 16),
            _buildHydrationCard(),
            SizedBox(height: 24),
            _buildCreateButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plan Duration',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Start Date'),
              subtitle: Text(_formatDate(_startDate)),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(true),
            ),
            ListTile(
              title: Text('End Date'),
              subtitle: Text(_formatDate(_endDate)),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _selectDate(false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodsToEatCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Foods to Eat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _foodsToEat.map((food) {
                return Chip(
                  label: Text(food),
                  onDeleted: () {
                    setState(() {
                      _foodsToEat.remove(food);
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _foodToEatController,
                    decoration: InputDecoration(
                      hintText: 'Add food item...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.green),
                  onPressed: _addFoodToEat,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodsToAvoidCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Foods to Avoid',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _foodsToAvoid.map((food) {
                return Chip(
                  label: Text(food),
                  onDeleted: () {
                    setState(() {
                      _foodsToAvoid.remove(food);
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _foodToAvoidController,
                    decoration: InputDecoration(
                      hintText: 'Add food to avoid...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.add_circle, color: Colors.red),
                  onPressed: _addFoodToAvoid,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealsCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meal Plan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ..._meals.asMap().entries.map((entry) {
              return _buildMealCard(entry.value, entry.key);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard(Meal meal, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        title: Text(
          '\${meal.type} (\${meal.time})',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                ...meal.items.map((item) {
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('\${item.quantity} - \${item.calories} cal'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          meal.items.remove(item);
                        });
                      },
                    ),
                  );
                }),
                TextButton(
                  onPressed: () => _addFoodItemToMeal(meal),
                  child: Text('Add Food Item'),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Meal notes...',
                    labelText: 'Notes',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _meals[index] = Meal(
                        type: meal.type,
                        time: meal.time,
                        items: meal.items,
                        notes: value,
                      );
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General Instructions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _instructionsController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Add any general instructions...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHydrationCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hydration Guidelines',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _hydrationController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'e.g., Drink 8-10 glasses of water daily...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton() {
    return ElevatedButton(
      onPressed: _createDietPlan,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        minimumSize: Size(double.infinity, 50),
      ),
      child: Text(
        'Create Diet Plan',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _selectDate(bool isStart) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        if (isStart) {
          _startDate = date;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(Duration(days: 7));
          }
        } else {
          _endDate = date;
        }
      });
    }
  }

  void _addFoodToEat() {
    final food = _foodToEatController.text.trim();
    if (food.isNotEmpty) {
      setState(() {
        _foodsToEat.add(food);
        _foodToEatController.clear();
      });
    }
  }

  void _addFoodToAvoid() {
    final food = _foodToAvoidController.text.trim();
    if (food.isNotEmpty) {
      setState(() {
        _foodsToAvoid.add(food);
        _foodToAvoidController.clear();
      });
    }
  }

  void _addFoodItemToMeal(Meal meal) {
    showDialog(
      context: context,
      builder: (context) {
        final nameController = TextEditingController();
        final quantityController = TextEditingController();
        final caloriesController = TextEditingController();
        final methodController = TextEditingController();

        return AlertDialog(
          title: Text('Add Food Item to \${meal.type}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Food Name',
                    hintText: 'e.g., Oatmeal',
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    labelText: 'Quantity',
                    hintText: 'e.g., 1 bowl',
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: caloriesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Calories',
                    hintText: 'e.g., 150',
                  ),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: methodController,
                  decoration: InputDecoration(
                    labelText: 'Preparation Method',
                    hintText: 'e.g., Boiled',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final foodItem = FoodItem(
                  name: nameController.text,
                  quantity: quantityController.text,
                  calories: caloriesController.text,
                  preparationMethod: methodController.text,
                );
                setState(() {
                  meal.items.add(foodItem);
                });
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _createDietPlan() {
    if (_formKey.currentState!.validate()) {
      context.read<DietPlanBloc>().add(
        CreateDietPlan(
          patientId: widget.patientId,
          disease: widget.disease,
          startDate: _startDate,
          endDate: _endDate,
          meals: _meals,
          foodsToEat: _foodsToEat,
          foodsToAvoid: _foodsToAvoid,
          instructions: _instructionsController.text,
          hydrationGuidelines: _hydrationController.text,
        ),
      );
      
      Navigator.pop(context, true);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Diet plan created successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '\${date.day}/\${date.month}/\${date.year}';
  }
}

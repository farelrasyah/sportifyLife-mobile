/// Integration Guide for Sleep Feature
///
/// This file shows how to integrate the Sleep feature into your main app.
/// Follow these steps to add Sleep functionality to your existing app.

/*
STEP 1: Add Sleep Feature Provider to your main app

In your main.dart or app.dart, wrap your MaterialApp with the Sleep providers:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/sleep_feature_provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SleepFeatureProvider(
      child: MaterialApp(
        title: 'SportifyLife',
        home: YourMainScreen(),
        // ... your other app configurations
      ),
    );
  }
}
```

STEP 2: Navigate to Sleep screens from your existing UI

From any screen in your app, you can navigate to Sleep features like this:

```dart
import '../services/sleep_feature_provider.dart';

// Navigate to Sleep Activity
ElevatedButton(
  onPressed: () => SleepNavigation.pushSleepActivity(context),
  child: Text('Sleep Activity'),
),

// Navigate to Sleep Plan/Schedule
ElevatedButton(
  onPressed: () => SleepNavigation.pushSleepPlan(context),
  child: Text('Sleep Schedule'),
),

// Navigate to Add Alarm
ElevatedButton(
  onPressed: () => SleepNavigation.pushAddAlarm(context, DateTime.now()),
  child: Text('Add Sleep Alarm'),
),
```

STEP 3: Direct integration without provider wrapper (if needed)

If you prefer direct integration, import the screens directly:

```dart
import 'ui/screens/sleep_stats/sleep_activity_screen.dart';
import 'ui/screens/sleep_stats/sleep_plan_screen.dart';
import 'ui/screens/sleep_stats/add_alarm_screen.dart';
import 'services/sleep_feature_provider.dart';

// In your navigation code:
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SleepFeatureProvider(
      child: SleepActivityScreen(),
    ),
  ),
);
```

STEP 4: Add Sleep menu items to your main navigation

Example for a BottomNavigationBar or Drawer:

```dart
// In your main navigation widget
BottomNavigationBarItem(
  icon: Icon(Icons.bedtime),
  label: 'Sleep',
),

// Handle navigation
void _onTabTapped(int index) {
  if (index == 2) { // Sleep tab
    SleepNavigation.pushSleepActivity(context);
  }
}

// Or in a Drawer
ListTile(
  leading: Icon(Icons.bedtime),
  title: Text('Sleep Tracker'),
  onTap: () => SleepNavigation.pushSleepActivity(context),
),

ListTile(
  leading: Icon(Icons.schedule),
  title: Text('Sleep Schedule'),
  onTap: () => SleepNavigation.pushSleepPlan(context),
),
```

STEP 5: API Configuration

Make sure your API base URL is configured in:
- lib/utils/constants.dart (AppConstants.apiUrl)

The Sleep API endpoints will be automatically configured:
- POST /sleep/schedule (Create schedule)
- GET /sleep/schedule (Get schedules) 
- GET /sleep/schedule/calendar (Calendar data)
- GET /health/sleep/daily-summary (Daily summary)
- PATCH /sleep/schedule/:id (Update schedule)
- DELETE /sleep/schedule/:id (Delete schedule)

STEP 6: Error Handling

The Sleep feature includes comprehensive error handling:
- Network errors
- API errors (400, 401, 404, 409, etc.)
- Loading states
- Empty states
- Refresh functionality

STEP 7: Testing the Integration

1. Run the app: flutter run
2. Navigate to Sleep Activity screen
3. Try creating a new sleep schedule
4. Check calendar integration
5. Verify data persistence

FEATURES INCLUDED:

✅ Sleep Schedule Management
- Create, update, delete sleep schedules
- Recurring schedules (daily, weekdays, weekends, custom)
- Alarm configuration (sound, vibration)
- Notes support

✅ Sleep Activity Tracking
- Weekly sleep data visualization
- Last night sleep summary
- Sleep trends and statistics
- Interactive charts

✅ Sleep Calendar
- Calendar view of sleep data
- Date-specific sleep information
- Schedule adherence tracking
- Progress indicators

✅ State Management
- Clean architecture with Cubit/BLoC
- Loading, success, error states
- Data caching and refresh
- Separation of concerns

✅ UI/UX
- Consistent with existing app design
- Loading indicators
- Error handling with retry
- Pull-to-refresh
- Smooth animations

✅ Production Ready
- Comprehensive error handling
- Type-safe models
- API response mapping
- Performance optimized
*/

import 'package:flutter/material.dart';

/// Example integration widget showing how to add Sleep navigation
class SleepIntegrationExample extends StatelessWidget {
  const SleepIntegrationExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.show_chart),
          title: const Text('Sleep Activity'),
          subtitle: const Text('View sleep trends and statistics'),
          onTap: () {
            // Navigate to Sleep Activity screen
            Navigator.pushNamed(context, '/sleep/activity');
          },
        ),
        ListTile(
          leading: const Icon(Icons.bedtime),
          title: const Text('Sleep Schedule'),
          subtitle: const Text('Manage sleep schedules and alarms'),
          onTap: () {
            // Navigate to Sleep Plan screen
            Navigator.pushNamed(context, '/sleep/plan');
          },
        ),
        ListTile(
          leading: const Icon(Icons.alarm_add),
          title: const Text('Add Sleep Alarm'),
          subtitle: const Text('Create a new sleep schedule'),
          onTap: () {
            // Navigate to Add Alarm screen
            Navigator.pushNamed(context, '/sleep/add-alarm');
          },
        ),
      ],
    );
  }
}

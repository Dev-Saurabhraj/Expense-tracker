# 💰 Expense Tracker

A powerful and intuitive Flutter-based expense tracking application designed to help you manage your finances effectively. Track daily expenses, visualize spending patterns, set financial goals, and gain valuable insights into your spending habits.

---

## 📱 App Preview

| Dashboard | Transactions | Insights | Goals |
|-----------|--------------|----------|-------|
| View summary | Add/Edit transactions | Chart trends | Set goals |
| Quick stats | Search & filter | Daily/Weekly/Monthly | Track progress |

---

## ✨ Features

### 🏠 Dashboard
- **Quick Overview**: Total expenses, income, and balance display
- **Recent Transactions**: View your 5 most recent transactions
- **Quick Actions**: Add transaction, view insights, and manage goals
- **Visual Summary**: See spending at a glance with key metrics

### 💳 Transaction Management
- **Add Transactions**: Record expenses and income with category, amount, and date
- **Edit Transactions**: Update transaction details easily
- **Delete Transactions**: Remove transactions with confirmation dialog
- **Search**: Find transactions by title, category, or notes (case-insensitive)
- **Category Filtering**: Filter transactions by category (Food, Transport, Shopping, Bills, Salary, Other)
- **Pagination**: Navigate through large transaction lists with ease
- **Transaction Details**: View full transaction information including category, type, and date

### 📊 Insights & Analytics
- **Expense Trends**: Visualize spending patterns with interactive charts
- **Multiple Views**:
  - **Daily**: Last 6 days of spending (real-time updates)
  - **Weekly**: Last 6 weeks of spending (incomplete current week shows only up to today)
  - **Monthly**: Last 6 months of spending
- **Category Analysis**: Filter insights by specific categories
- **Interactive Charts**: Tap to view detailed spending for selected periods
- **Period Transactions**: See all transactions within selected period
- **Smart Aggregation**: Automatically calculates totals based on time period

### 🎯 Goals Management
- **Create Goals**: Set financial goals with target amounts
- **Track Progress**: Monitor how close you are to each goal
- **Visual Indicators**: Progress bars showing goal completion status
- **Goal History**: View past and current goals

### 🎨 User Experience
- **Clean Design**: Modern, intuitive interface with smooth animations
- **Dark/Light Theme**: Seamless visual experience with carefully chosen colors
- **Smooth Navigation**: Go Router for efficient screen transitions
- **Error Handling**: Graceful error states and user feedback
- **Loading States**: Shimmer animations for better perceived performance
- **Responsive Design**: Works optimally on various screen sizes

---

## 🏗️ Architecture

This project follows **Clean Architecture** with **BLoC** pattern for state management:

```
lib/
├── main.dart                     # App entry point
├── Core/                         # Core layer - shared utilities
│   ├── Colors/                   # Theme colors (AppColors)
│   ├── Constants/                # Text styles, app constants
│   ├── Icons/                    # Icon assets
│   ├── Exceptions/               # Custom exception classes
│   ├── Helpers/                  # Helper utilities
│   ├── Extensions/               # DateTime, Number extensions
│   ├── Utils/                    # Chart calculations & constants
│   └── Widgets/                  # Reusable UI components
├── Data/                         # Data layer
│   ├── models/                   # TransactionModel, GoalModel
│   └── repositories/             # FinanceRepository (data access)
├── Features/                     # Features layer (BLoC pattern)
│   ├── Dashboard/
│   │   ├── Bloc/                 # DashboardBloc + Events/States
│   │   ├── ui/                   # Dashboard screen
│   │   └── Widgets/              # Feature-specific widgets
│   ├── Transactions/
│   │   ├── Bloc/                 # TransactionsBloc + Events/States
│   │   ├── ui/
│   │   │   ├── transactions_screen.dart
│   │   │   └── widgets/          # TransactionSearchBar, CategoryFilter
│   │   └── Widgets/              # Transaction list, items
│   ├── Insights/
│   │   ├── Bloc/                 # InsightsBloc + Events/States
│   │   ├── ui/
│   │   │   ├── insights_screen.dart
│   │   │   └── components/       # Chart, category filter, transaction list
│   │   └── Widgets/
│   ├── Goals/
│   │   ├── Bloc/                 # GoalsBloc + Events/States
│   │   └── ui/
│   └── MainWrapper.dart          # Bottom navigation
└── Router/
    └── goRouter.dart             # Navigation configuration
```

### Architecture Layers

#### **Core Layer**
- Provides shared utilities, theme, and helpers
- Reusable UI components and extensions
- Isolated from business logic

#### **Data Layer**
- **Models**: Data structures (TransactionModel, GoalModel)
- **Repositories**: Data access abstraction (FinanceRepository)
- Handles local storage via SharedPreferences

#### **Features Layer (BLoC Pattern)**
- Each feature has its own BLoC for state management
- **BLoC**: Handles all business logic and state management
- **Events**: User interactions or API calls
- **States**: UI states (Loading, Loaded, Error)
- **UI**: Screens and widgets that listen to BLoC

### State Management Pattern

**BLoC (Business Logic Component)**
```
User Action → Event → BLoC → State → UI Update
```

For each feature:
1. User interacts with UI (tap, swipe, etc.)
2. Widget dispatches an Event to BLoC
3. BLoC processes the event and emits a State
4. BlocBuilder listens to state changes
5. UI rebuilds with new data

### Key Design Decisions

✅ **Search Isolation**: Search/Filter logic in dedicated widgets to prevent undefined errors  
✅ **State Separation**: BLoC handles business state, widgets handle UI-only state  
✅ **Error Handling**: Comprehensive try-catch blocks and error states  
✅ **Optimized Rebuilds**: buildWhen conditions prevent unnecessary rebuilds  
✅ **Pagination**: Efficient data loading with page controls  
✅ **Charts**: Smart data aggregation (Daily/Weekly/Monthly views)

---

## 🚀 Installation Guide

### Prerequisites
- **Flutter SDK**: Version 3.11.4 or higher ([Install Flutter](https://docs.flutter.dev/get-started/install))
- **Dart**: Comes with Flutter
- **Git**: For version control
- **Android Studio** or **Xcode**: For emulator/device testing

### Step 1: Clone Repository
```bash
git clone https://github.com/Dev-Saurabhraj/Expense-tracker.git
cd Expense-tracker
```

### Step 2: Get Dependencies
```bash
flutter pub get
```

### Step 3: Generate App Icons (Optional)
```bash
flutter pub run flutter_launcher_icons:main
```

### Step 4: Run the App

**On Android Emulator/Device:**
```bash
flutter run -d android
```

**On iOS Simulator/Device:**
```bash
flutter run -d ios
```

**On Chrome Web:**
```bash
flutter run -d chrome
```

**For Release Build:**
```bash
flutter run --release
```

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^17.1.0          # Navigation & routing
  flutter_bloc: ^9.1.1        # State management
  bloc: ^9.2.0                # BLoC core
  fl_chart: ^1.2.0            # Chart visualization
  flutter_svg: ^2.2.4         # SVG asset support
  equatable: ^2.0.8           # Value equality
  cupertino_icons: ^1.0.8     # iOS-style icons
```

---

## 📲 Building APK

### Create Release APK
```bash
flutter build apk --release
```

### Create App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

Output location: `build/app/outputs/flutter-apk/app-release.apk`

---

## 📥 Download APK

**Latest APK Build**: [Download from Google Drive](https://drive.google.com/drive/folders/YOUR_DRIVE_LINK_HERE)
- File: `expense_tracker_v1.0.0.apk`
- Size: ~[Size in MB]
- Minimum Android Version: Android 5.0+
- Target Android Version: Android 13+

*Note: Add your actual Google Drive link here where your built APK is stored.*

---

## 🎯 Key Features Breakdown

### Transaction Search
- Real-time search across title, category, and notes
- Case-insensitive matching
- Instant results with clear functionality
- Optimized with dedicated SearchBar widget

### Spending Insights
- **Daily Trend**: View expenses for last 6 days
- **Weekly Trend**: View expenses for last 6 weeks (current week truncated to today)
- **Monthly Trend**: View expenses for last 6 months
- **Smart Charts**: Interactive line charts with tap-to-view functionality
- **Category Breakdown**: Filter any view by specific category
- **Real-time Updates**: Charts update instantly when transactions change

### Smart Filtering
- Multi-category selection in Transactions
- Single category filter in Insights
- Independent search and filter logic
- Pagination resets on filter changes
- Clear filter buttons for quick reset

### Data Persistence
- All data saved to device via SharedPreferences
- Automatic persistence on every transaction
- No internet required
- Data persists across app sessions

---

## 🔧 Development Workflow

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

### Code Analysis
```bash
# Analyze code quality
flutter analyze
```

### Format Code
```bash
# Format all files
dart format lib/
```

---

## 📝 Project Statistics

- **Total Lines of Code**: 5000+
- **Features**: 6 major features
- **Screens**: 6 main screens
- **BLoCs**: 4 feature BLoCs
- **Components**: 15+ reusable widgets
- **Supported Platforms**: Android, iOS, Web

---

## 🐛 Known Limitations

- Local storage only (no cloud sync)
- Single user per device
- No offline transaction queuing
- Limited chart customization

---

## 🚀 Future Enhancements

- [ ] Cloud backup (Firebase)
- [ ] Multi-user support
- [ ] Budget alerts
- [ ] Recurring transactions
- [ ] Receipt OCR
- [ ] Multiple currencies
- [ ] Data export (PDF/CSV)
- [ ] Dark mode toggle
- [ ] App widget support

---

## 📧 Support & Contact

- **Author**: Dev-Saurabhraj
- **Email**: [saurabhraj2509@gmail.com]
- **Repository**: [GitHub - Expense Tracker](https://github.com/Dev-Saurabhraj/Expense-tracker)
- **Issues**: Report bugs on GitHub Issues

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 🙏 Acknowledgments

- Flutter community for excellent documentation
- BLoC library for state management pattern
- FL Chart for beautiful chart visualizations
- All contributors and testers

---

## 📚 Learning Resources

### Architecture & Patterns
- [Clean Architecture](https://resocoder.com/flutter-clean-architecture)
- [BLoC Pattern](https://bloclibrary.dev/)
- [Flutter Best Practices](https://flutter.dev/docs/guides/android-release-build)

### Related Technologies
- [Go Router](https://pub.dev/packages/go_router)
- [FL Chart](https://github.com/imaNNeoFighT/fl_chart)
- [Flutter Bloc](https://bloclibrary.dev/)

---

**Made with ❤️ using Flutter**

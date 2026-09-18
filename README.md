# 🎓 LearnX LMS - Flutter Learning Management System

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
![RTL Supported](https://img.shields.io/badge/RTL-Arabic_Support-orange?style=for-the-badge)

**LearnX LMS** is a modern, feature-packed Learning Management System (LMS) mobile application built with **Flutter**, **Dart**, and **Supabase**. Designed with full **Right-to-Left (RTL)** Arabic interface support and custom typography, LearnX provides students with an intuitive platform to discover courses, track learning progress, save favorites, and manage their educational journey seamlessly.

---

## 🌟 Key Features

- 🔐 **Authentication & User Profiles**:
  - Secure Email/Password registration and login powered by **Supabase Auth**.
  - Profile customization (full name, email, password update).
  - User stats overview (completed lessons, enrolled courses, certificates).

- 📚 **Course Discovery & Search**:
  - Interactive home dashboard with category filtering.
  - Live search functionality across course titles and metadata.
  - Smooth loading states powered by `shimmer`.

- 📖 **Interactive Course Details & Lesson Viewing**:
  - Rich course information including duration, difficulty level, rating, partner institutions, and skills taught.
  - Interactive lesson checklist that updates completion progress in real time.

- 📊 **Progress & Enrollment Tracking**:
  - One-tap course enrollment.
  - Real-time progress percentage updates synced dynamically with Supabase.
  - Automatic completed course and certificate counters.

- ❤️ **Favorites System**:
  - Bookmark favorite courses for quick access.
  - Instantly synced across devices via backend tables.

- 🌐 **Full RTL & Custom Typography**:
  - Native Right-to-Left layout designed specifically for Arabic speakers.
  - Custom font family (`Almarai-Arabic`) for a clean, professional aesthetic.

---

## 🛠️ Tech Stack & Packages

- **Framework**: [Flutter](https://flutter.dev/) (SDK `^3.13.2`)
- **Backend & Auth**: [Supabase Flutter](https://pub.dev/packages/supabase_flutter) (`^2.17.2`)
- **HTTP Client**: [Dio](https://pub.dev/packages/dio) (`^5.11.1`)
- **Environment Management**: [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) (`^5.2.1`)
- **UI & Effects**: [Shimmer](https://pub.dev/packages/shimmer) (`^4.0.0`), Cupertino Icons
- **State Management**: Reactive `ValueNotifier` pattern combined with asynchronous backend synchronization.

---

## 🗄️ Database Architecture (Supabase)

LearnX relies on PostgreSQL tables hosted on **Supabase**:

| Table Name | Description | Key Fields |
|---|---|---|
| `courses` | Stores course details and metadata | `id`, `name`, `url`, `rating`, `duration`, `difficulty`, `skills`, `image` |
| `enrollments` | Tracks course subscriptions per user | `user_id`, `course_id`, `progress` |
| `favorites` | Tracks user bookmarked courses | `user_id`, `course_id`, `created_at` |
| `lesson_progress` | Stores completed lesson indices for each user & course | `user_id`, `course_id`, `lesson_index`, `is_completed` |

---

## 🚀 Getting Started

### Prerequisites

Ensure you have the following installed on your environment:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version `3.13.2` or higher)
- [Dart SDK](https://dart.dev/get-dart)
- An active [Supabase Project](https://supabase.com/)

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/learnx_flutter.git
cd learnx_flutter
```

### 2. Configure Environment Variables

Create a `.env` file in the root directory of the project (you can copy `.env.example`):

```bash
cp .env.example .env
```

Open `.env` and fill in your Supabase and RapidAPI credentials:

```env
# Supabase Configuration
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key

# RapidAPI Configuration (Optional / External Course Data)
RAPIDAPI_KEY=your_rapidapi_key
RAPIDAPI_HOST=coursera-course-data-api.p.rapidapi.com
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the Application

```bash
flutter run
```

---

## 📁 Project Structure

```
lib/
├── main.dart                       # App entry point, Supabase & dotenv setup, RTL configuration
├── models/
│   └── coures_model.dart          # Data models for courses, skills, and search results
├── presentation/
│   ├── auth/                       # Authentication screens (Sign In, Sign Up)
│   ├── main_navigation_screen.dart # Bottom navigation bar container
│   ├── home_page.dart              # Home dashboard, course lists, search
│   ├── course_details_page.dart    # Detailed course view & enrollment
│   ├── lesson_view_page.dart       # Lesson content playback & checklist
│   ├── my_courses_page.dart        # User's enrolled courses and progress
│   ├── favorites_page.dart         # Bookmarked favorite courses
│   ├── profile_page.dart           # User profile & achievements stats
│   ├── edit_profile_page.dart      # Edit user profile information
│   └── on_boarding.dart            # Welcome onboarding screen
└── service/
    ├── auth.dart                   # Supabase authentication helper
    ├── course_service.dart         # Local reactive state & business logic
    └── supabase_db_service.dart    # Supabase database CRUD operations
```

---


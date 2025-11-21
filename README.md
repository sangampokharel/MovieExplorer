## ScreenShots
<!-- Row 1 -->
<p float="left">
  <img src="https://github.com/user-attachments/assets/5ebc8d12-ae3f-4fa6-91ac-f02ee7bad280" width="24%" />
  <img src="https://github.com/user-attachments/assets/2a15c1d1-500e-4331-ad6f-d09c43fba337" width="24%" />
  <img src="https://github.com/user-attachments/assets/4acadd77-d515-45a3-8e68-dca8f3810c0e" width="24%" />
  <img src="https://github.com/user-attachments/assets/73d949aa-ba4e-41ed-af82-435591f4dfb8" width="24%" />
</p>

<!-- Row 2 -->
<p float="left">
  <img src="https://github.com/user-attachments/assets/abc01e88-02ea-4df8-a4c9-e8aba3a3a9c7" width="24%" />
  <img src="https://github.com/user-attachments/assets/02274cbe-cd15-4e5b-b023-c0fb4d7f3011" width="24%" />
  <img src="https://github.com/user-attachments/assets/92a79883-b26f-413c-b2fa-d1af62fc2e8e" width="24%" />
  <img src="https://github.com/user-attachments/assets/6d96a2de-dbb0-45ee-bc25-a8ba5a48b0f9" width="24%" />
</p>

# Video URL
- https://cloud.ekbana.info/index.php/s/8XMb0kKkGavCaRP

## Architecture
The app follows a clean architecture pattern with MVVM (Model-View-ViewModel) design:

## Configuration
- XCode 26.1.1
- Swift 6.2

## Core Components
- MovieModel: The main data model representing a movie
- MovieDTO: Data Transfer Object for API responses from TMDB
- MovieViewModel: Handles business logic and state management
- OfflineMovieService: Handles offline caching and persistence operations
- RealmMovieRepository: Manages local database operations using Realm
- FilterController: UI component for movie category filtering
- RadioButton: Custom UI component for filter selection


## Features in Detail

# 📱 User Interface
- Movie List: Displays movies in a clean table view with poster images
- Search: Real-time search with debounced input
- Filtering: Bottom sheet with radio button selection for sorting
- Loading States: Activity indicators for initial load and pagination
- Error Handling: User-friendly alerts with retry options
- Theming: Supports dark & Light Themes

# 🌐 Network Layer
- API Integration: TMDB API endpoints for popular, revenue, and top voted movies
- Pagination: Automatic loading of additional pages as user scrolls
- Network Monitoring: Detects connectivity changes and switches to offline mode

💾 Offline Support
- Automatic Caching: Movies are cached locally for offline viewing
- Offline Mode: Seamless switching between online and offline content
- Background Caching: Efficient async operations for data persistence

## Project Structure Usage

1. Browse Movies: Launch the app to view a collection of popular movies
2. Search Movies: Use the search bar to find movies by title
3. Apply Filters: Tap the filter button to sort by Popular, Revenue, or Top Voted
4. Load More: Scroll down to automatically load more movies
5. View Details: Tap on any movie to see full details
6. Offline Mode: Previously viewed movies are available offline

## API Endpoints

The app uses the following TMDB API filter keys:
- popularity.desc - Sort by popularity (descending)
- revenue.desc - Sort by revenue (descending)
- vote_count.desc - Sort by vote count (descending)

# Persistence Layer

Using Realm Swift for local storage:
- Async Operations: All database operations are async/await based
- Category-based Caching: Movies are categorized by filter type
- Efficient Queries: Optimized Realm queries for fast retrieval
- Automatic Updates: update: .all policy for seamless data updates


Created by **Sangam Pokharel** (November 2025)

## Acknowledgments
- The Movie Database (TMDB) for providing movie data
- Realm for the persistence layer
- Apple's Combine framework for reactive programming

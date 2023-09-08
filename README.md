# BragiMovie

BragiMovie is a simple, reactive iOS app built to showcase movies and TV shows by genre, leveraging the TMDB API.

## Table of Contents
- [Installation](#installation)
- [Architecture](#architecture)
- [Libraries](#libraries)
- [Features](#features)
- [Known Issues](#known-issues)
- [Conclusion](#conclusion)

## Installation

### Prerequisites

- iOS 14.0+
- Xcode 14.2+
- Cocoapods

### Setup

1. **Clone the repository**:
\```
git clone https://github.com/safakcan/BragiMovie.git
\```

2. **Navigate to the project directory**:
\```
cd BragiMovie
\```

3. **Install the pods**:
\```
pod install
\```

4. **Open the `.xcworkspace` file in Xcode**:
\```
open BragiMovie.xcworkspace
\```

5. Build & run!

## Architecture

BragiMovie adopts the **MVVM (Model-View-ViewModel)** architecture which, combined with RxSwift, provides a clear separation of concerns, making the app scalable, maintainable, and testable.

- **Model**: Represents our data structures and network calls.
- **View**: Contains the UI components.
- **ViewModel**: Manages the data for the View.

## Libraries

- **RxSwift & RxCocoa**: Provides a reactive approach to handle data streams and UI components.
- **SDWebImage**: A powerful image loading and caching library for iOS.

## Features

- **Genre-based Filtering**: Easily switch between different genres to browse movies and TV shows.
- **Endless Scrolling**: As the user scrolls, the app fetches more content, ensuring a seamless browsing experience.

## Known Issues

- Due to the complex nature of integrating movie details with the general list (e.g., budget and revenue for movies, last air date, and last episode name for TV shows), these details are currently fetched separately. Efforts to combine them seamlessly into the main list were made, but due to some challenges, this feature was postponed for a future update.

## Conclusion

BragiMovie was developed with a keen focus on user experience and reactive programming paradigms. Despite some challenges, the project adheres to modern design and architectural practices. Feedback, contributions, and suggestions are welcome!


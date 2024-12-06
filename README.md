# task

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


>Features
#HomePage: Displays a list of posts fetched from an API.
#Post Details Screen: Allows users to view the details of a specific post and interact with the app's data.
#State Management: This app uses Provider for state management to handle the flow of data and UI updates.
#Post Model: A model class that defines the structure of the data (Post).

> Tools and Technologies
#Flutter: The framework used to build the app.
#Provider: Used for state management.
#Dart: Programming language used for building the app.
#HTTP: Used to fetch data from a remote API.
> 
> /lib
├── models
│    └── post.dart  # Contains the Post model class
├── providers
│    └── post_provider.dart  # Contains the PostProvider class for state management
├── screens
│    ├── home_page.dart  # Contains the Home Page UI
│    └── post_details_screen.dart  # Contains the Post Details Screen UI
└── main.dart  # Entry point of the app

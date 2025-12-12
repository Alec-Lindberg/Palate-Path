# Palate Path - App Blueprint

## Overview

Palate Path is a smart recipe recommendation app designed to help users discover new meals tailored to their tastes and dietary needs. The app uses Firebase for authentication, data storage, and backend services.

## Implemented Features

*   **Authentication**: User sign-up and login with email and password.
*   **Core Models**: `Recipe`, `UserProfile`, `AppUser` data structures.
*   **Firebase Service**: A centralized service (`firebase_service.dart`) for interacting with FirebaseAuth and Firestore.
*   **Onboarding**: A food preferences screen for new users to set their tastes.
*   **Recipe Management**: Users can view, add, and browse recipes.
*   **User Profiles**: Users can view their profile and update their food preferences.
*   **Routing**: Navigation managed by `GoRouter`, including an authentication gate.

## Bug Fixes & Refinements

This section documents the fixes and improvements made to resolve initial compilation and runtime errors.

*   **Data Model Consistency**: Standardized user preference fields from `likedCuisines`/`dislikedCuisines` to `likedFoods`/`dislikedFoods` across all models (`UserProfile`), screens (`FoodPreferencesScreen`, `ProfileScreen`), and services (`FirebaseService`).
*   **Model Instantiation**:
    *   Corrected the `fromFirestore` factory constructors in the `Recipe` and `UserProfile` models to properly handle data from Firestore.
    *   The `Recipe` model now correctly receives the document ID from Firestore, ensuring a non-nullable `id`.
*   **Firebase Service Layer**:
    *   Replaced incorrect `getDocument` calls with a consistent `getData` method for fetching single documents.
    *   The `setData` method now correctly handles both creating new documents and updating existing ones.
    *   Added a generic `getCollectionStream` method to provide real-time streams of collection data.
    *   Refined the `getUserProfile` stream to gracefully handle cases where a user profile does not yet exist.
*   **UI & Navigation**:
    *   Fixed a bug in `AddRecipeScreen` where the `cuisine` field was missing from the form.
    *   Resolved a data parsing issue in `FoodPreferencesScreen` to correctly load and save user preferences.
    *   Ensured that the `recipe.id` passed from `RecipeCard` to `RecipeDetailScreen` is non-nullable, preventing runtime errors.

## Current Development Plan

This plan outlines the steps to further enhance the app's functionality and user experience.

### 1. Advanced Recipe Filtering and Sorting

*   **Objective**: Improve the recipe recommendation algorithm and provide users with more control over the displayed recipes.
*   **Steps**:
    *   Implement sorting options on the `HomeScreen` (e.g., by cook time, difficulty).
    *   Add more advanced filtering options, such as filtering by comfort level.

### 2. UI/UX Polish

*   **Objective**: Enhance the visual appeal and usability of the application.
*   **Steps**:
    *   Apply a consistent and attractive theme using Material 3 principles.
    *   Incorporate loading indicators and handle empty states gracefully.
    *   Improve the layout and design of the recipe cards and detail screen.
    *   Add user-friendly animations and transitions.

### 3. User-Specific Recipe Interaction

*   **Objective**: Deepen the user's interaction with recipes.
*   **Steps**:
    *   Implement a rating system on the `RecipeDetailScreen`.
    *   Allow users to add personal notes to recipes they've tried.

### 4. Error Handling and Logging

*   **Objective**: Make the app more robust and easier to debug.
*   **Steps**:
    *   Implement centralized error handling and user-facing error messages.
    *   Integrate structured logging using the `dart:developer` library to track app behavior and issues.

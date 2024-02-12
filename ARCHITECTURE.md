# Architecture

This document outlines the architecture for a Flutter app that utilizes the BLoC pattern and Rust for local data persistence.

## Overview

The architecture follows a layered approach, separating concerns into different layers:

- Presentation Layer: Contains the UI components and handles user interactions.
- Business Logic Layer: Implements the BLoC pattern to manage the app's state and business logic.
- Data Layer: Handles data persistence using Rust.

```
features/
├── feature1/
│   ├── presentation/
│   │   ├── pages/
│   │   ├── widgets/
│   ├── business/
│   │   ├── bloc1/
```

## Presentation Layer

The presentation layer consists of the following components:

- Pages: Represent the different screens of the app.
- Widgets: Represent the different UI components of the app.

## Business Logic Layer

The business logic layer implements the BLoC pattern to manage the app's state and business logic. It consists of the following components:

- Bloc: Manage the app's state and business logic.
- Cubits: Manage the app's state.

## Data Layer

The data layer handles data persistence using Rust.

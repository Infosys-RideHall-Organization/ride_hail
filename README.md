# RideHail - Infosys Buggy Booking Application

## Problem Statement
Infosys operates a large campus where employees require transportation for efficient mobility. Currently, the buggy transportation service is managed manually, leading to inefficiencies in scheduling, tracking, and resource utilization. The lack of a digital booking system causes confusion among riders and drivers, resulting in long wait times and suboptimal service. To address this, develop a **cross-platform mobile application** that digitizes the entire buggy booking process, ensuring seamless access for both **Android** and **iOS** users.

## Solution Overview

To tackle the issues with the current manual buggy booking system, our team designed and developed **RideHail** — a **cross-platform mobile application** backed by a robust and scalable backend. The goal was to simplify the user experience of booking buggies on campus, enable real-time tracking, and enhance communication between riders and drivers.

By leveraging **real-time features**, applying **clean architectural patterns**, and utilizing a modern **tech stack**, we’ve created a platform that reduces wait times, improves coordination through **push notifications**, and delivers a seamless mobility experience across the Infosys campus.

---

## Tech Stack

We adopted a modern, scalable stack across both frontend and backend layers to ensure performance, maintainability, and smooth real-time interaction.

### Frontend (Cross-Platform App)
- **Framework**: Flutter
- **Language**: Dart
- **Architecture**: Clean Architecture (core + feature separation)
- **State Management**: BLoC
- **Key Features**: Real-time map updates, WebSocket-based live communication

### Backend (API & Real-time Communication)
- **Platform**: Node.js
- **Language**: TypeScript
- **Framework**: Express.js
- **Support**: REST APIs and WebSocket integration using Socket.IO

### Database
- **Database**: MongoDB
- **ORM**: Mongoose for schema validation and data modeling

### Notifications
- **Service**: OneSignal
- **Purpose**: Push notifications to keep both drivers and users updated about ride events

### Google SDK Integration
- **Google Maps SDK (Flutter)**:  
  Used for map rendering, route visualization, and geolocation on the client side.

- **Google Places API**:  
  Integrated for location search, autocomplete suggestions, and place details (e.g., pickup/drop-off).

---

## Design Principles

Throughout the development of RideHail, we adhered to well-established software engineering principles to ensure that the codebase remains clean, reusable, and scalable. These principles were followed across both the frontend and backend systems:

- **DRY (Don't Repeat Yourself)**  
  We ensured that common logic is written once and reused across the application, keeping the codebase concise and easier to maintain.

- **Composition Over Inheritance**  
  Especially within Flutter, we preferred composition when building complex UIs and components, enabling greater flexibility and reducing tight coupling.

- **Code Reuse**  
  By modularizing components, creating shared utilities, and following a layered architecture, we maximized the reusability of code across the app.

- **Program to an Interface, Not an Implementation**  
  We structured our services and repositories using interfaces, promoting abstraction, easier mocking, and testability.

---

## Architecture

### Frontend

On the frontend, we followed the **Clean Architecture** pattern to maintain a clear separation of concerns between the UI, business logic, and data layers. This approach helped us keep the app modular, testable, and easier to extend over time.

![Frontend Architecture](assets/readme/clean-architecture.png)

Our frontend structure is divided into the following layers:

- **Presentation Layer**: Responsible for the user interface (widgets) and state management (using BLoC/Cubit).
- **Domain Layer**: Encapsulates business logic, use cases, and core app entities.
- **Data Layer**: Handles repositories, API calls, and local data storage mechanisms.

This structure ensures that any changes in data sources or presentation do not affect the core business logic.

### Backend

Our backend system is built using **Node.js** and **TypeScript**, following the **MVC (Model-View-Controller)** architectural pattern. This helps us maintain a clean, organized, and scalable backend while supporting both REST and WebSocket-based communication.

![Backend Architecture](assets/readme/backend-architecture.png)

### Components of MVC

- **Model (Data Layer)**  
  Defines the data structures using **Mongoose** and interacts directly with the **MongoDB** database. All data validation and schema definitions are managed here.

- **View (Response Layer)**  
  Functions as the JSON response layer in our RESTful API. This layer ensures structured responses, proper HTTP status codes, and error handling for all endpoints.

- **Controller (Logic Layer)**  
  Handles incoming requests, coordinates with models to fetch or modify data, and sends appropriate responses back to the client. Controllers are where core business logic resides, including booking coordination and user authentication.

---

## Features

Our team has carefully designed and implemented the following features to ensure a smooth, secure, and user-friendly experience for both riders and drivers on the Infosys campus:

---

###  Authentication & Access Control

- **Email & OTP Authentication**  
  Users can sign up and log in using their email and password. OTP verification adds an extra layer of security during registration.

- **Google Sign-In**  
  Quick access using Google login for a seamless onboarding experience.

- **Role-Based Access Control**  
  Customized app experience based on user roles — rider, driver, or admin — each with dedicated dashboards and permissions.

- **Account Management**  
  Complete account lifecycle support: forgot password, reset password via email OTP, logout, and account deletion.
---

###  Permissions & Offline Handling

- **Location Permission Handling**  
  The app gracefully handles location permission status, prompting the user appropriately and redirecting to settings if needed.

- **Offline Handling**  
  Meaningful UI feedback is shown when the user is disconnected from the internet, ensuring that the app handles network disruptions without crashing.

---

###  Ride Booking & Management

- **Flexible Buggy Booking**  
  Users can book a buggy instantly or schedule it for later with ease, based on availability and convenience.

- **Booking Workflow**  
  A guided step-by-step flow ensures accurate and complete ride bookings:
    1. Select destination using search or map marker
    2. Confirm pickup and destination points
    3. Add passenger/object details (up to 3)
    4. Finalize and confirm booking

- **Driver Notifications**  
  Real-time push notifications (via OneSignal) are sent to drivers when a booking is assigned to them.

- **Service Selection**  
  The app supports three service types, tailored to different needs:
    - **Buggy**: For regular passenger rides
    - **TowTruck**: For heavier item transport
    - **Bot**: For lightweight delivery services across campus

- **OTP-Based Ride Confirmation**  
  Before the ride begins, the driver must verify a system-generated OTP from the rider to ensure secure boarding.

- **Booking Lifecycle**  
  The ride experience is tracked end-to-end:
    1. Driver accepts the ride
    2. Reaches pickup location
    3. Verifies OTP
    4. Drives to destination
    5. Fare is auto-calculated and shown

- **Ride Control Options**  
  Users can cancel upcoming rides or use the emergency exit option during a ride.

- **Booking History**  
  A dedicated screen allows users to view both past and upcoming ride bookings.

---

###  Profile & Identity

- **User Profile Management**  
  Each user has a profile that includes a profile picture, name, gender, and email (used as the unique identifier).

---

###  Additional Features

- **Personalization**  
  Users can toggle between light and dark themes to match their preferences.

- **Informational Pages**  
  The app includes Terms & Conditions, FAQs, and an About page for user clarity and support.


##  Project Folder Structure - Frontend

The project follows the **Clean Architecture** pattern with a clear separation of concerns across layers. Each feature is broken into three main layers: `data`, `domain`, and `presentation`. Here's an overview of the structure:

```
lib/
├── core/                      # Reusable core modules
│   ├── common/               # Common widgets and helpers
│   ├── constants/            # App-wide constants
│   ├── entities/             # Core business entities shared across features
│   ├── error/                # Error handling and exception utilities
│   ├── routes/               # App route definitions
│   ├── services/             # Common services (e.g., network, socket, etc.)
│   ├── theme/                # Theme configuration
│   ├── usecase/              # Shared use cases
│   └── utils/                # Utility functions
│
├── features/                 # Feature-based module structure
│    ├── auth/                 # Authentication feature
│    ├── booking/              # Booking-related flows 
|    ├── driver/               # Driver-specific features
│    └── profile/              # User profile management
│
├── init_dependencies.dart    # Dependency injection and initialization
└── main.dart                 # Entry point
```

###  Feature Module Breakdown

Each `feature/` directory is organized as follows:

- **data/**
    - `models/`: DTOs and API models
    - `datasources/`: Remote or local data sources
    - `repositories/`: Repository implementation

- **domain/**
    - `entities/`: Business entities
    - `repositories/`: Abstract repo interfaces
    - `usecases/`: Application logic as use case classes

- **presentation/**
    - `pages/`: Screens and routes
    - `widgets/`: Feature-specific reusable components
    - `bloc/` or `cubit/`: State management logic

This structure allows each feature to evolve independently, promotes testability, and supports better scalability in the long run.


## Project Folder Structure - Backend

The project is structured using a **modular clean architecture** approach with separation between routing, controllers, services, and data access layers for maintainability and scalability.

```
ride-hail-backend/
├── src/                           # Main source code
│   ├── controllers/              # Handle HTTP requests and responses
│   ├── db/                       # Database connection & models (e.g., Mongoose or Prisma)
│   ├── interfaces/               # TypeScript types/interfaces (DTOs, contracts)
│   ├── middlewares/             # Express middlewares (auth, error handling, validation)
│   ├── routes/                  # Route definitions (API endpoints)
│   ├── services/                # Business logic and reusable services
│   ├── socket/                  # Real-time communication (e.g., socket.io setup)
│   ├── utils/                   # Utility functions (formatters, helpers)
│   ├── app.ts                   # Express app setup (middlewares, routers)
│   └── index.ts                 # Entry point (start server, load envs)
│
├── public/                       # Public assets if needed (e.g., uploads, static files)
├── .env                          # Environment-specific config variables
├── .gitignore                    # Git ignore list
├── nodemon.json                  # Nodemon config for development
├── package.json                  # NPM project metadata and scripts
├── package-lock.json             # Dependency lock file
├── tsconfig.json                 # TypeScript compiler configuration
```

---

## RideHail – Cloning & Running Guide

Follow the steps below to clone and run both the **frontend** and **backend** of the RideHail project.

---

## 🚀 Prerequisites

Make sure the following tools are installed:

- [Node.js](https://nodejs.org/en/) (v16 or above)
- [MongoDB](https://www.mongodb.com/atlas/database)
- [Flutter](https://flutter.dev/docs/get-started/install) (SDK 3.7.2)
- [Dart](https://dart.dev/get-dart)
- [Android Studio or VS Code](https://developer.android.com/studio) for Flutter
- [Postman](https://www.postman.com/downloads/) for API testing (optional)

---

## Backend Setup

### 1. Clone the Backend Repository

```bash
git clone https://github.com/AdilMulimani/ride-hail-backend.git
cd ride-hail-backend
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Create a `.env` File

Inside the root of the backend project, create a `.env` file and paste the following:

```env
PORT=8080
MONGO_URI=mongodb+srv://username:password@yourcluster.mongodb.net/
DB_HOST=localhost
SALT_FACTOR=10
JWT_SECRET=your_jwt_secret
NODE_ENV=development
CLIENT_URL=http://localhost:5173
GMAIL_USER=your_email@example.com
GMAIL_PASSWORD=your_app_password
GOOGLE_CLIENT_ID=your_google_client_id.apps.googleusercontent.com
ONESIGNAL_APP_ID=your-onesignal-app-id
ONESIGNAL_API_KEY=your-onesignal-api-key
```

### 4. Run the Backend

```bash
npm run dev
```

The backend server should be running on: `http://localhost:8080`

---

## 📱 Frontend Setup

### 1. Clone the Frontend Repository

```bash
git clone https://github.com/AdilMulimani/ride_hail.git
cd ride_hail
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Create a `.env` File

Inside the root of the frontend project, create a `.env` file and paste the following:


```env
BACKEND_URL=http://your-local-ip:8080/api
GOOGLE_CLIENT_ID=your_google_client_id.apps.googleusercontent.com
GOOGLE_MAPS_SDK_API_KEY=your_google_maps_api_key
ONE_SIGNAL_APP_ID=your-onesignal-app-id
BASE_URL=http://your-local-ip:8080
```

### 4. Run the Flutter App

Ensure your emulator or device is running, then execute:

```bash
flutter run
```

## Demo

Watch a full walkthrough of the RideHail app in action:

[![Watch the Demo](https://img.youtube.com/vi/1ha3gzOs6R4/hqdefault.jpg)](https://www.youtube.com/watch?v=1ha3gzOs6R4)

---


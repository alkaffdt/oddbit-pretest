# Oddbit Pretest Project

<div align="center">
  <img src="https://github.com/user-attachments/assets/3ca5576a-b905-4520-9073-02a3a3151e7a" width="300"/>
  <img src="https://github.com/user-attachments/assets/7914ae08-c3bc-4c54-8d24-f28b9553dd17" width="300"/>
</div>

</br>

This repository contains the source code for the Oddbit Pretest application, which is divided into two primary sub-projects:

## 🚀 Features

### 🔐 Authentication
- [x] Login & Register
- [x] Secure JWT Authentication (with Refresh Token)
- [x] Persistent Login Session
- [x] Logout

### 📝 Notes Management
- [x] Fetch Notes
- [x] Create Notes
- [x] Delete Notes
- [ ] Edit Notes _(coming soon)_

1. **mobile_oddbit**: A mobile application built with Flutter using Clean Architecture.
2. **be_oddbit**: An Express.js backend RESTful API.

---

## 1. Mobile App (`mobile_oddbit`)

The mobile counterpart is developed using the Flutter framework targeting multi-platform support. It aims to interact with the Express API to handle user authentication and notes.

### Technical Specifications
- **SDK**: Flutter (>= 3.11.0)
- **Architecture**: **Clean Architecture**. The codebase strictly enforces separation of concerns into distinct layers (e.g., Domain, Data, Presentation) and intentionally avoids relying on code-generation packages like Freezed for models.
- **State Management**: **Riverpod** (`flutter_riverpod ^2.5.1`). Used for robust, predictable, and scalable state management and dependency injection across the application.
- **Networking**: **Dio** (`dio ^5.4.3`). A powerful HTTP client used for handling API requests, token injection (via interceptors), and error handling.
- **Local Persistence**: **Flutter Secure Storage** (`flutter_secure_storage ^9.2.2`). Leveraged to securely persist sensitive data locally onto the device, such as the JWT access and refresh tokens.

---

## 2. Backend Service (`be-oddbit`)

The backend is a Node.js REST API built with Express.js and backed by PostgreSQL. It primarily serves as a Notes management system with secure authentication. 

### Technical Specifications
- **Framework**: Express.js
- **Database**: PostgreSQL (connected via `pg` pool)
- **Authentication**: Bearer Token (JWT). Implementing access token (60 mins lifespan) and refresh token rotation strategy (30 days lifespan, stored in DB).
- **API Documentation**: Integrated with Swagger UI. When the server is running locally, access it via `http://localhost:<PORT>/api-docs`.

### API Routes

**Auth Endpoints (`/api/auth`)**
* `POST /register`: Register a new user. Expects `username` and `password`. Returns created user and token pair.
* `POST /login`: Authenticate an existing user. Expects `username` and `password`. Returns JWT `access_token` and `refresh_token`.
* `POST /refresh`: Obtain a new token pair using a valid `refresh_token`. Invalidates the old refresh token as part of the rotation strategy.
* `POST /logout`: Invalidate the provided `refresh_token` in the database, safely logging the user out.

**Notes Endpoints (`/api/notes`)** - *Require Bearer Auth*
* `GET /`: Retrieve all notes belonging to the authenticated user, ordered by newest first.
* `POST /`: Create a new note. Expects `title` (required) and `content` (optional).
* `PUT /:id`: Update an existing note by ID. Expects updated `title` and `content`. Validates ownership before updating.
* `DELETE /:id`: Delete a specific note by ID. Validates ownership before deletion.

---


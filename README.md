
# Gshop

Gshop is an all-in-one eCommerce app that merges multiple platforms and leverages AI to enhance your shopping experience.

## Getting Started

This project is a starting point for a Flutter application. To help you get started with Flutter development, here are some useful resources:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Online Documentation](https://docs.flutter.dev/)

## Technologies Used

- Flutter
- Dart
- Firebase
- Gemini
- Google Maps

## Features

### Authentication

The authentication feature provides a simple solution for signing in and out using Google Sign-In and Firebase Authentication.

**Features:**
- Sign in with Google using Google Sign-In
- Sign out from Google and Firebase

**Usage:**
1. Add the `google_sign_in` and `firebase_auth` packages to your `pubspec.yaml` file.
2. Import the `AuthRepository` class in your Dart file.
3. Create an instance of `AuthRepository` and call the `signInWithGoogle()` method to sign in.
4. Call the `signOut()` method to sign out from Google and Firebase.

### Chat

The chat functionality handles sending messages, images, and text prompts to the Gemini API, and storing conversations in Firebase Firestore.

**Methods:**
- `sendMessage`: Sends a message with an optional image to the Gemini API and stores the conversation in Firebase Firestore.
  - **Parameters:**
    - `apiKey`: Required, the API key for the Gemini API
    - `image`: Optional, the image to be sent with the message
    - `promptText`: Required, the text prompt to be sent to the Gemini API
  - **Returns:** Future of the sent message

- `sendTextMessage`: Sends a text-only prompt to the Gemini API and stores the conversation in Firebase Firestore.
  - **Parameters:**
    - `textPrompt`: Required, the text prompt to be sent to the Gemini API
    - `apiKey`: Required, the API key for the Gemini API
  - **Returns:** Future of the sent message

- `startChatAndSendMessage`: Starts a new chat with an initial message and sends a prompt to the Gemini API, storing the conversation in Firebase Firestore.
  - **Parameters:**
    - `apiKey`: Required, the API key for the Gemini API
    - `initialText`: Required, the initial text to start the chat
    - `promptText`: Required, the text prompt to be sent to the Gemini API
  - **Returns:** Future<void> of the started chat and sent message

**Dependencies:**
- `cloud_firestore`: For interacting with Firebase Firestore
- `firebase_auth`: For authenticating with Firebase
- `google_generative_ai`: For interacting with the Gemini API
- `image_picker`: For picking images to be sent with messages
- `uuid`: For generating unique IDs for messages
- `gshop/data/repositories/storage_repo/storage.repository`: For storing images in Firebase Storage
- `gshop/features/shop/model/message`: For defining the Message model

### Fetch Products and Shops

The `fetchProducts` function retrieves a list of products from the Firestore database. It fetches a list of shops, iterates over each shop to extract products, and returns a single list of products.

**Dependencies:**
- `cloud_firestore`: For interacting with the Firestore database
- `ProductModel`: A custom model class that represents a product

## UI Integration

The data retrieved from the repositories has been processed and integrated into the UI, allowing users to easily interact with and order products.

## Contributing

Feel free to contribute to this project by submitting pull requests or opening issues.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

Feel free to modify or add any additional information specific to your project!
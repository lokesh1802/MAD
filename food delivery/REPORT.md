# MP Report

## Team

- Name(s): Lokesh Manchikanti
- AID(s): A20544931

## Self-Evaluation Checklist

Tick the boxes (i.e., fill them with 'X's) that apply to your submission:

- [X] The app builds without error
- [X] I tested the app in at least one of the following platforms (check all that apply):
  - [ ] iOS simulator / MacOS
  - [X] Android emulator
- [X] There are at least 3 separate screens/pages in the app
- [X] There is at least one stateful widget in the app, backed by a custom model class using a form of state management
- [X] Some user-updateable data is persisted across application launches
- [X] Some application data is accessed from an external source and displayed in the app
- [X] There are at least 5 distinct unit tests, 5 widget tests, and 1 integration test group included in the project

## Questionnaire

Answer the following questions, briefly, so that we can better evaluate your work on this machine problem.

1. What does your app do?

   My application is Food delivery app. where we can order food and it is categorized according to the cusine and it has a user firendly iterface.Displays food items with images, descriptions, and prices.

2. What external data source(s) did you use? What form do they take (e.g., RESTful API, cloud-based database, etc.)?

   Food items with detailed information,Category-based filtering
Search functionality,Meal details including ingredients and instructions
The API is free to use and provides real food data in JSON format.

3. What additional third-party packages or libraries did you use, if any? Why?
provider: For state management, to ensure reactive updates to the UI when the data changes.
http: For making HTTP requests to TheMealDB API
provider: For state management, particularly managing the shopping cart state
shared_preferences: For persisting delivery information and user preferences
These were chosen because:
provider offers simple yet powerful state management
http package provides reliable API communication
shared_preferences enables simple local data storage
   

4. What form of local data persistence did you use?

   Cart state using Provider, Delivery information using SharedPreferences
In-memory caching of food items in the FoodService for performance,
Category-specific caching to reduce API calls.

5. What workflow is tested by your integration test?

   The main workflow tested would be:


   Launching the app
   Loading food categories
   Selecting a category
   Adding items to cart
   Completing checkout process
   Verifying order placement

## Summary and Reflection

Used TheMealDB API but added price simulation since the API doesn't provide prices.
Implemented caching in FoodService to improve performance and reduce API calls
Created a responsive grid layout for food items.Added category filtering with proper error handling. Implemented shopping cart with persistent state

challenges that i have fased during these building are Handling category filtering correctly with the API,Managing state between screens effectively,Implementing proper error handling and loading states,Ensuring smooth user experience during API calls.
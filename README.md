# DanteX

Cross Platform implementation of Dante - Book Tracker.

Dante lets you manage all your books by simply scanning the ISBN barcode of the book.
It will automatically grab all information from Googles book database. The app let's you arrange
your books into 3 different categories, whether you have read the book, are currently reading the
book or saved the book for later. So you can simply keep track of your progress of all your books
and their current states.

### General Overview

DanteX mainly relies on Google/Firebase services for a variety of tasks. It uses `Crashlytics`
for crash reporting, `Firebase Auth` and `Google SignIn` for authentication, `Firebase Storage` for
cover storage, `Firebase Database` for storing books and recommendations.

DanteX supports the following platforms:

- iOS
- Android
- Web

The build/deployment process is coupled to the following branches:

- `develop` for the actual development
- `internal-testing` for deploying it to Firebase App Distribution
- `main` for the deployment to the Google Play Store, App Store and to the website

`codemagic.io` is used to deploy the apps to the respective services and portals. `@shockbytes` is
in charge of configuring CodeMagic for these channels.

### Naming Conventions and Code Structure

In general, the project adheres to the dart guidelines. Each class should be defined in a separate
file. File names are all named lowercase with underscores, like `book_repository.dart`. Interfaces
are used especially in the data layer, for repositories and network functionality, as this needs
to be mocked for future tests. The app utilizes the `BLOC` pattern with native Dart streams and
`Rx` streams. The developers should mainly rely on bloc classes for manipulating view state
(notable exceptions are sole UI components, where a stateful widget is the better solution).

**Developers should always favor `StatelessWidgets` over `StatefulWidgets` when implementing pages!**

Source code structure:

- bloc
  - Contains bloc classes for each page
- core
  - Contains essential classes and functions used throughout the whole app, like dependency injection.
- data
  - Contains repositories and services for storing/loading data for specific modules, like books, statistics, backups, etc...
  - Data directory structure:
    - api: Contains network code for communication with external services. Not required for most modules
    - entity: Contains the entity objects, like `book.dart`. Can also contain data classes for the api, in the `remote` directory
    - Root: Contains the repository interface with the implementation, and other services.
- ui
  - The different pages are logically grouped in a module. Each page has a dedicated class.
- util
  - Utility methods and extensions.

### Dependency Injection

Dependencies are injected via the static class `DependencyInjector`, which internally uses the
library `Get`. The actual library should never be used outside of the `DependencyInjector` module.

The dependency injector first spins up the network communication modules by running the
`ApiInjector`, followed by the `ServiceInjector`. Repositories build on top of those components
are initiated afterwards. Lastly, the `BlocInjector` is run at last, as the `blocs` are the top-layer
components, built on the other components.

### Developer Setup

Android Studio is the recommended IDE for every OS, although it is not mandatory to use it.

The source code has a single sensitive dependency, which is the `GoogleService.json` respectively
`GoogleService.plist` file and in `firebase_options.dart`.
**The configuration files will be provided by @shockbytes upon request**.

### Testing

Developers should be aiming for tests to cover all the major functionality. We are using `Mockito` to
generate mocks required for testing. To be able to run the tests, you'll need to run
`flutter pub run build_runner build` from the repo root to generate the mocks required for the tests.

### String translations

All static text strings should be in the translations files located at `/lib/l10n`.
To use the translations, add the key value pair to the translation files and then run `flutter pub get`.
You can then access the translation value by doing `AppLocalizations.of(context)!.your_key`.

The overview of the features to be worked on can be found in the following Github project:
https://github.com/users/shockbytes/projects/1/views/1

In case of unclear requirements, developers can always reach out on Discord and ask for
clarification in this channel:
https://discord.com/channels/824694597728993390/1037365721363136572

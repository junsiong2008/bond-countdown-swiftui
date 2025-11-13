# BondTracker

BondTracker is a SwiftUI reference app for monitoring service-bond obligations. Enter your total bond amount, service duration, and start date once; the app keeps the data in sync between the main experience and a WidgetKit extension so you always know how much is left to repay.

## Features
- **Guided setup** – Collect total bond amount, total service days, and the employment start date with inline validation before tracking begins.
- **Live progress tracking** – See remaining bond value, completion percentage, days served vs. remaining, and estimated completion dates with automatically updating calculations.
- **Home Screen widgets** – System small/medium/large widgets mirror the in-app stats (remaining balance, days left, progress bar) and refresh at least once a day.
- **Shared persistence** – Uses an App Group `UserDefaults` suite so the app and widget reference a single source of truth.
- **Pure SwiftUI** – Runs on iOS, iPadOS, and macOS (via SwiftUI’s multiplatform navigation patterns).

## Requirements
- Xcode 15 or newer with the latest iOS 17 SDK (WidgetKit requires iOS 17 for marginless widgets).
- iOS/iPadOS 17+ for widgets (the main SwiftUI app targets iOS 16+, but adjust as needed).
- An App Group ID that you own; update both targets before running on a physical device.

## Getting Started
1. Clone or download the repository.
2. Open `BondTracker.xcodeproj` in Xcode.
3. Update the bundle identifiers for `BondTracker` and `BondTrackerWidget` to match your team.
4. In both targets, enable the **App Groups** capability and replace the placeholder ID in `SharedConstants.swift`.
5. Select the `BondTracker` scheme and press **Run** (`⌘R`) to launch on a simulator or device.

### Configure the shared App Group
1. Create an App Group in **Certificates, Identifiers & Profiles** (e.g., `group.com.yourcompany.bondtracker`).
2. In Xcode, enable that group for the app and widget targets.
3. Update `SharedConstants.appGroupId` so `UserDefaults.shared` points to the same group for both processes.

## Usage
1. On first launch, the **Setup** flow prompts for bond amount, total service days, and start date. All fields validate before saving.
2. After saving, the **Tracking** dashboard displays current progress: remaining balance, completion %, daily cost, and projected end date. Data updates automatically as time passes.
3. Add the BondTracker widget from the system widget gallery. The widget mirrors the in-app stats and indicates if configuration is incomplete.
4. Re-open the setup sheet from the gear button anytime to adjust your numbers; changes propagate to the widget immediately.

## Project Structure
| Path | Purpose |
| --- | --- |
| `BondTracker/BondTrackerApp.swift` | App entry point that injects the shared `BondDataStore`. |
| `BondTracker/ContentView.swift` | Chooses between setup and tracking flows based on whether data is configured. |
| `BondTracker/SetupView.swift` | Form UI plus validation and persistence for initial configuration. |
| `BondTracker/TrackingView.swift` | Main dashboard with progress visuals, stat cards, and detail rows. |
| `BondCalculator.swift` | Contains the `BondData` model, computed metrics, and the `BondDataStore` that talks to shared `UserDefaults`. |
| `BondTrackerWidget/BondTrackerWidget.swift` | Widget timeline/provider/view definitions with adaptive layouts per family. |
| `SharedConstants.swift` | Houses the shared App Group ID and convenience accessor for namespaced `UserDefaults`. |

## Data Model & Persistence
- `BondData` stores the three user inputs and derives computed values (days served, days remaining, completion percentage, daily cost, and remaining balance).
- `BondDataStore` loads/saves that data via `UserDefaults.shared`, publishes updates with `@Published`, and triggers `WidgetCenter.shared.reloadAllTimelines()` when changes occur.
- The widget and the main app both read from the same store, guaranteeing consistent numbers without manual syncing.

## Widget Behavior
- The timeline provider loads the latest `BondData` snapshot and schedules the next refresh right after midnight, ensuring day-based stats stay accurate.
- The widget supports `.systemSmall`, `.systemMedium`, and `.systemLarge` families and automatically switches between “configured” and “setup required” states.
- iOS 17’s `contentMarginsDisabled()` is used when available so the design can extend edge-to-edge.

## Ideas & Next Steps
- Add localization and currency formatting based on the user’s locale.
- Support multiple concurrent bonds or milestones.
- Expose in-app notifications when approaching completion or when data becomes stale.
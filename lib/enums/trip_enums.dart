// Based on backend-enums-diagram.pdf

enum TripStatus { draft, planned, active, completed, cancelled }

enum TripRole { owner, editor, viewer }

enum ActivityType { dining, transit, flight, hotel, shopping, activities, tour, other }

enum AttachmentType { photo, ticket, receipt, document }

enum NotificationType { reminder, tripUpdate, budgetAlert, invite }

// Used by ItineraryItem
enum ItineraryStatus { planned, inProgress, completed, cancelled }

// Used by Expense — broad category grouping (personal / travel / other)
enum ExpenseCategory { personal, travel, other }

// Used by Expense — specific spending type
enum ExpenseType { dining, transit, shopping, activities, transport, hotel, flight, other }

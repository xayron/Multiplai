# Widgets Directory Structure

This directory contains all the UI widgets organized by component for better maintainability and separation of concerns.

## 📁 Directory Structure

```
lib/widgets/
├── index.dart                    # Main export file
├── README.md                     # This file
├── webview.dart                  # Core webview widget
├── cache_manager.dart            # Core cache management widget
├── home_page/                    # Home page component
│   ├── index.dart
│   └── home_page.dart
├── sidebar/                      # Sidebar component
│   ├── index.dart
│   └── sidebar.dart
├── hamburger_menu/               # Hamburger menu component
│   ├── index.dart
│   └── hamburger_menu.dart
├── content_area/                 # Content area component
│   ├── index.dart
│   └── content_area.dart
├── mobile_layout/                # Mobile layout components
│   ├── index.dart
│   ├── mobile_layout.dart
│   └── mobile_app_bar.dart
└── desktop_layout/               # Desktop layout components
    ├── index.dart
    └── desktop_layout.dart
```

## 🎯 Component Overview

### **Core Widgets**
- `webview.dart` - Webview widget for displaying AI services
- `cache_manager.dart` - Cache management functionality

### **Home Page Component**
- Main application page with responsive layout
- Handles mobile/desktop layout switching
- Manages webview controllers and state

### **Sidebar Component**
- Desktop sidebar with AI service icons
- Service selection functionality
- Loading and error states

### **Hamburger Menu Component**
- Mobile navigation menu
- Service list with icons and names
- Drawer-style interface

### **Content Area Component**
- Main content display area
- Webview management
- Loading and error states

### **Mobile Layout Components**
- `mobile_layout.dart` - Mobile layout structure
- `mobile_app_bar.dart` - Mobile app bar with hamburger menu

### **Desktop Layout Components**
- `desktop_layout.dart` - Desktop layout with sidebar

## 🔧 Usage

### **Importing Components**
```dart
// Import all widgets (recommended)
import 'package:multiplai/widgets/index.dart';

// Or import specific component (if needed)
import 'package:multiplai/widgets/home_page/home_page.dart';
```

### **Component Dependencies**
- `home_page` depends on `mobile_layout`, `desktop_layout`, and `hamburger_menu`
- `mobile_layout` depends on `mobile_app_bar` and `content_area`
- `desktop_layout` depends on `sidebar` and `content_area`
- All components depend on `webview` for content display

## 🚀 Benefits

1. **Better Organization**: Related widgets are grouped together
2. **Easier Maintenance**: Each component has its own folder
3. **Clear Dependencies**: Import paths show component relationships
4. **Scalability**: Easy to add new components or modify existing ones
5. **Reusability**: Components can be easily reused or tested independently

## 📝 Adding New Components

1. Create a new folder for the component
2. Add the main widget file
3. Create an `index.dart` file to export the widget
4. Update the main `index.dart` to export the new component
5. Update any dependent components with new import paths 
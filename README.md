# MultiplAI

A Flutter desktop application that provides a unified interface for accessing multiple AI chat services through embedded webviews. MultiplAI allows you to seamlessly switch between popular AI platforms like ChatGPT, Gemini, Claude, and many others without opening multiple browser tabs.

## Features

- **Multi-Service Support**: Access 14+ AI chat services including:
  - ChatGPT (OpenAI)
  - Gemini (Google)
  - Claude (Anthropic)
  - Grok (xAI)
  - Perplexity AI
  - Microsoft Copilot
  - Qwen
  - DeepSeek
  - Le Chat (Mistral AI)
  - HuggingChat
  - Kimi AI
  - OpenRouter
  - T3 Chat
  - And more...

- **Seamless Switching**: Quick navigation between different AI services using the sidebar
- **Persistent Sessions**: Each service maintains its own session and cache
- **Cross-Platform**: Available on Windows, macOS, and Linux
- **Modern UI**: Material Design3h light/dark theme support
- **Cache Management**: Built-in cache management for each service
- **Responsive Design**: Optimized for desktop usage

## Screenshots

*[Screenshots would be added here]*

## Architecture

The application is built using Flutter with the BLoC (Business Logic Component) pattern for state management:

### Core Components

- **LLMBloc**: Manages the state of AI services and their loading states
- **Webview Widget**: Embedded webview for each AI service with URL bar and controls
- **Sidebar**: Navigation panel with service icons for quick switching
- **Cache Service**: Handles webview cache management for each service

### Project Structure

```
lib/
├── blocs/           # State management (BLoC pattern)
│   ├── llm_bloc.dart
│   ├── llm_event.dart
│   └── llm_state.dart
├── models/          # Data models
│   └── llm_service.dart
├── services/        # Business logic services
│   └── cache_service.dart
├── widgets/         # UI components
│   ├── cache_manager.dart
│   ├── home_page.dart
│   ├── sidebar.dart
│   └── webview.dart
└── main.dart        # Application entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (3.8 or higher)
- Dart SDK
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/multiplai.git
   cd multiplai
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run -d windows    # For Windows
   flutter run -d macos      # For macOS
   flutter run -d linux      # For Linux
   ```

### Building for Distribution

#### Windows
```bash
flutter build windows
```

#### macOS
```bash
flutter build macos
```

#### Linux
```bash
flutter build linux
```

## Usage

1. **Launch the application** - MultiplAI will load with a sidebar showing available AI services
2. **Select a service** - Click on any service icon in the sidebar to open it
3. **Navigate between services** - Use the sidebar to switch between different AI platforms
4. **Manage cache** - Each service maintains its own cache for better performance
5. **Reset service** - Use the refresh button in the URL bar to reset a service to its original URL

## Configuration

### Adding New AI Services

To add a new AI service, edit the `assets/llms.json` file:

```json
{
  "name": "Service Name",
  "description": "Service description",
  "url": "https://service-url.com",
  "icon": "https://icon-url.com/icon.png"
}
```

### Customizing the UI

The application uses Material Design 3. You can customize colors and themes in `lib/main.dart`.

## Dependencies

- **flutter_inappwebview**: For embedded webview functionality
- **flutter_bloc**: For state management
- **equatable**: For value equality comparisons
- **path_provider**: For file system access

## Development

### State Management

The application uses the BLoC pattern with the following events and states:

**Events:**
- `LoadLLMServices`: Loads the list of available AI services
- `SelectLLMService`: Selects a specific AI service
- `SetServiceLoading`: Sets loading state for a service

**States:**
- `LLMInitial`: Initial state
- `LLMLoading`: Loading state
- `LLMLoaded`: Services loaded successfully
- `LLMError`: Error state

### Adding Features
1. **New Service**: Add to `assets/llms.json`
2. **New UI Component**: Create in `lib/widgets/`
3. **New Service Logic**: Add to `lib/services/`
4. **State Changes**: Modify BLoC files in `lib/blocs/`

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -mAdd some amazing feature`)
4.Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- The BLoC library maintainers
- All the AI service providers for their APIs and web interfaces

## Support

If you encounter any issues or have questions:
1 Check the [Issues](https://github.com/yourusername/multiplai/issues) page
2. Create a new issue with detailed information
3. Include your operating system and Flutter version

---

**Note**: This application embeds webviews of third-party AI services. Please ensure you comply with the terms of service of each platform you use.

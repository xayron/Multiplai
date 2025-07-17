import 'package:equatable/equatable.dart';
import 'package:multiplai/models/llm_service.dart';

abstract class LLMState extends Equatable {
  const LLMState();

  @override
  List<Object?> get props => [];
}

class LLMInitial extends LLMState {
  const LLMInitial();
}

class LLMLoading extends LLMState {
  const LLMLoading();
}

class LLMLoaded extends LLMState {
  final List<LLMService> services;
  final LLMService? selectedService;
  final Map<String, bool> loadingStates;
  final Map<String, String> webviewUrls;

  const LLMLoaded({
    required this.services,
    this.selectedService,
    required this.loadingStates,
    required this.webviewUrls,
  });

  LLMLoaded copyWith({
    List<LLMService>? services,
    LLMService? selectedService,
    Map<String, bool>? loadingStates,
    Map<String, String>? webviewUrls,
  }) {
    return LLMLoaded(
      services: services ?? this.services,
      selectedService: selectedService ?? this.selectedService,
      loadingStates: loadingStates ?? this.loadingStates,
      webviewUrls: webviewUrls ?? this.webviewUrls,
    );
  }

  @override
  List<Object?> get props => [
    services,
    selectedService,
    loadingStates,
    webviewUrls,
  ];
}

class LLMError extends LLMState {
  final String message;

  const LLMError(this.message);

  @override
  List<Object?> get props => [message];
}

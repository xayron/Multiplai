import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplai/blocs/llm_event.dart';
import 'package:multiplai/blocs/llm_state.dart';
import 'package:multiplai/models/llm_service.dart';

class LLMBloc extends Bloc<LLMEvent, LLMState> {
  LLMBloc() : super(const LLMInitial()) {
    on<LoadLLMServices>(_onLoadLLMServices);
    on<SelectLLMService>(_onSelectLLMService);
    on<SetServiceLoading>(_onSetServiceLoading);
  }

  Future<void> _onLoadLLMServices(
    LoadLLMServices event,
    Emitter<LLMState> emit,
  ) async {
    emit(const LLMLoading());

    try {
      final String response = await rootBundle.loadString('assets/llms.json');
      final List<dynamic> data = json.decode(response);
      final List<LLMService> services = data
          .map((json) => LLMService.fromJson(json))
          .toList();

      final Map<String, bool> loadingStates = {
        for (var service in services) service.name: false,
      };

      final Map<String, String> webviewUrls = {
        for (var service in services) service.name: service.url,
      };

      emit(
        LLMLoaded(
          services: services,
          loadingStates: loadingStates,
          webviewUrls: webviewUrls,
        ),
      );
    } catch (e) {
      emit(LLMError('Failed to load LLM services: $e'));
    }
  }

  Future<void> _onSelectLLMService(
    SelectLLMService event,
    Emitter<LLMState> emit,
  ) async {
    if (state is LLMLoaded) {
      final currentState = state as LLMLoaded;

      // Set loading state for the selected service
      final updatedLoadingStates = Map<String, bool>.from(
        currentState.loadingStates,
      );
      updatedLoadingStates[event.service.name] = true;

      emit(
        currentState.copyWith(
          selectedService: event.service,
          loadingStates: updatedLoadingStates,
        ),
      );

      // Simulate loading time for first-time creation
      await Future.delayed(const Duration(milliseconds: 800));

      // Check if the event handler is still active before emitting
      if (!emit.isDone) {
        if (state is LLMLoaded) {
          final currentState = state as LLMLoaded;
          final updatedLoadingStates = Map<String, bool>.from(
            currentState.loadingStates,
          );
          updatedLoadingStates[event.service.name] = false;

          emit(currentState.copyWith(loadingStates: updatedLoadingStates));
        }
      }
    }
  }

  void _onSetServiceLoading(SetServiceLoading event, Emitter<LLMState> emit) {
    if (state is LLMLoaded) {
      final currentState = state as LLMLoaded;
      final updatedLoadingStates = Map<String, bool>.from(
        currentState.loadingStates,
      );
      updatedLoadingStates[event.serviceName] = event.isLoading;

      emit(currentState.copyWith(loadingStates: updatedLoadingStates));
    }
  }
}

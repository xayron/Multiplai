import 'package:equatable/equatable.dart';
import 'package:multiplai/models/llm_service.dart';

abstract class LLMEvent extends Equatable {
  const LLMEvent();

  @override
  List<Object?> get props => [];
}

class LoadLLMServices extends LLMEvent {
  const LoadLLMServices();
}

class SelectLLMService extends LLMEvent {
  final LLMService service;

  const SelectLLMService(this.service);

  @override
  List<Object?> get props => [service];
}

class SetServiceLoading extends LLMEvent {
  final String serviceName;
  final bool isLoading;

  const SetServiceLoading(this.serviceName, this.isLoading);

  @override
  List<Object?> get props => [serviceName, isLoading];
}

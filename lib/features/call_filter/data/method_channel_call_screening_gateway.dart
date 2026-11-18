import 'dart:convert';

import 'package:call_filter/core/errors/app_exception.dart';
import 'package:call_filter/features/call_filter/domain/call_screening_gateway.dart';
import 'package:call_filter/features/call_filter/domain/platform_capabilities.dart';
import 'package:call_filter/features/call_filter/domain/platform_filter_snapshot.dart';
import 'package:flutter/services.dart';

class MethodChannelCallScreeningGateway implements CallScreeningGateway {
  const MethodChannelCallScreeningGateway();

  static const MethodChannel _channel = MethodChannel('call_filter/platform');

  @override
  Future<PlatformCapabilities> getCapabilities() async {
    try {
      final result = await _channel.invokeMapMethod<String, Object?>(
        'getCapabilities',
      );
      if (result == null) {
        return const PlatformCapabilities.unsupported('native (no response)');
      }
      return PlatformCapabilities(
        platformName: result['platform'] as String? ?? 'native',
        callScreening: _state(result['callScreening']),
        callerDisplayName: _state(result['callerDisplayName']),
        callDirectory: _state(result['callDirectory']),
        numberBlocking: _state(result['numberBlocking']),
        details: result['details'] as String? ?? '',
      );
    } on MissingPluginException catch (error) {
      throw PlatformIntegrationException(
        'The native CallFilter channel is not registered.',
        cause: error,
      );
    } on PlatformException catch (error) {
      throw PlatformIntegrationException(
        error.message ?? 'Could not query platform capabilities.',
        cause: error,
      );
    }
  }

  @override
  Future<void> syncSnapshot(PlatformFilterSnapshot snapshot) async {
    try {
      final accepted = await _channel.invokeMethod<bool>(
        'syncSnapshot',
        jsonEncode(snapshot.toJson()),
      );
      if (accepted != true) {
        throw const PlatformIntegrationException(
          'The native layer rejected the filter snapshot.',
        );
      }
    } on MissingPluginException catch (error) {
      throw PlatformIntegrationException(
        'The native CallFilter channel is not registered.',
        cause: error,
      );
    } on PlatformException catch (error) {
      throw PlatformIntegrationException(
        error.message ?? 'Could not sync the filter snapshot.',
        cause: error,
      );
    }
  }

  @override
  Future<void> openSystemSettings() async {
    try {
      await _channel.invokeMethod<void>('openSystemSettings');
    } on MissingPluginException catch (error) {
      throw PlatformIntegrationException(
        'The native CallFilter channel is not registered.',
        cause: error,
      );
    } on PlatformException catch (error) {
      throw PlatformIntegrationException(
        error.message ?? 'Could not open system settings.',
        cause: error,
      );
    }
  }

  PlatformCapabilityState _state(Object? raw) {
    return switch (raw) {
      'available' => PlatformCapabilityState.available,
      'limited' => PlatformCapabilityState.limited,
      _ => PlatformCapabilityState.unavailable,
    };
  }
}

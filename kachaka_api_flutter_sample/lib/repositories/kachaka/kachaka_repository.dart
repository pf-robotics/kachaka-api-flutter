import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:grpc/grpc.dart';
// webとmobileで、grpc_webとgrpcのようにパッケージが分かれていて、
// それぞれのプラットフォームでしか動かないlibraryに依存しているため、
// if (dart.library.io)のように書き、余分なpackageをimportしないようにする
import 'package:kachaka_api_flutter_sample/repositories/grpc/grpc_channel.dart'
    if (dart.library.io) 'package:kachaka_api_flutter_sample/repositories/grpc/grpc_channel_mobile_impl.dart'
    if (dart.library.html) 'package:kachaka_api_flutter_sample/repositories/grpc/grpc_channel_web_impl.dart';
import 'package:grpc/grpc_connection_interface.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kachaka_api/kachaka_api.dart';
import 'package:kachaka_api_flutter_sample/model/connection_options.dart';
import 'package:uuid/uuid.dart';

final kachakaRepositoryProvider = Provider((ref) => KachakaRepository());

class KachakaRepository {
  static const _zeroCursor = Int64.ZERO;

  ClientChannelBase? _channel;
  KachakaApiClient? _client;

  String? _channelId;
  String? get channelId => _channelId;

  CallOptions get _pollingRequestOptions {
    return CallOptions(timeout: const Duration(seconds: 60));
  }

  CallOptions get _actionRequestOptions {
    return CallOptions(timeout: const Duration(seconds: 5));
  }

  void initializeChannel(ConnectionOptions options) {
    _channel = kIsWeb
        ? getChannelForWeb(
            Uri.parse('http://${options.ipAddress}:${options.port}'))
        : getChannelForMobile(
            options.ipAddress,
            port: options.port,
            options: const ChannelOptions(
              credentials: ChannelCredentials.insecure(),
            ),
          );
    _client = KachakaApiClient(_channel!);
    _channelId = const Uuid().v4();
  }

  Future<void> terminate() async {
    await _channel?.terminate();
    _channel = null;
    _client = null;
  }

  /// ------------------
  /// Get methods based on cursor
  /// ------------------
  Int64 _getLocationsCursor = _zeroCursor;
  Future<GetLocationsResponse> getLocations() async {
    final res = await _client!.getLocations(
      GetRequest(metadata: Metadata(cursor: _getLocationsCursor)),
      options: _pollingRequestOptions,
    );
    _getLocationsCursor = res.metadata.cursor;
    return res;
  }

  Int64 _getShelvesCursor = _zeroCursor;
  Future<GetShelvesResponse> getShelves() async {
    final res = await _client!.getShelves(
      GetRequest(metadata: Metadata(cursor: _getShelvesCursor)),
      options: _pollingRequestOptions,
    );
    _getShelvesCursor = res.metadata.cursor;
    return res;
  }

  Int64 _getPngMapCursor = _zeroCursor;
  Future<GetPngMapResponse> getPngMap() async {
    final res = await _client!.getPngMap(
      GetRequest(metadata: Metadata(cursor: _getPngMapCursor)),
      options: _pollingRequestOptions,
    );
    _getPngMapCursor = res.metadata.cursor;
    return res;
  }

  Int64 _getRobotPoseCursor = _zeroCursor;
  Future<GetRobotPoseResponse> getRobotPose() async {
    final res = await _client!.getRobotPose(
      GetRequest(metadata: Metadata(cursor: _getRobotPoseCursor)),
      options: _pollingRequestOptions,
    );
    _getRobotPoseCursor = res.metadata.cursor;
    return res;
  }

  /// ------------------
  /// Actions
  /// ------------------
  Future<StartCommandResponse> startAction(
    Command command, {
    bool? cancelAll,
    String? ttsOnSuccess,
    String? title,
  }) async {
    final res = await _client!.startCommand(
      StartCommandRequest(
        command: command,
        cancelAll: cancelAll,
        ttsOnSuccess: ttsOnSuccess,
        title: title,
      ),
      options: _actionRequestOptions,
    );
    return res;
  }
}

import 'package:grpc/grpc_connection_interface.dart';

ClientChannelBase getChannelForMobile(
  Object host, {
  int port = 443,
  ChannelOptions options = const ChannelOptions(),
  void Function()? channelShutdownHandler,
}) =>
    ClientChannel(
      host,
      port: port,
      options: options,
      channelShutdownHandler: channelShutdownHandler,
    );

ClientChannelBase getChannelForWeb(
  Uri uri, {
  void Function()? channelShutdownHandler,
}) =>
    throw UnimplementedError('getChannelForWeb');

import 'dart:io';

import 'package:biometric_storage/biometric_storage.dart';
import 'package:blockchain_wallet/common/util/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StringBufferWrapper with ChangeNotifier {
  final StringBuffer _buffer = StringBuffer();

  void writeln(String line) {
    _buffer.writeln(line);
    notifyListeners();
  }

  @override
  String toString() => _buffer.toString();
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  final String baseName = 'default';

  static final _authStorageInitOptions = StorageFileInitOptions();
  static final _customPromptInitOptions = StorageFileInitOptions(
    androidBiometricOnly: false,
    authenticationValidityDurationSeconds: 5,
  );

  BiometricStorageFile? _authStorage;
  BiometricStorageFile? _storage;
  BiometricStorageFile? _customPrompt;

  final TextEditingController _writeController =
  TextEditingController(text: 'Lorem Ipsum');

  @override
  void initState() {
    super.initState();
    // _checkAuthenticate();
  }


  Future<CanAuthenticateResponse> _checkAuthenticate(
      StorageFileInitOptions? options,
      ) async {
    final response = await BiometricStorage().canAuthenticate();
    logger.d('checked if authentication was possible: $response');
    return response;
  }

  void _logChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        children: [
          const Text('Methods:'),
          ElevatedButton(
            child: const Text('init'),
            onPressed: () async {
              logger.d('Initializing $baseName');
              final authStorageSupport =
              await _checkAuthenticate(_authStorageInitOptions);
              if (authStorageSupport == CanAuthenticateResponse.unsupported) {
                logger.d(
                    'Unable to use authenticate. Unable to get storage.');
                return;
              }
              final supportsAuthenticated = authStorageSupport ==
                  CanAuthenticateResponse.success ||
                  authStorageSupport == CanAuthenticateResponse.statusUnknown;
              if (supportsAuthenticated) {
                _authStorage = await BiometricStorage().getStorage(
                  '${baseName}_authenticated',
                  options: _authStorageInitOptions,
                );
              }
              _storage = await BiometricStorage()
                  .getStorage('${baseName}_unauthenticated',
                  options: StorageFileInitOptions(
                    authenticationRequired: false,
                  ));
              final supportsCustomPrompt =
              await _checkAuthenticate(_customPromptInitOptions);
              if (supportsCustomPrompt == CanAuthenticateResponse.success) {
                _customPrompt = await BiometricStorage()
                    .getStorage('${baseName}_customPrompt',
                    options: _customPromptInitOptions,
                    promptInfo: const PromptInfo(
                      iosPromptInfo: IosPromptInfo(
                        saveTitle: 'Custom save title',
                        accessTitle: 'Custom access title.',
                      ),
                      androidPromptInfo: AndroidPromptInfo(
                        title: 'Custom title',
                        subtitle: 'Custom subtitle',
                        description: 'Custom description',
                        negativeButton: 'Nope!',
                      ),
                    ));
              }
              setState(() {});
              logger.d('initiailzed $baseName');
            },
          ),
          ...?_appArmorButton(),
          ...(_authStorage == null
              ? []
              : [
            const Text('Biometric Authentication',
                style: TextStyle(fontWeight: FontWeight.bold)),
            StorageActions(
                storageFile: _authStorage!,
                writeController: _writeController),
            const Divider(),
          ]),
          ...?(_storage == null
              ? null
              : [
            const Text('Unauthenticated',
                style: TextStyle(fontWeight: FontWeight.bold)),
            StorageActions(
                storageFile: _storage!,
                writeController: _writeController),
            const Divider(),
          ]),
          ...?(_customPrompt == null
              ? null
              : [
            const Text('Custom Prompts w/ 5s auth validity',
                style: TextStyle(fontWeight: FontWeight.bold)),
            StorageActions(
                storageFile: _customPrompt!,
                writeController: _writeController),
            const Divider(),
          ]),
          const Divider(),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Example text to write',
            ),
            controller: _writeController,
          ),
        ],
      ),
    );
  }

  List<Widget>? _appArmorButton() => kIsWeb || !Platform.isLinux
      ? null
      : [
    ElevatedButton(
      child: const Text('Check App Armor'),
      onPressed: () async {
        if (await BiometricStorage().linuxCheckAppArmorError()) {
          logger.d('Got an error! User has to authorize us to '
              'use secret service.');
          logger.d(
              'Run: `snap connect biometric-storage-example:password-manager-service`');
        } else {
          logger.d('all good.');
        }
      },
    )
  ];
}

class StorageActions extends StatelessWidget {
  const StorageActions({
    super.key,
    required this.storageFile,
    required this.writeController,
  });

  final BiometricStorageFile storageFile;
  final TextEditingController writeController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        ElevatedButton(
          child: const Text('read'),
          onPressed: () async {
            logger.d('reading from ${storageFile.name}');
            try {
              final result = await storageFile.read();
              logger.d('read: {$result}');
            } on AuthException catch (e) {
              if (e.code == AuthExceptionCode.userCanceled) {
                logger.d('User canceled.');
                return;
              }
              rethrow;
            }
          },
        ),
        ElevatedButton(
          child: const Text('write'),
          onPressed: () async {
            logger.d('Going to write...');
            try {
              await storageFile
                  .write(' [${DateTime.now()}] ${writeController.text}');
              logger.d('Written content.');
            } on AuthException catch (e) {
              if (e.code == AuthExceptionCode.userCanceled) {
                logger.d('User canceled.');
                return;
              }
              rethrow;
            }
          },
        ),
        ElevatedButton(
          child: const Text('delete'),
          onPressed: () async {
            logger.d('deleting...');
            await storageFile.delete();
            logger.d('Deleted.');
          },
        ),
      ],
    );
  }
}
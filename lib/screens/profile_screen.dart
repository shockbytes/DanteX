import 'dart:io';

import 'package:dantex/providers/auth.dart';
import 'package:dantex/providers/book.dart';
import 'package:dantex/providers/firebase.dart';
import 'package:dantex/providers/logger.dart';
import 'package:dantex/widgets/shared/dante_loading_indicator.dart';
import 'package:dantex/widgets/shared/user_avatar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  static String get routeName => 'profile';
  static String get routeLocation => '/profile';

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _userNameTextController = TextEditingController();
  bool _uploadingProfileImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('profile.profile').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: RefreshIndicator(
          onRefresh: () async =>
              ref.read(firebaseAuthProvider).currentUser?.reload(),
          child: ref.watch(userProvider).when(
                data: (user) {
                  if (user == null) {
                    return const SizedBox.shrink();
                  }

                  setState(
                    () => _userNameTextController.text = user.displayName ?? '',
                  );

                  return ListView(
                    children: [
                      GestureDetector(
                        onTap: _uploadingProfileImage ? null : _updatePhotoUrl,
                        child: _uploadingProfileImage
                            ? const Center(
                                child: SizedBox(
                                  height: 160,
                                  width: 160,
                                  child: Padding(
                                    padding: EdgeInsets.all(40),
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              )
                            : const UserAvatar(size: 160),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _userNameTextController,
                        decoration: InputDecoration(
                          labelText: 'profile.name'.tr(),
                        ),
                        onSubmitted: (newDisplayName) async {
                          await _updateDisplayName(
                            user.displayName ?? '',
                            newDisplayName,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      if (!user.emailVerified) ...[
                        Card.filled(
                          color: Theme.of(context).colorScheme.tertiary,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              'profile.email_not_verified',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onTertiary,
                              ),
                            ).tr(),
                          ),
                        ),
                        Row(
                          children: [
                            const Spacer(),
                            OutlinedButton(
                              onPressed: () async => ref
                                  .read(firebaseAuthProvider)
                                  .currentUser
                                  ?.sendEmailVerification(),
                              child: const Text('profile.verify_email').tr(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ],
                  );
                },
                error: (e, s) {
                  ref
                      .read(loggerProvider)
                      .e('Error loading user', error: e, stackTrace: s);
                  return const SizedBox.shrink();
                },
                loading: () => const Center(child: DanteLoadingIndicator()),
              ),
        ),
      ),
    );
  }

  Future<void> _updatePhotoUrl() async {
    setState(() => _uploadingProfileImage = true);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      try {
        final image = File(pickedFile.path);
        final url = await ref
            .read(userImageRepositoryProvider)
            .uploadCustomUserImage(image);
        await ref.read(firebaseAuthProvider).currentUser?.updatePhotoURL(url);
        // await ref.read(firebaseAuthProvider).currentUser?.reload();
      } on Exception catch (e, s) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('profile.error_updating_image').tr(),
            ),
          );
          ref
              .read(loggerProvider)
              .e('Error updating photo URL', error: e, stackTrace: s);
        }
      }
    }
    setState(() => _uploadingProfileImage = false);
  }

  Future<void> _updateDisplayName(
    String currentDisplayName,
    String newDisplayName,
  ) async {
    if (newDisplayName.isEmpty) {
      return;
    }

    if (currentDisplayName == newDisplayName) {
      return;
    }

    try {
      await ref.read(firebaseAuthProvider).currentUser?.updateDisplayName(
            newDisplayName,
          );
    } on Exception catch (e, s) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('profile.error_updating_name').tr(),
          ),
        );
        ref
            .read(loggerProvider)
            .e('Error updating display name', error: e, stackTrace: s);
      }
    }
  }
}

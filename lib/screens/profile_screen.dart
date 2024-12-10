import 'dart:io';

import 'package:dantex/logger/event.dart';
import 'package:dantex/providers/auth.dart';
import 'package:dantex/providers/firebase.dart';
import 'package:dantex/providers/repository.dart';
import 'package:dantex/providers/service.dart';
import 'package:dantex/widgets/profile/change_password_button.dart';
import 'package:dantex/widgets/profile/delete_account_button.dart';
import 'package:dantex/widgets/profile/link_with_email_button.dart';
import 'package:dantex/widgets/profile/link_with_google_button.dart';
import 'package:dantex/widgets/profile/unlink_from_email_button.dart';
import 'package:dantex/widgets/profile/unlink_from_google_button.dart';
import 'package:dantex/widgets/shared/dante_loading_indicator.dart';
import 'package:dantex/widgets/shared/sign_out_button.dart';
import 'package:dantex/widgets/shared/user_avatar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  static String get routeName => 'profile';
  static String get routeLocation => '/$routeName';

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
                  final userEmail = user?.email;

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
                      const SizedBox(height: 8),
                      const Text('authentication.account_type').tr(),
                      if (user.isAnonymous || user.isUnknownUser) ...[
                        Row(
                          children: [
                            const Icon(Icons.person_outline),
                            const SizedBox(width: 8),
                            const Text('authentication.anonymous_user').tr(),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      if (user.isMailUser) ...[
                        Row(
                          children: [
                            const Icon(Icons.mail_outline),
                            const SizedBox(width: 8),
                            Expanded(
                              child:
                                  const Text('authentication.email_user').tr(),
                            ),
                            const UnlinkFromEmailButton(),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (userEmail != null) ...[
                          ChangePasswordButton(userEmail: userEmail),
                          const SizedBox(height: 8),
                        ],
                      ],
                      if (user.isGoogleUser) ...[
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/google_logo.png',
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child:
                                  const Text('authentication.google_user').tr(),
                            ),
                            const UnlinkFromGoogleButton(),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      if (!user.isGoogleUser) ...[
                        const LinkWithGoogleButton(),
                        const SizedBox(height: 8),
                      ],
                      if (!user.isMailUser && !user.isGoogleUser) ...[
                        const LinkWithEmailButton(),
                        const SizedBox(height: 8),
                      ],
                      const SignOutButton(),
                      const SizedBox(height: 8),
                      DeleteAccountButton(user: user),
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
        ref.read(loggerProvider).trackEvent(DanteEvent.userImageChanged);
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
      ref.read(loggerProvider).trackEvent(DanteEvent.userNameChanged);
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

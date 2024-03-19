abstract class DanteTrackingEvent {
  final String name;
  final Map<String, Object?> props;

  DanteTrackingEvent(this.name, {this.props = const {}});
}

class AuthenticationSource {
  final String name;

  AuthenticationSource(this.name);
}

class LoginSource {
  final String name;

  LoginSource(this.name);
}

class OpenTermsOfServices extends DanteTrackingEvent {
  OpenTermsOfServices() : super('open_terms_of_services');
}

class ResetPasswordSuccess extends DanteTrackingEvent {
  ResetPasswordSuccess() : super('reset_password_success');
}

class ResetPasswordFailed extends DanteTrackingEvent {
  ResetPasswordFailed() : super('reset_password_failed');
}

class ReportLoginProblem extends DanteTrackingEvent {
  ReportLoginProblem() : super('report_login_problem');
}

class OpenLogin extends DanteTrackingEvent {
  OpenLogin(LoginSource source)
      : super('open_login', props: {'source': source.name});
}

class Login extends DanteTrackingEvent {
  Login(AuthenticationSource source)
      : super('app_login', props: {'source': source.name});
}

class SignUp extends DanteTrackingEvent {
  SignUp(AuthenticationSource source)
      : super('app_signup', props: {'source': source.name});
}

class Logout extends DanteTrackingEvent {
  Logout(AuthenticationSource source)
      : super('app_logout', props: {'source': source.name});
}

class AnonymousUpgrade extends DanteTrackingEvent {
  AnonymousUpgrade() : super('anonymous_upgrade');
}

class UpdateMailPasswordSuccess extends DanteTrackingEvent {
  UpdateMailPasswordSuccess() : super('update_mail_password_success');
}

class UpdateMailPasswordFailure extends DanteTrackingEvent {
  UpdateMailPasswordFailure() : super('update_mail_password_failure');
}

class UserNameChanged extends DanteTrackingEvent {
  UserNameChanged() : super('user_name_changed');
}

class UserImageChanged extends DanteTrackingEvent {
  UserImageChanged() : super('user_image_changed');
}

class BackupMadeEvent extends DanteTrackingEvent {
  BackupMadeEvent(String backupProvider)
      : super(
          'backup_made',
          props: {'backup_provider': backupProvider},
        );
}

class InterestedInOnlineStorageEvent extends DanteTrackingEvent {
  InterestedInOnlineStorageEvent() : super('interested_in_online_storage');
}

class StartImport extends DanteTrackingEvent {
  StartImport(String importer)
      : super(
          'start_import',
          props: {'importer_name': importer},
        );
}

class OpenBackupFile extends DanteTrackingEvent {
  OpenBackupFile(String providerAcronym)
      : super(
          'open_backup_file',
          props: {'backup_provider': providerAcronym},
        );
}

class TrackingStateChanged extends DanteTrackingEvent {
  TrackingStateChanged(bool state)
      : super('tracking_state_changed', props: {'state': state});
}

class PickRandomBook extends DanteTrackingEvent {
  PickRandomBook(int booksInBacklog)
      : super(
          'pick_random_book',
          props: {'backlog_count': booksInBacklog},
        );
}

class AddSuggestionToWishlist extends DanteTrackingEvent {
  AddSuggestionToWishlist(
    String suggestionId,
    String bookTitle,
    String suggester,
  ) : super(
          'add_suggestion_to_wishlist',
          props: {
            'suggestion_id': suggestionId,
            'suggestion_book': bookTitle,
            'suggestion_suggester': suggester,
          },
        );
}

class SuggestBook extends DanteTrackingEvent {
  SuggestBook(String title)
      : super('suggest_book', props: {'book_title': title});
}

class OpenAdFreeMediumArticle extends DanteTrackingEvent {
  OpenAdFreeMediumArticle() : super('open_ad_free_medium_article');
}

class DisableRandomBookInteraction extends DanteTrackingEvent {
  DisableRandomBookInteraction() : super('disable_random_book_interaction');
}

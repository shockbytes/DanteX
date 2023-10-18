import 'package:cached_network_image/cached_network_image.dart';
import 'package:dantex/src/util/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContributorsPage extends StatelessWidget {
  List<_ContributionType> get _contributors => [
        _Contributor(
          handle: '@shockbytes',
          imageUrl: 'https://avatars.githubusercontent.com/u/12248553?v=4',
          profileUrl: 'https://github.com/shockbytes',
        ),
        _Contributor(
          handle: '@lockierichter',
          imageUrl: 'https://avatars.githubusercontent.com/u/26178557?v=4',
          profileUrl: 'https://github.com/lockierichter',
        ),
        _ContributorInvite(),
      ];

  const ContributorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 32.0,
            horizontal: 16.0,
          ),
          child: Column(
            children: [
              Expanded(
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  children: _contributors
                      .map(
                        (contributor) => _ContributorCard(contributor),
                      )
                      .toList(),
                ),
              ),
              SvgPicture.asset(
                'assets/images/shockbytes.svg',
                height: 64,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurfaceVariant,
                  BlendMode.srcIn,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.settings_about_copyright,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

sealed class _ContributionType {}

class _Contributor extends _ContributionType {
  final String handle;
  final String imageUrl;
  final String profileUrl;

  _Contributor({
    required this.handle,
    required this.imageUrl,
    required this.profileUrl,
  });
}

class _ContributorInvite extends _ContributionType {}

class _ContributorCard extends StatelessWidget {
  final _ContributionType _contribution;

  const _ContributorCard(
    this._contribution,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline,
          width: 0.5,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: switch (_contribution) {
        _Contributor() => _buildContributor(
            context,
            _contribution as _Contributor,
          ),
        _ContributorInvite() => _buildContributionInvite(context),
      },
    );
  }

  InkWell _buildContributor(BuildContext context, _Contributor contributor) {
    return InkWell(
      onTap: () async => tryLaunchUrl(contributor.profileUrl),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            child: CircleAvatar(
              maxRadius: double.infinity,
              backgroundImage: CachedNetworkImageProvider(contributor.imageUrl),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            contributor.handle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildContributionInvite(BuildContext context) {
    return InkWell(
      onTap: () async => tryLaunchUrl(
        'https://discord.com/channels/824694597728993390/1037365721363136572',
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!
                  .settings_about_contributor_invite_title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.of(context)!
                  .settings_about_contributor_invite_description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

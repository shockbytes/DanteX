import 'package:cached_network_image/cached_network_image.dart';
import 'package:dantex/util/url.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContributorsScreen extends StatelessWidget {
  const ContributorsScreen({super.key});

  static String routeName = 'contributors';
  static String routeLocation = routeName;
  static String navigationUrl = '/settings/$routeLocation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'contributors.title'.tr(),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  children: _contributors
                      .map(
                        _ContributorCard.new,
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
                'contributors.about.copyright'.tr(),
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

sealed class _ContributionType {}

class _Contributor extends _ContributionType {
  _Contributor({
    required this.handle,
    required this.imageUrl,
    required this.profileUrl,
  });
  final String handle;
  final String imageUrl;
  final String profileUrl;
}

class _ContributorInvite extends _ContributionType {}

class _ContributorCard extends StatelessWidget {
  const _ContributorCard(
    this._contribution,
  );
  final _ContributionType _contribution;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: switch (_contribution) {
        _Contributor() => _buildContributor(
            context,
            _contribution,
          ),
        _ContributorInvite() => _buildContributionInvite(context),
      },
    );
  }

  InkWell _buildContributor(BuildContext context, _Contributor contributor) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
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
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'contributors.about.contributor_invite_title'.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'contributors.about.contributor_invite_description'.tr(),
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

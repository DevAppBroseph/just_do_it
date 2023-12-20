import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class FirebaseDynamicLinksService {
  // final IOSParameters iosParams = const IOSParameters(
  //   bundleId: 'dev.broseph.justDoIt',
  //   minimumVersion: '13.0',
  //   appStoreId: '1669574224',
  // );
  final IOSParameters iosParams = const IOSParameters(
    bundleId: 'aigam.com.jobyfine',
    minimumVersion: '1.0.0',
    appStoreId: '6466744212',
  );

  Future<String>? share(int refCode) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://justdoit.page.link',
      link: Uri.parse('https://justdoit.page.link/referal/?ref_code=$refCode'),
      googleAnalyticsParameters: const GoogleAnalyticsParameters(),
      androidParameters:
          const AndroidParameters(packageName: 'dev.broseph.justDoIt'),
      iosParameters: iosParams,
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(parameters);
    String? linkApp = dynamicLink.toString();
    return linkApp;
  }

  Future<String>? shareUserProfile(int id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://justdoit.page.link',
      link: Uri.parse('https://justdoit.page.link/referal/?user_profile=$id'),
      googleAnalyticsParameters: const GoogleAnalyticsParameters(),
      androidParameters:
          const AndroidParameters(packageName: 'dev.broseph.justDoIt'),
      iosParameters: iosParams,
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(parameters);
    String linkApp = dynamicLink.toString();
    return linkApp;
  }

  Future<String>? shareUserTask(int id) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://justdoit.page.link',
      link: Uri.parse('https://justdoit.page.link/referal/?task_id=$id'),
      googleAnalyticsParameters: const GoogleAnalyticsParameters(),
      androidParameters:
          const AndroidParameters(packageName: 'dev.broseph.justDoIt'),
      iosParameters: iosParams,
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(parameters);
    String linkApp = dynamicLink.toString();
    return linkApp;
  }
}

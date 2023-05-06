import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class FirebaseDynamicLinksService {
  Future<String>? share(int refCode) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://justdoit.page.link',
      link: Uri.parse('https://justdoit.page.link/referal/?ref_code=$refCode'),
      googleAnalyticsParameters: const GoogleAnalyticsParameters(),
      androidParameters:
          const AndroidParameters(packageName: 'dev.broseph.justDoIt'),
      iosParameters: const IOSParameters(
        bundleId: 'dev.broseph.justDoIt',
        minimumVersion: '13.0',
        appStoreId: '1669574224',
      ),
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
      iosParameters: const IOSParameters(
        bundleId: 'dev.broseph.justDoIt',
        minimumVersion: '13.0',
        appStoreId: '1669574224',
      ),
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
      iosParameters: const IOSParameters(
        bundleId: 'dev.broseph.justDoIt',
        minimumVersion: '13.0',
        appStoreId: '1669574224',
      ),
    );
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(parameters);
    String linkApp = dynamicLink.toString();
    return linkApp;
  }
}

import 'dart:developer';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class FirebaseDynamicLinksService {
  void share(int refCode) async {
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
    String linkApp = dynamicLink.toString();
    log('message $linkApp');
  }
}

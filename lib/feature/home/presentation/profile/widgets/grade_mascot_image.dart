import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/models/levels.dart';
import 'package:just_do_it/models/user_reg.dart';

class GradeMascotImage extends StatelessWidget {
  const GradeMascotImage({super.key,required this.levels,required  this.user,  this.size=30});
  final List<Levels>? levels;
 final UserRegModel? user;
 final double size;
  @override
  Widget build(BuildContext context) {
    if (user!.allbalance! <
        levels![0].mustCoins!) {
      return CachedNetworkImage(
        progressIndicatorBuilder:
            (context, url, progress) {
          return const CupertinoActivityIndicator();
        },
        imageUrl:
        '${levels![0].bwImage}',
        height: size.h,
        width: size.w,
      );
    }else if(user!.allbalance! >=
        levels!.last.mustCoins!){
      return CachedNetworkImage(
        progressIndicatorBuilder:
            (context, url, progress) {
          return const CupertinoActivityIndicator();
        },
        imageUrl:
        '${levels!.last.bwImage}',
        height: size.h,
        width: size.w,
      );
    }
    for (int i = 1;
    i < levels!.length;
    i++) {
        if (user!.allbalance! >=
            levels![i]
                .mustCoins! &&
            user!.allbalance! <
                levels![i + 1]
                    .mustCoins!) {

          return CachedNetworkImage(
            progressIndicatorBuilder:
                (context, url,
                progress) {
              return const CupertinoActivityIndicator();
            },
            imageUrl:
            '${levels![i].image}',
            height: size.h,
            width: size.w,
          );
        }
    }
    return Container();
  }
}

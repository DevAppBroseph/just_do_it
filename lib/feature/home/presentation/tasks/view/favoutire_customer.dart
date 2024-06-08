import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/svg_and_images.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/favourites/bloc_favourites/favourites_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/view_profile.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/item_favourite_user.dart';
import 'package:just_do_it/models/favourites_info.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:just_do_it/widget/back_icon_button.dart';

class FavouriteCustomer extends StatefulWidget {
  String title;

  FavouriteCustomer({
    super.key,
    required this.title,
  });

  @override
  State<FavouriteCustomer> createState() => _FavouriteCustomerState();
}

class _FavouriteCustomerState extends State<FavouriteCustomer> {
  List<FavoriteCustomers>? favouritesPeople;
  @override
  void initState() {
    super.initState();
  }

  Owner? selectOwner;
  FavoriteCustomers? selectfavouritesUser;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavouritesBloc, FavouritesState>(
        builder: (context, state) {
      if (state is FavouritesLoaded) {
        favouritesPeople = state.favourite!.favoriteUsers;
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Scaffold(
            backgroundColor: ColorStyles.greyEAECEE,
            body: Stack(
              children: [
                SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: CustomIconButton(
                                onBackPressed: () {
                                  if (selectOwner != null) {
                                    selectOwner = null;
                                    setState(() {});
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                },
                                icon: SvgImg.arrowRight,
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                widget.title,
                                style: CustomTextStyle.black_22_w700_171716,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Expanded(
                        child: Stack(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height -
                                  20.h -
                                  10.h -
                                  82.h,
                              child: ListView.builder(
                                itemCount: favouritesPeople!.length,
                                padding:
                                    EdgeInsets.only(top: 15.h, bottom: 100.h),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return itemFavouriteUser(
                                    favouritesPeople![index],
                                    (user) {
                                      setState(() {
                                        selectfavouritesUser = user;
                                        if (selectfavouritesUser?.user !=
                                            null) {
                                          getProfile();
                                        }
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                            view(),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
      return Container();
    });
  }

  void getProfile() async {
    final access = BlocProvider.of<ProfileBloc>(context).access;
    final owner =
        await Repository().getRanking(selectfavouritesUser!.user!.id!, access);
    setState(() {
      selectOwner = owner;
    });
  }

  Widget view() {
    if (selectOwner != null) {
      return Scaffold(
          backgroundColor: ColorStyles.greyEAECEE,
          body: ProfileView(owner: selectOwner!));
    }
    return Container();
  }
}

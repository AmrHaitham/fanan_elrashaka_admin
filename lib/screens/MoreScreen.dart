import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_admin/Constants.dart';
import 'package:fanan_elrashaka_admin/helper/actions.dart';
import 'package:fanan_elrashaka_admin/providers/UserData.dart';
import 'package:fanan_elrashaka_admin/screens/AllPationts.dart';
import 'package:fanan_elrashaka_admin/screens/AllUsersScreen.dart';
import 'package:fanan_elrashaka_admin/screens/Finance.dart';
import 'package:fanan_elrashaka_admin/screens/ListAllClinicsSchedule.dart';
import 'package:fanan_elrashaka_admin/screens/ListAllPackages.dart';
import 'package:fanan_elrashaka_admin/screens/ListAllPromoCodes.dart';
import 'package:fanan_elrashaka_admin/screens/ListAllServices.dart';
import 'package:fanan_elrashaka_admin/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_admin/widgets/MoreCard.dart';
import 'package:fanan_elrashaka_admin/widgets/ScreenContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class MoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
        name: LocaleKeys.More.tr(),
        topCenterAction: Container(
          margin:const EdgeInsets.only(left: 15,right: 15,),
          decoration: BoxDecoration(
            color: Constants.mainColor,
            borderRadius:const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 10,
                offset: Offset(0, 4), // changes position of shadow
              ),
            ],
          ),
          child: ListTile(
            leading: SizedBox(
                width: 50,
                height: 50,
                child: Image.asset("assets/dr_image.png")
            ),
            title: Text("Dr.Mohamed Ibrahim"),
            subtitle: Text("System Admin"),
            // trailing: Container(
            //   padding: EdgeInsets.all(5),
            //   width: 35,
            //   height: 35,
            //   decoration:const BoxDecoration(
            //     borderRadius: BorderRadius.all(Radius.circular(5)),
            //     color: Color(0xffe9e5ff)
            //   ),
            //   child: Image.asset("assets/right-arrow_gray.png",color: Constants.secondColor,),
            // ),
          ),
        ),
        topRightaction: InkWell(
          onTap: (){
            if(context.locale.toString()=="en"){
              context.setLocale(Locale("ar"));
            }else {
              context.setLocale(Locale("en"));
            }
          },
          child: Container(
            padding:const EdgeInsets.all(8),
            margin:const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Constants.mainColor,
                borderRadius:const BorderRadius.all(Radius.circular(7))
            ),
            width: 35,
            height: 35,
            child: Center(
              child: Text((context.locale.toString()=="en")?"AR":"EN",style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Constants.secondColor
              ),),
            ),
          ),
        ),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height*0.65,
          padding:const EdgeInsets.only(top: 10),
          child: ListView(
              children: [
                MoreCard(title: "Services",
                    image: "assets/services.png",
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>ListAllServices())
                      );
                    }),
                MoreCard(title: LocaleKeys.ClinicsSchedule.tr(),
                    image: "assets/schedule.png",
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>ListAllSchedule())
                      );
                    }),
                MoreCard(title: LocaleKeys.ClinicsPackages.tr(),
                    image: "assets/package.png",
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>ListAllPackages())
                      );
                    }),
                MoreCard(title: LocaleKeys.PromoCodes.tr(),
                    image: "assets/promo_codes.png",
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) =>ListAllPromoCodes())
                      );
                    }),
                MoreCard(title: "Financial",
                    image: "assets/financial.png",
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Finance(token: context.read<UserData>().token,))
                      );
                    }),
                MoreCard(title: LocaleKeys.AllPatients.tr(),
                    image: "assets/patient.png",
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ListAllPatients())
                      );
                    }),
                MoreCard(title: LocaleKeys.Users.tr(),
                    image: "assets/users.png",
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ListAllUsers())
                      );
                    }),
            InkWell(
              onTap: (){
                AdminActions.logout(context);
              },
              child: ListTile(
                leading: SizedBox(
                    width: 30,
                    height: 30,
                    child: Image.asset("assets/logout.png",color: Colors.red,)
                ),
                title: Text(
                  LocaleKeys.Logout.tr(),
                  style:const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red
                  ),
                ),
              ),
            )
              ],
            ),
          ),
    );
  }
}

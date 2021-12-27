import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/organization/dataModel/is_tutorial_link_data_model.dart';
import 'package:insurance/isModel/organization/is_organization_manager.dart';
import 'package:insurance/resources/app_colors.dart';
import 'package:insurance/resources/app_dimens.dart';
import 'package:insurance/resources/app_strings.dart';
import 'package:insurance/resources/app_styles.dart';
import 'package:insurance/screens/base/base_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class TutorialScreen extends BaseScreen {
  const TutorialScreen({Key? key}) : super(key: key);
  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends BaseScreenState<TutorialScreen> {
  List<ISTutorialLinkDataModel> tutorials=[];
  @override
  void initState() {
    super.initState();
    tutorials=ISOrganizationManager.sharedInstance.getAllTutorialLinks();
  }

  _showTutorials(String url) async{
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          iconTheme: IconThemeData(
            color: AppColors.black, //change your color here
          ),
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: AppColors.gray_light),
          title: Text(AppStrings.menu_tutorial_video,style: AppStyles.appHeadertitle.copyWith(color: AppColors.black)),
          backgroundColor: AppColors.gray_light,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SafeArea(
            top: false,
            child:Container(
              margin: AppDimens.activity_margin_large,
              child:  Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(""+tutorials.length.toString()+" tutorial video(s) found",style: AppStyles.textMediumRegular.copyWith(color: AppColors.text_color_primary)),
                      SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: tutorials.length,
                        itemBuilder: (context, index) {
                          return Container(
                              padding: EdgeInsets.only(bottom: 8,top: 0),
                              child:InkWell(
                                onTap: (){
                                  _showTutorials(tutorials[index].szUrl);
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 5),
                                   Container(
                                     child:Text(tutorials[index].szTitle),
                                   ),
                                    SizedBox(height: 12),
                                    Divider(height: 1)
                                  ],
                                ),
                              )
                          );
                        },
                      ),
                    ],
                  )    ),
            ),
          ),
        ));
  }
}

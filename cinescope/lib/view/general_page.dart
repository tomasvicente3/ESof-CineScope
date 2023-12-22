import 'package:cinescope/model/providers/profile_provider.dart';
import 'package:cinescope/model/providers/required_provider.dart';
import 'package:cinescope/model/providers/watchlist_provider.dart';
import 'package:cinescope/view/bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

abstract class GeneralPage extends StatefulWidget {
  final Widget? floatingActionButton;
  final bool needsProviders;
  const GeneralPage({super.key, this.floatingActionButton, this.needsProviders = false});

  @override
  State<StatefulWidget> createState();
}

abstract class GeneralPageState<T extends GeneralPage> extends State<T> {


  Widget getTitle(BuildContext context);

  final Map<Type, bool> providersRequired = {
    WatchlistProvider: false,
    ProfileProvider: false
  };

  bool loaded = false;

  @override
  void initState(){
    super.initState();
    if(widget.needsProviders){
      Future.delayed(Duration.zero, () {
        handleProvider(Provider.of<WatchlistProvider>(context, listen: false));
        handleProvider(Provider.of<ProfileProvider>(context, listen: false));
      });
    }

  }

  Widget generalPageRender(){
    return Scaffold(
        body: Container(
            color: const Color(0XFF07393C),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 0)),
              getTitle(context),
              Expanded(
                  child: Stack(
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView(
                          key: const Key("body-list"),
                          shrinkWrap: true,
                          children: getBody(context))),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: widget.floatingActionButton ?? Container(),
                  )
                ],
              )),
              const BottomBar()
            ])));
  }

  Future<void> updateProvider<Prov extends RequiredProvider>(Prov requiredProvider)async {
    providersRequired[Prov] = requiredProvider.lastLoaded;
    //Logger().i(providersRequired);
    if(providersRequired.values.reduce((value, element) => value == true && element == true)){
      setState(() {
        loaded = true;
      });
    } else {
      setState(() {
        loaded = false;
      });
    }
  }

  Future<void> handleProvider<Prov extends RequiredProvider>(Prov requiredProvider) async{
    await updateProvider(requiredProvider);
    if(loaded){
      return;
    }
    requiredProvider.loaded.listen((event) {
      updateProvider(requiredProvider);
    });

  }

  List<Widget> getBody(BuildContext context);
  @override
  Widget build(BuildContext context) {
    if(widget.needsProviders){
      if(loaded){
        return generalPageRender();
      } 
      return const Scaffold(body: Center(child: CircularProgressIndicator(),),);
    }
    return generalPageRender();

  }
}



class GlobalScenarioState{
  String previousProfileName = "";
  String previousProfileBio = "";

  static final GlobalScenarioState _instance = GlobalScenarioState._internal();

  factory GlobalScenarioState(){
    return _instance;
  }

  GlobalScenarioState._internal();
}
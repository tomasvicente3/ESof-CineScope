extension DurationStringFormatter on Duration{

  static final formattingRegExp = RegExp('{}');

  String toFormattedString(String singularPhrase, String pluralPhrase, {String term = "{}"}){
    if (!singularPhrase.contains(term) || !pluralPhrase.contains(term)) {
      throw ArgumentError("singularPhrase or plurarPhrase don't have a string that can be formatted");
    }
    if(inSeconds == 1){
      return singularPhrase.replaceAll(formattingRegExp, "$inSeconds second");
    }
    if(inSeconds < 60){
      return pluralPhrase.replaceAll(formattingRegExp, "$inSeconds seconds");
    }
    if(inMinutes == 1){
      return singularPhrase.replaceAll(formattingRegExp, "$inMinutes minute");
    }
    if(inMinutes < 60){
      return pluralPhrase.replaceAll(formattingRegExp, "$inMinutes minutes");
    }
    if(inHours == 1){
      return singularPhrase.replaceAll(formattingRegExp, "$inHours hour");
    }
    if(inHours < 24){
      return pluralPhrase.replaceAll(formattingRegExp, "$inHours hours");
    }
    if(inDays == 1){
      return singularPhrase.replaceAll(formattingRegExp, "$inDays day");
    }
    if(inDays <= 7){
      return pluralPhrase.replaceAll(formattingRegExp, "$inDays days");

    }
    if((inDays / 7).floor() == 1){
      return singularPhrase.replaceAll(formattingRegExp, "${(inDays / 7).floor()} week");
    }
    if((inDays / 7).floor() > 1){
      return pluralPhrase.replaceAll(formattingRegExp, "${(inDays / 7).floor()} weeks");
    } 
    if((inDays / 30).floor() == 1){
      return singularPhrase.replaceAll(formattingRegExp, "${(inDays / 30).floor()} month");
    }
    return pluralPhrase.replaceAll(formattingRegExp, "${(inDays / 30).floor()} months");

  }
}
/// Converts the [String] sent by the server into a [DateTime] object
DateTime convertDate(String date){
List<String> dateParts = date.split("/");
    int day = int.parse(dateParts[0]);
    int month = int.parse(dateParts[1]);
    int year = int.parse(dateParts[2]);

    return new DateTime(year, month, day);
}
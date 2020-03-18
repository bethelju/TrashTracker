class Entry{
  int id;
  String latitude;
  String longitude;
  int number_submissions;
  var now; 
  Entry(int id, String latitude, String longitude, int number_submissions, String now){
    this.id = id;
    this.latitude = latitude;
    this.longitude = longitude;
    this.number_submissions = number_submissions;
    this.now = now;
  }
}
abstract class EventRepository {
  Future<String> loadEvent();
  Future saveEvent(String todos);

  Future<String> loadUser();
  Future saveUser(String user);

  Future<String> loadInfoUser();
  Future saveInfoUser(String inforUser);

  Future saveUserID(String userID);
}

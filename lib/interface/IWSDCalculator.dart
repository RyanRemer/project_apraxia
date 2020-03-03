import 'package:project_apraxia/model/Attempt.dart';

abstract class IWSDCalculator {

  /*
  * Sends a file to the local or backend ambiance calculators to calculate an
  * ambiance threshold to be used when calculating the WSD for the rest of the
  * session.
  *
  * @param fileName: String of where the recording is located
  *
  * @return: void
  */
  Future<void> setAmbiance(String fileName, {String evalId: ""});

  /*
  * Calculates a WSD for the given filename, stores it, and sends back the ID
  * and the calculated WSD. The setAmbiance() function is required to be run
  * before this in order to have an evaluationId to send.
  *
  * @param fileName: String of where the recording is located
  * @param word: The string representation of the word being said in the recording, i.e. "gingerbread"
  * @param syllableCount: The number of syllables in the word
  * @param evaluationId: The ID tied to the ambiance evaluation. Returned from setAmbiance()
  *
  * @return [String attemptID, double WSD]: A tuple list, with the attemptId and the WSD, i.e. [42, 310.448]
  *
  */
  Future<Attempt> addAttempt(String fileName, String word, int syllableCount, String evaluationId);

  /*
  * This returns a list that represents amplitude values for the given filename
  * in order to be used in things like a waveform diagram.
  *
  * @param fileName: String of where the recording is located
  *
  * @return: A list of doubles representing the raw amplitude values from the file
  */
  Future<List<double>> getAmplitudes(String fileName);

  /*
  * This updates an attempt to be active or inactive when set on the Reports page.
  *
  * @param evalId: String of the evaluation ID
  * @param attemptId: String of the attempt ID
  * @param active: boolean value to set the attempt status to
  *
  * @return: void
  */
  Future<void> updateAttempt(String evalId, String attemptId, bool active);
}
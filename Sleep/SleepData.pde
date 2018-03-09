import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Collections;
import java.io.File;

public class SleepData
{
  String date;
  
  JSONObject sleep;
  JSONObject levels;
  JSONArray data;
  
  boolean INVALID = false;
  
  SleepData(String date){
    try {
      this.date = date;
      String path = "D:/My Document/ProcessingFiles/CS383_Project2/DataCapture/data";
      String filePath = new String(Paths.get(path, this.date+".json").toString());

      String json = loadFile(filePath);
      JSONObject obj = parseJSONObject(json);
      sleep = obj.getJSONArray("sleep").getJSONObject(0);
      levels = sleep.getJSONObject("levels");
      data = levels.getJSONArray("data");
    } 
    catch(Exception ex) {
      println(ex.toString());
      INVALID = true;
    }
  }
  
  public JSONArray getData(){
    return data;
  }
  
    // Load a json file into one giant String
  private String loadFile(String path) {
    String[] lines = loadStrings(path);

    if (lines == null || lines.length <= 0) {
      println("Fail to load file: "+path);
      return null;
    }

    String oneString = "";
    for (int i=0; i<lines.length; i++) {
      oneString += lines[i];
    }
    return oneString;
  }
}
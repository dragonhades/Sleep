import http.requests.*;
import java.net.URI;
import java.awt.*; 
import java.io.BufferedWriter;
import java.io.FileWriter;

String code = "53112ede50035c70e1aa05752d5a8d5be0ec6fdb";
String date = "2018-03-03";

void setup(){  
  getSleep(date);
}

String getSleep(String date){
  String s = getAuth();
  println(s);
  JSONObject obj = parseJSONObject(s);
  String token = (String)obj.get("access_token");
  String reftk = (String)obj.get("refresh_token");
  String uid = (String)obj.get("user_id");
  
  return GET(token, date);
}

String GET(String tk, String date) {
  println("GET ===================");
  String reqURL = "https://api.fitbit.com/1.2/user/-/sleep/date/"+date+".json";
  GetRequest get = new GetRequest(reqURL); 
  get.addHeader("Authorization", "Bearer "+tk);
  get.send();
  println("Reponse Content: " + get.getContent());
  //println("Reponse Content-Length Header: " + get.getHeader("Content-Length"));
  
  String path = date+".json";
  File f = new File(dataPath(path));
  createFile(f);
  try {
    PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(f, true)));
    out.println(get.getContent());
    out.close();
  }catch (IOException e){
    e.printStackTrace();
  } 
  return get.getContent();
}


String getAuth() {
  HttpClient httpClient = new DefaultHttpClient();

  try
  {
    URIBuilder uriBuilder = new URIBuilder("https://api.fitbit.com/oauth2/token");

    URI uri = uriBuilder.build();
    HttpPost request = new HttpPost(uri);

    request.setHeader("Content-Type", "application/x-www-form-urlencoded");
    request.setHeader("Authorization", "Basic MjJDTjJUOjkyZjllNWQ5OGM5YmQxMGQwMzI3N2ZkZjNlYTBlYmE1");

    // Request body. Replace the example URL below with the URL of the image you want to analyze.
    StringEntity reqEntity = new StringEntity("grant_type=authorization_code&redirect_uri=https://localhost&code="+code);
    request.setEntity(reqEntity);

    HttpResponse response = httpClient.execute(request);
    HttpEntity entity = response.getEntity();

    if (entity != null)
    {
      //println(EntityUtils.toString(entity));
      return new String(EntityUtils.toString(entity));
    } else {
      throw new Exception("Entity is null.");
    }
  }
  catch (Exception e)
  {
    println(e.getMessage());
    return null;
  }
}

void createFile(File f){
  File parentDir = f.getParentFile();
  try{
    parentDir.mkdirs(); 
    f.createNewFile();
  }catch(Exception e){
    e.printStackTrace();
  }
}
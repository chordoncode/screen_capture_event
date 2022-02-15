package id.nizwar.screen_capture_event;

import android.os.Build;
import android.os.Environment;
import android.os.FileObserver;
import android.os.Handler;
import android.os.Looper;
import android.view.WindowManager;
import android.webkit.MimeTypeMap;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** ScreenCaptureEventPlugin */
public class ScreenCaptureEventPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private MethodChannel channel;
  private FileObserver fileObserver;
  private Timer timeout = new Timer();
  private final Map<String,FileObserver> watchModifier = new HashMap<>();
  private ActivityPluginBinding activityPluginBinding;
  private Handler handler;
  private boolean screenRecording = false;
  private long tempSize = 0;


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "screencapture_method");
    channel.setMethodCallHandler(this);
  }


  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch(call.method){
      case "prevent_screenshot":
        if((boolean)call.arguments){
          activityPluginBinding.getActivity().getWindow().addFlags(WindowManager.LayoutParams.FLAG_SECURE);
        }else{
          activityPluginBinding.getActivity().getWindow().clearFlags(WindowManager.LayoutParams.FLAG_SECURE);
        }
        break;
      case "isRecording":
        result.success(screenRecording);
        break;
      case"watch":
        handler = new Handler(Looper.getMainLooper());

        //updateScreenRecordStatus();
        if(Build.VERSION.SDK_INT >=29){
          final List<File> files = new ArrayList<>();
          final List<String> paths = new ArrayList<>();
          for (Path path : Path.values()) {
            files.add(new File(path.getPath()));
            paths.add(path.getPath());
          }
          fileObserver = new FileObserver(files) {
            @Override
            public void onEvent(int event, final String filename) {
              if (event == FileObserver.CREATE) {
                handler.post(() -> {
                  for(String fullPath : paths){
                    File file = new File(fullPath + filename);

                    if(file.exists()){
                      if(getMimeType(file.getPath()).contains("image")){
                        channel.invokeMethod("screenshot", file.getPath());
                      }
                    }
                  }
                });
              }
            }
          };
          fileObserver.startWatching();
        }else{
          for (final Path path : Path.values()) {
            fileObserver = new FileObserver(path.getPath()) {
              @Override
              public void onEvent(int event, final String filename) {

                //updateScreenRecordStatus();
                if (event == FileObserver.CREATE) {
                  File file = new File(path.getPath() + filename);

                  handler.post(() -> {
                    if(file.exists()){
                      if(getMimeType(file.getPath()).contains("image")){
                        channel.invokeMethod("screenshot", file.getPath());
                      }
                    }
                  });
                }
              }
            };
            fileObserver.startWatching();
          }
        }
        break;
      case "dispose":
        if(fileObserver!=null) fileObserver.stopWatching();
        for (Map.Entry<String, FileObserver> stringObjectEntry : watchModifier.entrySet()) {
          stringObjectEntry.getValue().stopWatching();
        }
        watchModifier.clear();
        break;
      default:
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }


  public static String getMimeType(String url) {
    url = url.replaceAll(" ", "");
    String type = null;
    String extension = MimeTypeMap.getFileExtensionFromUrl(url);
    if (extension != null) {
      type = MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension);
    }
    return type;
  }

  public static File getLastModified(String directoryFilePath)
  {
    File directory = new File(directoryFilePath);
    if(directory.listFiles() == null) return null;
    File[] files = directory.listFiles(File::isFile);
    long lastModifiedTime = Long.MIN_VALUE;
    File chosenFile = null;

    if (files != null)
    {
      for (File file : files)
      {
        if (file.lastModified() > lastModifiedTime)
        {
          chosenFile = file;
          lastModifiedTime = file.lastModified();
        }
      }
    }

    return chosenFile;
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activityPluginBinding = binding;

  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {

  }

  @Override
  public void onDetachedFromActivity() {

  }

  public enum Path {
    DCIM(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DCIM) + File.separator + "Screenshots" + File.separator),
    PICTURES(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES ) + File.separator + "Screenshots" + File.separator);

    final private String path;

    public String getPath() {
      return path;
    }

    Path(String path) {
      this. path = path;
    }
  }

}

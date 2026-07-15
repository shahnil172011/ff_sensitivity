# Flutter specific
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep our app classes
-keep class com.unknown.ff_sensitivity_ai.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep annotations
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keepattributes Signature

# Keep all classes with @Keep annotation
-keep @interface androidx.annotation.Keep
-keep @androidx.annotation.Keep class *
-keepclassmembers class * {
    @androidx.annotation.Keep *;
}

# AndroidX
-keep class androidx.** { *; }
-keep interface androidx.** { *; }
-dontwarn androidx.**

# Google Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Firebase (if used)
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# OkHttp
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# Image library
-keep class com.bumptech.glide.** { *; }
-dontwarn com.bumptech.glide.**

# Permissions
-keep class com.baseflow.permissionhandler.** { *; }

# Device info
-keep class com.unknown.ff_sensitivity_ai.** { *; }

# Optimization flags
-optimizationpasses 5
-dontpreverify
-dontskipnonpubliclibraryclasses
-dontskipnonpubliclibraryclassmembers

# Keep our custom models
-keep class com.unknown.ff_sensitivity_ai.models.** { *; }
-keep class com.unknown.ff_sensitivity_ai.providers.** { *; }
-keep class com.unknown.ff_sensitivity_ai.services.** { *; }

# Keep all Flutter engine classes
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.embedding.android.** { *; }

# Keep all plugin classes
-keep class * extends io.flutter.plugin.common.PluginRegistry.ActivityResultListener { *; }
-keep class * extends io.flutter.plugin.common.PluginRegistry.RequestPermissionsResultListener { *; }

# Keep all View classes used in Flutter
-keep class * extends android.view.View { *; }

# Keep all Activity classes
-keep class * extends android.app.Activity { *; }

# Keep all Service classes
-keep class * extends android.app.Service { *; }

# Keep all BroadcastReceiver classes
-keep class * extends android.content.BroadcastReceiver { *; }

# Keep all ContentProvider classes
-keep class * extends android.content.ContentProvider { *; }

# Keep all Fragment classes
-keep class * extends android.app.Fragment { *; }
-keep class * extends androidx.fragment.app.Fragment { *; }

# Remove debug code
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
    public static *** w(...);
    public static *** e(...);
}
# Chatbot Voice Version 

본 프로젝트는 flutter를 활용하여 음성으로 GPT와 대화하는 미니 앱 프로젝트입니다.

## 준비

VScode, Flutter, OpenAI Key, pubspec.yaml 을 통해 버전을 확인하세요! <br/>

그리고 권한 설정을 위해서 <br/>

\flutter_voice\android\app\src\main\AndroidManifest.xml <br/>



<?xml version="1.0" encoding="utf-8"?> <br/>
<manifest xmlns:android="http://schemas.android.com/apk/res/android" <br/>
package="com.example.flutter_voice"> <br/>


<uses-permission android:name="android.permission.RECORD_AUDIO"/> <br/>
<uses-permission android:name="android.permission.INTERNET"/> <br/>

이렇게 해서 권한 설정을 해야됨을 꼭 참고하세요.

## 참고

- URL1 = https://www.youtube.com/watch?v=2Dea-jJ1SmA&t=1076s  <br/>
- URL2 = https://www.youtube.com/watch?v=KvBELME1fps&t=22s <br/>
# Fountains iOS

iOS app to search for drinking fountains nearby.

## KMM

This project relies on a library written in [Kotlin Multiplatform Mobile][kmm].
You need to have the [android project][android] in your local machine, with the
following folder structure:

```sh
> ls
android       ios
```

Then run the compile command on the android projects root folder:

```sh
./gradlew :WaterFountains:assembleXCFramework
```

After that, you can open this project in Xcode as usual.

[kmm]: https://kotlinlang.org/lp/mobile/
[android]: https://github.com/marionauta/fountains-android

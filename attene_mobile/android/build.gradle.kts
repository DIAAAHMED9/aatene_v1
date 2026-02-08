allprojects {
    repositories {
        google()
        mavenCentral()
    }

    // Load Flutter properties from local.properties
    val localProperties = java.util.Properties()
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        localPropertiesFile.inputStream().use { localProperties.load(it) }
    }

    val fCompileSdk = localProperties.getProperty("flutter.compileSdkVersion")?.toIntOrNull() ?: 35
    val fMinSdk = localProperties.getProperty("flutter.minSdkVersion")?.toIntOrNull() ?: 21
    val fTargetSdk = localProperties.getProperty("flutter.targetSdkVersion")?.toIntOrNull() ?: 35
    val fVersionCode = localProperties.getProperty("flutter.versionCode")?.toIntOrNull() ?: 1
    val fVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0.0"

    // Inject 'flutter' property into every project's extra properties.
    // This is required by many Flutter plugins that haven't been updated to the new Gradle plugin system,
    // as they expect a 'flutter' object to be available to get SDK versions.
    project.extensions.extraProperties.set("flutter", mapOf(
        "compileSdkVersion" to fCompileSdk,
        "minSdkVersion" to fMinSdk,
        "targetSdkVersion" to fTargetSdk,
        "versionCode" to fVersionCode,
        "versionName" to fVersionName
    ))
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
